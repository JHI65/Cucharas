import Foundation

// Lo que comparten la app y el widget a través del App Group. Va en los dos
// targets y compila con el mínimo de la app (iOS 15.4).
enum WidgetShared {
    static let appGroup = "group.com.spoony.app"
    static let snapshotKey = "widget.snapshot"
    static let lastActionKey = "widget.lastAction"

    static var defaults: UserDefaults? { UserDefaults(suiteName: appGroup) }

    // Un archivo por evento: leer y borrar nunca pisa uno que llega a la vez.
    static var eventsDir: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent("WidgetEvents", isDirectory: true)
    }

    struct Event: Codable {
        let id: String
        let type: String      // "done" | "undo"
        let taskId: String
        let date: String      // día de la app, YYYY-MM-DD
        let at: String        // ISO 8601 con milisegundos, UTC: ordena como texto
        let cost: Double?
        let time: String?
    }

    // Lo último que marcó el widget, para poder deshacerlo. Sin título si los
    // nombres están ocultos.
    struct LastAction: Codable {
        let eventId: String
        let taskId: String
        let date: String
        var title: String?
        let cost: Double?
        let time: String?
    }

    static func nowISO() -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.string(from: Date())
    }

    static func writeEvent(_ e: Event) throws {
        guard let dir = eventsDir else { throw CocoaError(.fileNoSuchFile) }
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try JSONEncoder().encode(e).write(to: dir.appendingPathComponent(e.id + ".json"), options: .atomic)
    }

    static func readEvents() -> [Event] {
        guard let dir = eventsDir,
              let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
        else { return [] }
        return files.filter { $0.pathExtension == "json" }
            .compactMap { url in (try? Data(contentsOf: url)).flatMap { try? JSONDecoder().decode(Event.self, from: $0) } }
            .sorted { $0.at < $1.at }
    }

    static func deleteEvents(ids: [String]) {
        guard let dir = eventsDir else { return }
        for id in ids where !id.isEmpty && !id.contains("/") && !id.contains("..") {
            try? FileManager.default.removeItem(at: dir.appendingPathComponent(id + ".json"))
        }
    }

    static func lastAction() -> LastAction? {
        guard let data = defaults?.data(forKey: lastActionKey) else { return nil }
        return try? JSONDecoder().decode(LastAction.self, from: data)
    }

    static func setLastAction(_ action: LastAction?) {
        if let action, let data = try? JSONEncoder().encode(action) {
            defaults?.set(data, forKey: lastActionKey)
        } else {
            defaults?.removeObject(forKey: lastActionKey)
        }
    }
}
