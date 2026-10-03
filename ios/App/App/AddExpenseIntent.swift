import AppIntents
import Foundation

// Acción de Atajos "Añadir gasto en Spoony". Corre sin abrir la app: deja cada
// pago como un archivo en Library/SpoonyGastos y la web lo recoge al abrirse
// (un archivo por pago, así leer y borrar nunca pisa a uno que llega a la vez).
@available(iOS 16.0, *)
struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Añadir gasto en Spoony"
    static var description = IntentDescription("Apunta un pago en los gastos variables de Spoony sin abrir la app. Aparece la próxima vez que abras Spoony.")
    static var openAppWhenRun: Bool = false

    // Texto y no número: Cartera pasa el importe con moneda ("12,50 €") y la
    // app lo interpreta al importarlo.
    @Parameter(title: "Importe")
    var amount: String

    @Parameter(title: "Comercio")
    var merchant: String?

    static var parameterSummary: some ParameterSummary {
        Summary("Añadir gasto de \(\.$amount) en \(\.$merchant)")
    }

    func perform() async throws -> some IntentResult {
        let dir = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SpoonyGastos", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let id = UUID().uuidString
        let item: [String: Any] = [
            "id": id,
            "importe": amount,
            "comercio": merchant ?? "",
            "fecha": ISO8601DateFormatter().string(from: Date())
        ]
        let data = try JSONSerialization.data(withJSONObject: item)
        try data.write(to: dir.appendingPathComponent(id + ".json"), options: .atomic)
        return .result()
    }
}
