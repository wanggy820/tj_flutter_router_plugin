package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Application;
import android.util.Log;

import com.tojoy.tj_flutter_router_plugin.TJFlutterManager;
import com.tojoy.tj_flutter_router_plugin.TJFlutterRequestDelegate;
import com.tojoy.tj_flutter_router_plugin.TJHTTPResponse;
import com.tojoy.tj_flutter_router_plugin.TJRouter;

import java.util.Map;

public class App extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        TJRouter.init(this);
        TJFlutterManager.requestDelegate = new TJFlutterRequestDelegate() {
            @Override
            public void sendRequestWithURL(String url, Map params, TJHTTPResponse response) {
                Log.v("APP", "sendRequestWithURL:" + url);
                response.onSuccess("onSuccess");
            }

        };
    }
}
