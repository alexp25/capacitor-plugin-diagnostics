import Foundation
import Capacitor
import CoreLocation
import AVFoundation


public class Diagnostic: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var call: CAPPluginCall?

    public func requestAuthorization(_ call: CAPPluginCall) {
        guard let feature = call.getString("feature") else {
            call.reject("Feature is required")
            return
        }

        self.call = call

        switch feature {
        case "location":
            requestLocationPermission(call)
        case "locationAlways":
            requestLocationAlwaysPermission(call)
        case "camera":
            requestGenericFeaturePermission(AVMediaType.video, call)
        case "microphone":
            requestGenericFeaturePermission(AVMediaType.audio, call)
        default:
            call.reject("Unknown feature: \(feature)")
        }
    }

    public func isFeatureAuthorized(_ call: CAPPluginCall) {
        guard let feature = call.getString("feature") else {
            call.reject("Feature is required")
            return
        }

        var isAuthorized: Bool
        var status: String
        switch feature {
        case "location":
            let authorizationStatus = CLLocationManager.authorizationStatus()
            isAuthorized = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
            status = authorizationStatusToString(authorizationStatus)
        case "locationAlways":
            let authorizationStatus = CLLocationManager.authorizationStatus()
            isAuthorized = authorizationStatus == .authorizedAlways
            status = authorizationStatusToString(authorizationStatus)
        case "camera":
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            isAuthorized = authorizationStatus == .authorized
            status = authorizationStatusToString(authorizationStatus)
        case "microphone":
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
            isAuthorized = authorizationStatus == .authorized
            status = authorizationStatusToString(authorizationStatus)
        default:
            call.reject("Unknown feature: \(feature)")
            return
        }

        var ret = JSObject()
        ret["authorized"] = isAuthorized
        ret["state"] = status
        call.resolve(ret)
    }

    public func isGpsLocationEnabled(_ call: CAPPluginCall) {
        let isEnabled = CLLocationManager.locationServicesEnabled()
        var ret = JSObject()
        ret["enabled"] = isEnabled
        call.resolve(ret)
    }

    public func getCurrentBatteryLevel(_ call: CAPPluginCall) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel * 100
        var ret = JSObject()
        ret["level"] = Int(level)
        call.resolve(ret)
    }

    private func requestLocationPermission(_ call: CAPPluginCall) {
        let mode = call.getString("mode") ?? "when_in_use"

        if mode == "always" {
            locationManager.requestAlwaysAuthorization()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.delegate = self
    }

    private func requestLocationAlwaysPermission(_ call: CAPPluginCall) {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    private func requestGenericFeaturePermission(_ mediaType: AVMediaType, _ call: CAPPluginCall) {
        AVCaptureDevice.requestAccess(for: mediaType) { granted in
            if granted {
                call.resolve()
            } else {
                call.reject("Permission is required for \(mediaType.rawValue)")
            }
        }
    }


    private func authorizationStatusToString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "not_determined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "granted"
        case .authorizedWhenInUse:
            return "authorized_when_in_use"
        @unknown default:
            return "unknown"
        }
    }

    private func authorizationStatusToString(_ status: AVAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "not_requested"
        case .restricted:
            return "prompt"
        case .denied:
            return "denied_once"
        case .authorized:
            return "granted"
        @unknown default:
            return "unknown"
        }
    }


    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let call = self.call else { return }
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            call.resolve()
        case .denied, .restricted:
            call.reject("Permission is required for location")
        default:
            break
        }
    }
}
