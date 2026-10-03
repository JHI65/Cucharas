import Capacitor
import Foundation
import WidgetKit

// Puente entre index.html y el widget. Sin bundler, la web lo llama con
// Capacitor.nativePromise('SpoonyWidgetBridge', método, opciones).
@objc(SpoonyWidgetBridge)
public class SpoonyWidgetBridge: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SpoonyWidgetBridge"
    public let jsName = "SpoonyWidgetBridge"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "writeSnapshot", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "drainEvents", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "ackEvents", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "reload", returnType: CAPPluginReturnPromise)
    ]

    @objc func writeSnapshot(_ call: CAPPluginCall) {
        guard let json = call.getString("json"), let defaults = WidgetShared.defaults else {
            call.reject("No hay App Group o no llegan datos")
            return
        }
        defaults.set(json, forKey: WidgetShared.snapshotKey)
        // Con los nombres ocultos tampoco se queda ninguno en lo último que marcó el widget.
        let obj = (try? JSONSerialization.jsonObject(with: Data(json.utf8))) as? [String: Any]
        if obj?["showTitles"] as? Bool != true, var last = WidgetShared.lastAction(), last.title != nil {
            last.title = nil
            WidgetShared.setLastAction(last)
        }
        WidgetCenter.shared.reloadAllTimelines()
        call.resolve()
    }

    // Solo lee: la web borra con ackEvents después de guardar la foto nueva.
    @objc func drainEvents(_ call: CAPPluginCall) {
        let events = WidgetShared.readEvents().map { e -> [String: Any] in
            var d: [String: Any] = ["id": e.id, "type": e.type, "taskId": e.taskId, "date": e.date, "at": e.at]
            if let c = e.cost { d["cost"] = c }
            if let t = e.time { d["time"] = t }
            return d
        }
        call.resolve(["events": events])
    }

    @objc func ackEvents(_ call: CAPPluginCall) {
        let ids = (call.getArray("ids") ?? []).compactMap { $0 as? String }
        WidgetShared.deleteEvents(ids: ids)
        WidgetCenter.shared.reloadAllTimelines()
        call.resolve()
    }

    @objc func reload(_ call: CAPPluginCall) {
        WidgetCenter.shared.reloadAllTimelines()
        call.resolve()
    }
}

// El puente se crea aquí y no en el storyboard: así el plugin local queda
// registrado antes de que cargue la web.
class MainViewController: CAPBridgeViewController {
    override func capacitorDidLoad() {
        bridge?.registerPluginInstance(SpoonyWidgetBridge())
    }
}
