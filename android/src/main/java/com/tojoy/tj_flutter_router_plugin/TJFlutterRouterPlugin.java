package com.tojoy.tj_flutter_router_plugin;


import android.text.TextUtils;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/** TjFlutterRouterPlugin */
public class TJFlutterRouterPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tj_flutter_router_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    Log.e("*****", call.method);

    if ("openURL".equals(call.method)) {
      HashMap openUrlInfo = (HashMap) call.arguments;
      final String url = (String) openUrlInfo.get("url");
      if (TJRouterManager.delegate != null) {
        TJRouterManager.delegate.openURL(url, new TJRouterManagerDelegate.TJCompletion() {
          @Override
          public void completion(Object result) {
            if (TJRouterManager.completeCache.get(url) != null) {
              return;
            }
            Map arguments = new HashMap();
            arguments.put("url", url);
            arguments.put("result", result);
            channel.invokeMethod("completion", arguments);
          }
        });
      }
      result.success("OK");
      return;
    }

    if ("pop".equals(call.method)) {
      TJRouterManager.pop();
      result.success("OK");
      return;
    }

    //调用原生网络请求
    if ("sendRequestWithURL".equals(call.method)) {
      if (TJRouterManager.delegate != null) {
        HashMap arguments = (HashMap) call.arguments;
        String url = (String) arguments.get("url");
        HashMap params = (HashMap) arguments.get("params");

        sendRequestWithURL(url, params);
      }

      result.success("OK");
      return;
    }

    if ("completion".equals(call.method)) {
      HashMap arguments = (HashMap) call.arguments;
      String url = (String) arguments.get("url");
      Object result1 = arguments.get("result");
      if (!TextUtils.isEmpty(url) && TJRouterManager.completeCache.get(url) != null) {
        TJRouterManager.completeCache.get(url).completion(result1);
      }
      result.success("OK");
      return;
    }

    result.notImplemented();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void sendRequestWithURL(final String url,  Map params) {
    TJHTTPResponse response = new TJHTTPResponse() {
      @Override
      public void onSuccess(String response) {
        Map result = new HashMap();
        result.putAll(result);
        result.put("url", url);
        result.put("success", true);
        result.put("response", response);
        channel.invokeMethod("sendRequestWithURL", result);
      }

      @Override
      public void onError(String error) {
        Map result = new HashMap();
        result.putAll(result);
        result.put("url", url);
        result.put("success", false);
        result.put("error", error);
        channel.invokeMethod("sendRequestWithURL", result);
      }
    };
    TJRouterManager.delegate.sendRequestWithURL(url, params, response);
  }
}
