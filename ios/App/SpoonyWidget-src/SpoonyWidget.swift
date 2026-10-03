import SwiftUI
import WidgetKit

@main
struct SpoonyWidgetBundle: WidgetBundle {
    var body: some Widget { SpoonyTodayWidget() }
}

struct SpoonyTodayWidget: Widget {
    let kind = "SpoonyToday"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayProvider()) { entry in
            TodayWidgetView(state: entry.state)
                .containerBackground(for: .widget) { Palette.background }
        }
        .configurationDisplayName(GalleryText.name)
        .description(GalleryText.description)
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}

struct TodayEntry: TimelineEntry {
    let date: Date
    let state: WidgetState
}

// Predecible: una entrada ahora y otra cuando empieza el día siguiente. Nada
// cambia por tiempo dentro del día; tras cada toque el sistema recarga.
struct TodayProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayEntry { TodayEntry(date: .now, state: .sample) }

    func getSnapshot(in context: Context, completion: @escaping (TodayEntry) -> Void) {
        completion(TodayEntry(date: .now, state: context.isPreview ? .sample : .load(at: .now)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayEntry>) -> Void) {
        let now = Date()
        let next = DayClock.nextBoundary(after: now, startHour: WidgetStore.snapshot()?.dayStartHour ?? 4)
        completion(Timeline(entries: [TodayEntry(date: now, state: .load(at: now)),
                                      TodayEntry(date: next, state: .load(at: next))],
                            policy: .atEnd))
    }
}

// Tamaños del diseño a texto normal; suben con el texto dinámico hasta donde
// cabe en un widget mediano.
struct Scaled {
    let factor: CGFloat
    init(_ size: DynamicTypeSize) {
        switch size {
        case .xSmall: factor = 0.85
        case .small: factor = 0.9
        case .medium: factor = 0.95
        case .large: factor = 1
        case .xLarge: factor = 1.1
        default: factor = 1.2
        }
    }
    func font(_ base: CGFloat, _ weight: Font.Weight = .regular) -> Font { .system(size: base * factor, weight: weight) }
}

