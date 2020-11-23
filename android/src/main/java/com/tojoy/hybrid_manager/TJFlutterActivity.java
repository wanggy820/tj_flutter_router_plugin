package com.tojoy.hybrid_manager;

import android.content.Context;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.Log;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

public class TJFlutterActivity extends FlutterActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (HybridManager.delegate != null) {
            HybridManager.delegate.registerWith(this);
        }


        HybridManager.push(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.e("TJFlutterActivity", "onDestroy");
    }

    @Override
    public FlutterView createFlutterView(Context context) {

        WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
        FlutterNativeView nativeView = this.createFlutterNativeView();
        FlutterView flutterView = new FlutterView(TJFlutterActivity.this, (AttributeSet) null, nativeView);
        flutterView.setInitialRoute(TJFlutterActivity.this.getIntent().getStringExtra("url"));
        flutterView.setLayoutParams(matchParent);
        this.setContentView(flutterView);
        return flutterView;
    }
}
