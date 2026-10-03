import Foundation

// Foto que deja la app (ver writeWidget() en index.html). Solo cucharas y
// tareas pendientes de hoy y mañana; title solo si se activó en Ajustes.
struct WSnapshot: Decodable {
    let v: Int
    let lang: String?
    let dayStartHour: Int?
    let showTitles: Bool?
    let days: [String: WDay]
}

struct WDay: Decodable {
    let budget: Double?
    let left: Double?
    let doneCount: Int
    let totalCount: Int
    let pendingCount: Int
    let pending: [WTask]
}

struct WTask: Decodable, Hashable, Identifiable {
    let id: String
    let time: String?
    let cost: Double?
    let title: String?
}

enum WidgetStore {
    static func snapshot() -> WSnapshot? {
        guard let json = WidgetShared.defaults?.string(forKey: WidgetShared.snapshotKey) else { return nil }
        return try? JSONDecoder().decode(WSnapshot.self, from: Data(json.utf8))
    }
}

// El día de la app no cambia a medianoche sino a la hora elegida (04:00 por
// defecto), igual que todayKey() en index.html.
enum DayClock {
    static func key(for date: Date, startHour: Int) -> String {
        let cal = Calendar.current
        var d = date
        if cal.component(.hour, from: date) < startHour {
            d = cal.date(byAdding: .day, value: -1, to: date) ?? date
        }
        let c = cal.dateComponents([.year, .month, .day], from: d)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }

    static func nextBoundary(after date: Date, startHour: Int) -> Date {
        Calendar.current.nextDate(after: date,
                                  matching: DateComponents(hour: startHour, minute: 0, second: 0),
                                  matchingPolicy: .nextTime) ?? date.addingTimeInterval(3600)
    }
}

// Con hora primero, de más temprano a más tarde; sin hora al final, en el
// orden en que se añadieron (la misma regla que la lista de Hoy).
func sortedByTime(_ list: [WTask]) -> [WTask] {
    list.enumerated().sorted { a, b in
        switch (a.element.time, b.element.time) {
        case let (x?, y?): return x == y ? a.offset < b.offset : x < y
        case (.some, .none): return true
        case (.none, .some): return false
        case (.none, .none): return a.offset < b.offset
        }
    }.map(\.element)
}

// Lo que se pinta: la foto de la app más lo marcado en el widget que la app
// aún no ha aplicado. El widget nunca cambia los datos de las tareas.
struct WidgetState {
    var lang: String?
    var dateKey: String
    var budget: Double?
    var left: Double
    var doneCount: Int
    var totalCount: Int
    var pending: [WTask]
    var pendingCount: Int
    var showTitles: Bool
    var undo: WidgetShared.LastAction?

    var rows: [WTask] { Array(pending.prefix(3)) }
    var moreCount: Int { max(0, pendingCount - rows.count) }
    var firstTimedId: String? { rows.first { $0.time != nil }?.id }

    static func load(at date: Date) -> WidgetState {
        let snap = WidgetStore.snapshot()
        let key = DayClock.key(for: date, startHour: snap?.dayStartHour ?? 4)
        let day = snap?.days[key]
        var s = WidgetState(lang: snap?.lang, dateKey: key, budget: day?.budget, left: day?.left ?? 0,
                            doneCount: day?.doneCount ?? 0, totalCount: day?.totalCount ?? 0,
                            pending: day?.pending ?? [], pendingCount: day?.pendingCount ?? 0,
                            showTitles: snap?.showTitles == true, undo: nil)
        let events = WidgetShared.readEvents().filter { $0.date == key }
        // Solo cuenta el último evento de cada tarea, igual que al aplicarlos en la app.
        var last: [String: WidgetShared.Event] = [:]
        for e in events { last[e.taskId] = e }
        for e in last.values.sorted(by: { $0.at < $1.at }) {
            let listed = s.pending.contains { $0.id == e.taskId }
            if e.type == "done", listed {
                s.pending.removeAll { $0.id == e.taskId }
                s.pendingCount -= 1
                s.doneCount += 1
                s.left -= e.cost ?? 0
            } else if e.type == "undo", !listed, s.doneCount > 0 {
                // La app ya la había aplicado como hecha: vuelve a la lista.
                s.pending = sortedByTime(s.pending + [WTask(id: e.taskId, time: e.time, cost: e.cost, title: nil)])
                s.pendingCount += 1
                s.doneCount -= 1
                s.left += e.cost ?? 0
            }
        }
        if let la = WidgetShared.lastAction(), la.date == key,
           events.contains(where: { $0.id == la.eventId && $0.type == "done" }) {
            s.undo = la
        }
        return s
    }

    static let sample = WidgetState(
        lang: Locale.current.language.languageCode?.identifier == "en" ? "en" : "es",
        dateKey: "", budget: 8, left: 5, doneCount: 1, totalCount: 5,
        pending: [WTask(id: "a", time: "18:00", cost: 2, title: nil),
                  WTask(id: "b", time: "20:30", cost: 1, title: nil),
                  WTask(id: "c", time: nil, cost: 1, title: nil)],
        pendingCount: 4, showTitles: false, undo: nil)
}
