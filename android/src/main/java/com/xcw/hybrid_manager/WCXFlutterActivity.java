package com.xcw.hybrid_manager;

import android.app.Activity;
import android.arch.lifecycle.Lifecycle;
import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;
import java.lang.reflect.Method;
import android.support.v7.app.AppCompatActivity;
import io.flutter.view.FlutterView;

public class WCXFlutterActivity extends AppCompatActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.flutter_layout);

        try {
            String route = getIntent().getData().toString();
            Class clazz = Class.forName("io.flutter.facade.Flutter");
            Method createView = clazz.getMethod("createView", Activity.class, Lifecycle.class, String.class);//方法名，参数类型
            FlutterView flutterView = (FlutterView) createView.invoke(null, this, getLifecycle(), route);
            FrameLayout.LayoutParams layout = new FrameLayout.LayoutParams(
                    FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT);
            addContentView(flutterView, layout);
        } catch (Exception e) {
            e.printStackTrace();
        }

        FlutterStackManager.push(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Log.e("TJFlutterActivity", "onDestroy");
    }
}
