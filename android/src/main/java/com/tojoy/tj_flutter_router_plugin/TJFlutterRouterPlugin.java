package com.tojoy.tj_flutter_router_plugin;

import android.text.TextUtils;
import android.util.Log;
import java.util.HashMap;
import java.util.Map;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * TjFlutterRouterPlugin
 */
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
            final String url = (String) call.arguments;

            TJRouter.openURL(url, new TJRouter.TJCompletion() {
                @Override
                public void completion(Object result) {
                    Map arguments = new HashMap();
                    arguments.put("url", url);
                    arguments.put("result", result);
                    channel.invokeMethod("completion", arguments);
                }
            });
            result.success("OK");
            return;
        }

        if ("pop".equals(call.method)) {
            TJRouter.pop();
            result.success("OK");
            return;
        }

        //调用原生网络请求
        if ("sendRequestWithURL".equals(call.method)) {
            HashMap arguments = (HashMap) call.arguments;
            String url = (String) arguments.get("url");
            HashMap params = (HashMap) arguments.get("params");

            sendRequestWithURL(url, params, result);
            return;
        }

        if ("completion".equals(call.method)) {
            HashMap arguments = (HashMap) call.arguments;
            String url = (String) arguments.get("url");
            if (!TextUtils.isEmpty(url)) {
                TJFlutterManager.completionForRoute(url, arguments.get("result"));
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

    private void sendRequestWithURL(final String url, Map params, final MethodChannel.Result result) {
        if (TJFlutterManager.requestDelegate == null) {
            return;
        }
        TJHTTPResponse response = new TJHTTPResponse() {
            @Override
            public void onSuccess(String response) {
                Map arguments = new HashMap();
                arguments.put("success", true);
                arguments.put("response", response);
                result.success(arguments);
            }

            @Override
            public void onError(String error) {
                Map arguments = new HashMap();
                arguments.put("success", false);
                arguments.put("error", error);
                result.success(arguments);
            }
        };
        TJFlutterManager.requestDelegate.sendRequestWithURL(url, params, response);
    }
}
