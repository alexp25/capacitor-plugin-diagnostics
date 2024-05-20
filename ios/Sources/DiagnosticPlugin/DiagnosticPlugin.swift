import Foundation
import Capacitor
import AVFoundation

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(DiagnosticPlugin)
public class DiagnosticPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DiagnosticPlugin"
    public let jsName = "Diagnostic"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = Diagnostic()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func isCameraAvailable(_ call: CAPPluginCall) {
        var cameraAvailable = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAvailable = true
        }
        call.resolve([
            "available": cameraAvailable
        ])
    }
}
