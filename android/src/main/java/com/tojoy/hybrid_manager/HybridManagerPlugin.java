package com.tojoy.hybrid_manager;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;
import java.util.HashMap;
import java.util.Map;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** HybridManagerPlugin */
public class HybridManagerPlugin implements MethodCallHandler {
  private MethodChannel methodChannel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    HybridManagerPlugin hybridManagerplugin = new HybridManagerPlugin();
    hybridManagerplugin.methodChannel = new MethodChannel(registrar.messenger(), "hybrid_manager");
    hybridManagerplugin.methodChannel.setMethodCallHandler(hybridManagerplugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Log.e("*****", call.method);

    if ("openURL".equals(call.method)) {
      HashMap openUrlInfo = (HashMap) call.arguments;
      final String url = (String) openUrlInfo.get("url");
      if (HybridManager.delegate != null) {
        HybridManager.delegate.openURL(url, new HybridManagerDelegate.Completion() {
          @Override
          public void completion(Object result) {
            if (HybridManager.completeCache.get(url) != null) {
              return;
            }
            Map arguments = new HashMap();
            arguments.put("url", url);
            arguments.put("result", result);
            methodChannel.invokeMethod("completion", arguments);
          }
        });
      }
      result.success("OK");
      return;
    }

    if ("pop".equals(call.method)) {
      HybridManager.pop();
      result.success("OK");
      return;
    }

    //调用原生网络请求
    if ("sendRequestWithURL".equals(call.method)) {
      if (HybridManager.delegate != null) {
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
      if (!TextUtils.isEmpty(url) && HybridManager.completeCache.get(url) != null) {
        HybridManager.completeCache.get(url).completion(result1);
      }
      result.success("OK");
      return;
    }

    result.notImplemented();
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
        methodChannel.invokeMethod("sendRequestWithURL", result);
      }

      @Override
      public void onError(String error) {
        Map result = new HashMap();
        result.putAll(result);
        result.put("url", url);
        result.put("success", false);
        result.put("error", error);
        methodChannel.invokeMethod("sendRequestWithURL", result);
      }
    };
    HybridManager.delegate.sendRequestWithURL(url, params, response);
  }
}
