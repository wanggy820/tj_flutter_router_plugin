package com.tojoy.tj_flutter_router_plugin;


import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;

public class TJFlutterActivity extends FlutterActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.e("TJFlutterActivity", "onDestroy");
        TJFlutterManager.removeCompletionForRoute(getInitialRoute());
    }

    @NonNull
    @Override
    public String getInitialRoute() {
        return TJFlutterActivity.this.getIntent().getStringExtra("url");
    }
}
