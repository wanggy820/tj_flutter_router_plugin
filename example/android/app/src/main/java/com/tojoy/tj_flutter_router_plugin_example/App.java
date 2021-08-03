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
//      @Override
//      public void openURL(String url, TJRouter.TJCompletion completion) {
//        Uri uri = Uri.parse(url);
//        Log.d("MainActivity***", uri.getAuthority());
//        Log.d("MainActivity***", uri.getPath());
//        if ("flutter".equals(uri.getScheme())) {
//          Intent intent = new Intent(MainActivity.this, TJFlutterActivity.class);
//          intent.putExtra("url", url);
//          startActivity(intent);
//
//        } else if ("http".equals(uri.getScheme()) || "https".equals(uri.getScheme())) {
//          Intent intent = new Intent(MainActivity.this, TJWebViewActivity.class);
//          intent.putExtra("url", url);
//          startActivity(intent);
//        } else if ("/vc1".equals(uri.getPath())) {
//          Intent intent = new Intent(MainActivity.this, Activity1.class);
//          intent.putExtra("url", url);
//          startActivity(intent);
//          //原生传给flutter的回调
//          completion.completion(url, "lalala");
//        } else if ("/vc2".equals(uri.getPath())) {
//          Intent intent = new Intent(MainActivity.this, Activity2.class);
//          intent.putExtra("url", url);
//          startActivity(intent);
//        }
//      }

            @Override
            public void sendRequestWithURL(String url, Map params, TJHTTPResponse response) {
                Log.v("APP", "sendRequestWithURL:" + url);
                response.onSuccess("onSuccess");
            }

        };
    }
}
