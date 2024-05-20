package com.alexpro.plugins.diagnostics;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.BatteryManager;
import android.os.Build;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import android.util.Log;  // Import the Log class

@CapacitorPlugin(
    name = "Diagnostic",
    permissions = {
        @Permission(alias = "location", strings = {
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION
        }),
        @Permission(alias = "locationAlways", strings = {
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_BACKGROUND_LOCATION
        }),
        @Permission(alias = "camera", strings = {
            Manifest.permission.CAMERA
        }),
        @Permission(alias = "microphone", strings = {
            Manifest.permission.RECORD_AUDIO
        })
    }
)
public class DiagnosticPlugin extends Plugin {
    private static final String TAG = "DiagnosticPlugin"; // Tag for logging


    @PluginMethod
    public void requestAuthorization(PluginCall call) {
        String feature = call.getString("feature");
        if (feature == null || feature.isEmpty()) {
            call.reject("Feature is required");
            return;
        }

        Log.d(TAG, "Requesting authorization for feature: " + feature); // Log message

        saveCall(call); // Save the call to handle the result later

        switch (feature) {
            case "location":
                this.requestLocationPermission(call); // custom logic
                break;
            case "camera":
                this.requestGenericFeaturePermission("camera", call); // default logic
                break;
            case "microphone":
                this.requestGenericFeaturePermission("microphone", call); // default logic
                break;
            default:
                call.reject("Unknown feature: " + feature);
        }
    }

    @PluginMethod
    public void isFeatureAuthorized(PluginCall call) {

        String feature = call.getString("feature");
        if (feature == null || feature.isEmpty()) {
            call.reject("Feature is required");
            return;
        }

        Log.d(TAG, "Checking authorization for feature: " + feature); // Log message
        PermissionState state = getPermissionState(feature);
        boolean isAuthorized = state == PermissionState.GRANTED;
        JSObject ret = new JSObject();
        ret.put("authorized", isAuthorized);
        ret.put("state", state);
        Log.d(TAG, feature + " authorized: " + isAuthorized); // Log message
        call.resolve(ret);
    }

    private void requestLocationPermission(PluginCall call) {
        String mode = call.getString("mode", "when_in_use");

        Log.d(TAG, "Requesting location permission with mode: " + mode); // Log message

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && "always".equals(mode)) {
            if (getPermissionState("locationAlways") != PermissionState.GRANTED){
                requestPermissionForAlias("locationAlways", call, "locationAlwaysPermsCallback");
            } else {
                Log.d(TAG, "Permission already granted"); // Log message
                call.resolve();
            }           
        } else {
            if (getPermissionState("location") != PermissionState.GRANTED){
                requestPermissionForAlias("location", call, "locationPermsCallback");
            } else {
                Log.d(TAG, "Permission already granted"); // Log message
                call.resolve();
            }  
        }
    }

    private void requestGenericFeaturePermission(String feature, PluginCall call) {
        Log.d(TAG, "Requesting " + feature + " permission"); // Log message
        if (getPermissionState(feature) != PermissionState.GRANTED){
            requestPermissionForAlias(feature, call, "permissionsGenCallback");
        } else {
            Log.d(TAG, "Permission already granted for " + feature); // Log message
            call.resolve();
        }  
    }   


    @PluginMethod
    public void isGpsLocationEnabled(PluginCall call) {
        LocationManager locationManager = (LocationManager) getContext().getSystemService(Context.LOCATION_SERVICE);
        boolean isEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        JSObject ret = new JSObject();
        ret.put("enabled", isEnabled);
        Log.d(TAG, "GPS Location Enabled: " + isEnabled); // Log message
        call.resolve(ret);
    }
   

    @PluginMethod
    public void getCurrentBatteryLevel(PluginCall call) {
        IntentFilter ifilter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent batteryStatus = getContext().registerReceiver(null, ifilter);

        int level = -1;
        if (batteryStatus != null) {
            level = batteryStatus.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = batteryStatus.getIntExtra(BatteryManager.EXTRA_SCALE, -1);

            if (level != -1 && scale != -1) {
                float batteryPct = (level / (float) scale) * 100;
                level = Math.round(batteryPct);
            }
        }

        JSObject ret = new JSObject();
        ret.put("level", level);
        Log.d(TAG, "Battery Level: " + level); // Log message
        call.resolve(ret);
    }


    @PermissionCallback
    private void permissionsGenCallback(PluginCall call) {
        String feature = call.getString("feature");
        if (feature == null || feature.isEmpty()) {
            call.reject("Feature is required");
            return;
        }

        if (getPermissionState(feature) == PermissionState.GRANTED) {
            Log.d(TAG, "Permissions granted for feature: " + feature); // Log message
            call.resolve();
        } else {
            Log.d(TAG, "Permission denied for feature: " + feature); // Log message
            call.reject("Permission is required for feature: " + feature);
        }
    }

    @PermissionCallback
    private void locationPermsCallback(PluginCall call) {
        if (getPermissionState("location") == PermissionState.GRANTED) {
            Log.d(TAG, "Permissions granted"); // Log message
            call.resolve();
        } else {
            Log.d(TAG, "Permission denied"); // Log message
            call.reject("Permission is required");
        }
    }

    @PermissionCallback
    private void locationAlwaysPermsCallback(PluginCall call) {
        if (getPermissionState("locationAlways") == PermissionState.GRANTED) {
            Log.d(TAG, "Permissions granted"); // Log message
            call.resolve();
        } else {
            Log.d(TAG, "Permission denied"); // Log message
            call.reject("Permission is required");
        }
    }
}
