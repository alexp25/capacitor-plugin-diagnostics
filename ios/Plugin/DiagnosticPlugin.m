#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(DiagnosticPlugin, "Diagnostic",
  CAP_PLUGIN_METHOD(requestAuthorization, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(isFeatureAuthorized, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(isGpsLocationEnabled, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(getCurrentBatteryLevel, CAPPluginReturnPromise);
)
