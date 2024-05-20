package com.alexpro.plugins.diagnostics;

import android.util.Log;

public class Diagnostic {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }
}
