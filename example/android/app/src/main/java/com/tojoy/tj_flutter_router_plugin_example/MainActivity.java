package com.tojoy.tj_flutter_router_plugin_example;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import java.util.Map;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;

import com.tojoy.tj_flutter_router_plugin.TJFlutterActivity;
import com.tojoy.tj_flutter_router_plugin.TJHTTPResponse;
import com.tojoy.tj_flutter_router_plugin.TJRouterManager;
import com.tojoy.tj_flutter_router_plugin.TJRouterManagerDelegate;


public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    TJRouterManager.delegate = new TJRouterManagerDelegate() {
      @Override
      public void openURL(String url, TJCompletion completion) {
        Uri uri = Uri.parse(url);
        Log.d("MainActivity***", uri.getAuthority());
        Log.d("MainActivity***", uri.getPath());
        if ("flutter".equals(uri.getAuthority())) {
          Intent intent = new Intent(MainActivity.this, TJFlutterActivity.class);
          intent.putExtra("url", url);
          startActivity(intent);

          //flutter回调
          TJRouterManager.completeCache.put(url, new TJCompletion() {
            @Override
            public void completion(Object result) {
              Log.d("MainActivity***", "result:"+result);
            }
          });
        } else if ("/vc1".equals(uri.getPath())) {
          Intent intent = new Intent(MainActivity.this, Activity1.class);
          intent.putExtra("url", url);
          startActivity(intent);
          //原生传给flutter的回调
          completion.completion("lalala");
        } else if ("/vc2".equals(uri.getPath())) {
          Intent intent = new Intent(MainActivity.this, Activity2.class);
          intent.putExtra("url", url);
          startActivity(intent);
        }
      }
      

      @Override
      public void sendRequestWithURL(String url, Map params, TJHTTPResponse response) {
          response.onSuccess("onSuccess");
      }

    };
  }
}
