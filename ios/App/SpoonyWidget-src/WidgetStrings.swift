import Foundation

// Textos del widget en el idioma elegido en la app (no el del móvil), que
// llega en la foto. Mismas palabras que la app.
struct WText {
    let en: Bool
    init(_ lang: String?) { en = lang == "en" }

    var today: String { en ? "Today" : "Hoy" }
    var unset: String { en ? "Spoons not set" : "Cucharas sin definir" }
    var undo: String { en ? "Undo" : "Deshacer" }
    var noPending: String { en ? "No pending tasks" : "Sin tareas pendientes" }
    var task: String { en ? "Task" : "Tarea" }
    var noTime: String { en ? "no time" : "sin hora" }
    var noCost: String { en ? "no cost" : "sin coste" }

    func freeOf(_ budget: Double) -> String { en ? "free of \(num(budget))" : "libres de \(num(budget))" }
    func below(_ n: Double) -> String { en ? "\(num(n)) below" : "\(num(n)) por debajo" }
    func doneOf(_ done: Int, _ total: Int) -> String { en ? "\(done) of \(total) done" : "\(done) de \(total) hechas" }
    func more(_ n: Int) -> String { en ? "\(n) more in the app" : "\(n) más en la app" }
    func doneName(_ name: String) -> String { en ? "Done: \(name)" : "Hecha: \(name)" }

    func spoons(_ cost: Double?) -> String {
        guard let c = cost else { return noCost }
        let n = abs(c)
        let unit = n == 1 ? (en ? "spoon" : "cuchara") : (en ? "spoons" : "cucharas")
        let base = "\(num(n)) \(unit)"
        return c < 0 ? (en ? "recharge \(base)" : "recarga \(base)") : base
    }
    func meta(_ t: WTask) -> String { "\(t.time ?? noTime) · \(spoons(t.cost))" }

    // Accesibilidad
    func markDone(_ name: String?) -> String {
        en ? "Mark \(name ?? "task") as done" : "Marcar \(name ?? "tarea") como hecha"
    }
    func undoLabel(_ name: String?) -> String {
        en ? "Undo: \(name ?? "task") back to pending" : "Deshacer: \(name ?? "tarea") vuelve a pendiente"
    }
    func meterLabel(left: Double, budget: Double) -> String {
        if left < 0 {
            return en ? "0 free of \(num(budget)), \(num(-left)) below what was assigned today"
                      : "0 libres de \(num(budget)), \(num(-left)) por debajo de lo asignado hoy"
        }
        return en ? "\(num(left)) free of \(num(budget))" : "\(num(left)) libres de \(num(budget))"
    }

    func num(_ x: Double) -> String {
        if x == x.rounded() { return String(Int(x)) }
        let s = String(format: "%.1f", x)
        return en ? s : s.replacingOccurrences(of: ".", with: ",")
    }
}

// Nombre y descripción en la galería de widgets: ahí aún no hay foto, así que
// siguen el idioma del móvil.
enum GalleryText {
    static var en: Bool { Locale.current.language.languageCode?.identifier == "en" }
    static var name: String { en ? "Today in Spoony" : "Hoy en Spoony" }
    static var description: String {
        en ? "Free spoons and your next tasks. Task names stay hidden unless you turn them on in Spoony."
           : "Cucharas libres y tus próximas tareas. Los nombres no se ven salvo que lo actives en Spoony."
    }
}
