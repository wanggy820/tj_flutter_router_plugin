package com.xcw.hybrid_manager;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** HybridManagerPlugin */
public class HybridManagerPlugin implements MethodCallHandler {

  private static HybridManagerPlugin hybridManagerplugin = null;
  public MethodChannel methodChannel;
  public HashMap mainEntryParams;
  Context mAppContext;
  WCXURLRouterHandler mNativeRouterHandler;

  public static HybridManagerPlugin sharedInstance() {
    if (hybridManagerplugin == null) {
      hybridManagerplugin = new HybridManagerPlugin();
    }
    return hybridManagerplugin;
  }

  public void setAppContext(Context context) {
    mAppContext = context;
  }

  public void setNativeRouterHandler(WCXURLRouterHandler handler) {
    mNativeRouterHandler = handler;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {

    hybridManagerplugin = HybridManagerPlugin.sharedInstance();
    hybridManagerplugin.methodChannel = new MethodChannel(registrar.messenger(), "hybrid_manager");
    hybridManagerplugin.methodChannel.setMethodCallHandler(hybridManagerplugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Log.e("*****", call.method);

    if ("openNativeWithURL".equals(call.method)) {
      HashMap openUrlInfo = (HashMap) call.arguments;
      String url = (String) openUrlInfo.get("url");
      HashMap params = (HashMap) openUrlInfo.get("params");
      if (mNativeRouterHandler != null) {
        mNativeRouterHandler.flutterOpenNativeWithURL(url, params);
      }
      result.success("OK");
      return;
    }
    if ("openFlutterWithURL".equals(call.method)) {
      HashMap openUrlInfo = (HashMap) call.arguments;
      String url = (String) openUrlInfo.get("url");
      HashMap params = (HashMap) openUrlInfo.get("params");
      openFlutterWithURL(url, params);
      result.success("OK");
      return;
    }
    if ("pop".equals(call.method)) {
      FlutterStackManager.pop();
      result.success("OK");
      return;
    }
    if ("getMainEntryParams".equals(call.method)) {
      if (mainEntryParams == null) {
        mainEntryParams = new HashMap();
      }
      result.success(mainEntryParams);
      return;
    }
    //调用原生网络请求
    if ("sendRequestWithURL".equals(call.method)) {
      if (mNativeRouterHandler != null) {
        HashMap openUrlInfo = (HashMap) call.arguments;
        String url = (String) openUrlInfo.get("url");
        String command = (String) openUrlInfo.get("command");
        HashMap params = (HashMap) openUrlInfo.get("params");

        sendRequestWithURL(url, command, params);
      }

      result.success("OK");
      return;
    }

    result.notImplemented();
  }

  private void sendRequestWithURL(final String url, String command, Map params) {
    WCXFlutterResponse response = new WCXFlutterResponse() {
      @Override
      public void onSuccess(String response) {
        Map result = new HashMap();
        result.putAll(result);
        result.put("url", url);
        result.put("response", response);
        methodChannel.invokeMethod("sendRequestWithURL", result
//                        , new Result() {
//                    @Override
//                    public void success(@Nullable Object o) {
//
//                        Log.e("TAG**1", o==null ?"success":o.toString());
//                    }
//
//                    @Override
//                    public void error(String s, @Nullable String s1, @Nullable Object o) {
//                        Log.e("TAG**2", o.toString() +",s:"+ s + ",s1:"+s1);
//                    }
//
//                    @Override
//                    public void notImplemented() {
//                        Log.e("TAG**3", "notImplemented");
//                    }
//                }
        );
      }

      @Override
      public void onError(String error) {
        Map result = new HashMap();
        result.putAll(result);
        result.put("url", url);
        result.put("error", error);
        methodChannel.invokeMethod("sendRequestWithURL", result);
      }
    };
    mNativeRouterHandler.sendRequestWithURL(url, command, params, response);
  }

  public void openFlutterWithURL(String url, HashMap params) {
    mainEntryParams = params;
    Intent intent = new Intent(mAppContext, WCXFlutterActivity.class);
    intent.setData(Uri.parse(url));
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    mAppContext.startActivity(intent);
  }
}
