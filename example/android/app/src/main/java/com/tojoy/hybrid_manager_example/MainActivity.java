package com.tojoy.hybrid_manager_example;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.tojoy.hybrid_manager.HybridManager;
import com.tojoy.hybrid_manager.HybridManagerDelegate;
import com.tojoy.hybrid_manager.TJFlutterActivity;
import com.tojoy.hybrid_manager.TJHTTPResponse;

import java.util.Map;

import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);


    HybridManager.delegate = new HybridManagerDelegate() {
      @Override
      public void openURL(String url, Completion completion) {
        Uri uri = Uri.parse(url);
        Log.d("MainActivity***", uri.getAuthority());
        Log.d("MainActivity***", uri.getPath());
        if ("flutter".equals(uri.getAuthority())) {
          Intent intent = new Intent(MainActivity.this, TJFlutterActivity.class);
          intent.putExtra("url", url);
          startActivity(intent);

          //flutter回调
          HybridManager.completeCache.put(url, new Completion() {
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

      @Override
      public void registerWith(FlutterActivity activity) {
        GeneratedPluginRegistrant.registerWith(activity);
      }
    };



  }
}
