package com.tojoy.tj_flutter_router_plugin;


import android.os.Bundle;
import android.util.Log;
import com.tojoy.router.AutoWired;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;

public class TJFlutterActivity extends FlutterActivity {
    @AutoWired()
    String url;
    @AutoWired()
    TJRouter.TJCompletion completion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.v("TJRouter", "create url:" + url);
        TJFlutterManager.setRouteForCompletion(url, completion);
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
        Log.v("TJRouter", "getInitialRoute url:" + url);
        return url;
    }
}
