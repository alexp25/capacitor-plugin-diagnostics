import Foundation
import Capacitor

@objc(DiagnosticPlugin)
public class DiagnosticPlugin: CAPPlugin {
    private let implementation = Diagnostic()

    @objc func requestAuthorization(_ call: CAPPluginCall) {
        implementation.requestAuthorization(call)
    }

    @objc func isFeatureAuthorized(_ call: CAPPluginCall) {
        implementation.isFeatureAuthorized(call)
    }

    @objc func isGpsLocationEnabled(_ call: CAPPluginCall) {
        implementation.isGpsLocationEnabled(call)
    }

    @objc func getCurrentBatteryLevel(_ call: CAPPluginCall) {
        implementation.getCurrentBatteryLevel(call)
    }
}