struct TodayWidgetView: View {
    let state: WidgetState
    @Environment(\.dynamicTypeSize) private var typeSize
    private var t: WText { WText(state.lang) }
    private var sc: Scaled { Scaled(typeSize) }

    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top, spacing: 0) {
                left.frame(width: (geo.size.width - 10.5) * 0.34, alignment: .topLeading)
                Rectangle().fill(Palette.border).frame(width: 0.5).padding(.horizontal, 5)
                right.frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .padding(.top, 12).padding(.bottom, 12).padding(.trailing, 12).padding(.leading, 16)
        .overlay(ContainerRelativeShape().strokeBorder(Palette.border, lineWidth: 1))
    }

    // MARK: columna izquierda
    private var left: some View {
        VStack(alignment: .leading, spacing: 0) {
            Link(destination: URL(string: "spoony://today")!) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(t.today).font(sc.font(12)).foregroundStyle(Palette.secondary)
                    if let budget = state.budget {
                        Text(t.num(max(0, state.left)))
                            .font(.system(size: 34 * min(sc.factor, 1.1), weight: .medium))
                            .foregroundStyle(Palette.text)
                            .lineLimit(1).minimumScaleFactor(0.6)
                        Text(t.freeOf(budget)).font(sc.font(12)).foregroundStyle(Palette.secondary).lineLimit(1)
                        if state.left < 0 {
                            Text(t.below(-state.left)).font(sc.font(12)).foregroundStyle(Palette.secondary).lineLimit(1)
                        }
                        SpoonMeter(budget: budget, left: state.left)
                            .padding(.top, 6)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(t.meterLabel(left: state.left, budget: budget))
                    } else {
                        Text(t.unset).font(sc.font(14)).foregroundStyle(Palette.text)
                            .lineLimit(2).minimumScaleFactor(0.8).padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 4)
            footer
        }
        .minimumScaleFactor(0.8)
    }

    @ViewBuilder private var footer: some View {
        if let last = state.undo {
            let name = state.showTitles ? last.title : nil
            VStack(alignment: .leading, spacing: 0) {
                Text(t.doneName(name ?? t.task)).font(sc.font(12)).foregroundStyle(Palette.secondary).lineLimit(1)
                Button(intent: UndoDoneIntent(last)) {
                    Text(t.undo).font(sc.font(12, .semibold)).foregroundStyle(Palette.accent)
                        .frame(minHeight: 32, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(t.undoLabel(name))
            }
        } else if state.totalCount > 0 {
            Link(destination: URL(string: "spoony://today")!) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(t.doneOf(state.doneCount, state.totalCount))
                    if state.moreCount > 0 { Text(t.more(state.moreCount)) }
                }
                .font(sc.font(12)).foregroundStyle(Palette.secondary).lineLimit(1)
            }
        }
    }

    // MARK: columna derecha
    @ViewBuilder private var right: some View {
        if state.rows.isEmpty {
            Link(destination: URL(string: "spoony://today")!) {
                Text(t.noPending).font(sc.font(14)).foregroundStyle(Palette.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(spacing: 0) {
                ForEach(Array(state.rows.enumerated()), id: \.element.id) { i, task in
                    if i > 0 { Rectangle().fill(Palette.border).frame(height: 0.5) }
                    row(task)
                }
                Spacer(minLength: 0)
            }
        }
    }

    private func row(_ task: WTask) -> some View {
        let name = state.showTitles ? task.title : nil
        return HStack(spacing: 8) {
            Button(intent: MarkDoneIntent(task: task, date: state.dateKey)) {
                Circle().strokeBorder(Palette.accent, lineWidth: 2)
                    .frame(width: 32, height: 32)
                    .frame(width: 36, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(t.markDone(name))

            Link(destination: taskURL(task.id)) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(name ?? t.task)
                        .font(sc.font(14, task.id == state.firstTimedId ? .medium : .regular))
                        .foregroundStyle(Palette.text)
                    Text(t.meta(task)).font(sc.font(12)).foregroundStyle(Palette.secondary)
                }
                .lineLimit(1).minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
        .frame(height: 44)
    }

    private func taskURL(_ id: String) -> URL {
        let safe = id.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
        return URL(string: "spoony://task/\(safe)") ?? URL(string: "spoony://today")!
    }
}

struct SpoonMeter: View {
    let budget: Double
    let left: Double

    // Llenos = libres, vacíos = gastados. Por encima de lo asignado: segmentos
    // extra con borde discontinuo, sin cambiar de color. Hasta 12 por fila.
    var body: some View {
        let n = max(0, Int(budget.rounded(.up)))
        let extra = left < 0 ? Int((-left).rounded(.up)) : 0
        let total = min(24, n + extra)
        let perRow = max(1, min(12, total))
        let rows = stride(from: 0, to: total, by: perRow).map { Array($0..<min($0 + perRow, total)) }
        VStack(alignment: .leading, spacing: 3) {
            ForEach(rows, id: \.self) { r in
                HStack(spacing: 3) {
                    ForEach(0..<perRow, id: \.self) { j in
                        if j < r.count { segment(r[j], spent: n) } else { Color.clear.frame(height: 8) }
                    }
                }
            }
        }
    }

    @ViewBuilder private func segment(_ i: Int, spent n: Int) -> some View {
        if i < n {
            let fill = min(1, max(0, left - Double(i)))
            RoundedRectangle(cornerRadius: 3).fill(Palette.empty)
                .overlay(alignment: .leading) {
                    GeometryReader { g in
                        RoundedRectangle(cornerRadius: 3).fill(Palette.accent).frame(width: g.size.width * fill)
                    }
                }
                .frame(height: 8)
        } else {
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(Palette.secondary, style: StrokeStyle(lineWidth: 1, dash: [2, 2]))
                .frame(height: 8)
        }
    }
}
