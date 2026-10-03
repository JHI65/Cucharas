import AppIntents
import WidgetKit

// Corren en el widget sin abrir la app: solo apuntan un evento en la cola.
// La app lo aplica al volver a primer plano, con la misma función que el
// check de la lista. Tras perform() el sistema recarga el widget.
struct MarkDoneIntent: AppIntent {
    static let title: LocalizedStringResource = "Marcar tarea como hecha"
    static let isDiscoverable: Bool = false
    static let openAppWhenRun: Bool = false

    @Parameter(title: "Tarea") var taskId: String
    @Parameter(title: "Día") var date: String
    @Parameter(title: "Coste") var cost: Double?
    @Parameter(title: "Hora") var time: String?

    init() {}
    init(task: WTask, date: String) {
        self.taskId = task.id
        self.date = date
        self.cost = task.cost
        self.time = task.time
    }

    func perform() async throws -> some IntentResult {
        let e = WidgetShared.Event(id: UUID().uuidString, type: "done", taskId: taskId, date: date,
                                   at: WidgetShared.nowISO(), cost: cost, time: time)
        try WidgetShared.writeEvent(e)
        let snap = WidgetStore.snapshot()
        let title = snap?.showTitles == true ? snap?.days[date]?.pending.first { $0.id == taskId }?.title : nil
        WidgetShared.setLastAction(.init(eventId: e.id, taskId: taskId, date: date, title: title, cost: cost, time: time))
        return .result()
    }
}

struct UndoDoneIntent: AppIntent {
    static let title: LocalizedStringResource = "Deshacer tarea hecha"
    static let isDiscoverable: Bool = false
    static let openAppWhenRun: Bool = false

    @Parameter(title: "Tarea") var taskId: String
    @Parameter(title: "Día") var date: String
    @Parameter(title: "Coste") var cost: Double?
    @Parameter(title: "Hora") var time: String?

    init() {}
    init(_ last: WidgetShared.LastAction) {
        self.taskId = last.taskId
        self.date = last.date
        self.cost = last.cost
        self.time = last.time
    }

    func perform() async throws -> some IntentResult {
        try WidgetShared.writeEvent(.init(id: UUID().uuidString, type: "undo", taskId: taskId, date: date,
                                          at: WidgetShared.nowISO(), cost: cost, time: time))
        WidgetShared.setLastAction(nil)
        return .result()
    }
}
