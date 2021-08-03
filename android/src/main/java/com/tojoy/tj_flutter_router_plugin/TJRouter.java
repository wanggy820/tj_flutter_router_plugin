package com.tojoy.tj_flutter_router_plugin;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.alibaba.android.arouter.exception.InitException;

import java.lang.ref.WeakReference;
import java.util.Iterator;
import java.util.Map;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


public class TJRouter {
    private Application application;
    private static TJRouter router = null;

    private volatile static boolean hasInit = false;

    private WeakReference<Activity> currentActivityWeakRef;
    private static TJRouter getInstance () {
        if (!hasInit) {
            throw new InitException("TJRouter::Init::Invoke init(application) first!");
        }
        synchronized (TJRouter.class) {
            if (router == null) {
                router = new TJRouter();
            }
            return router;
        }
    }

    public static void init(Application application) {
        if (hasInit) {
            return;
        }
        hasInit = true;
        getInstance().application = application;
        //检测生命周期
        application.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

            }

            @Override
            public void onActivityStarted(@NonNull Activity activity) {

            }

            @Override
            public void onActivityResumed(@NonNull Activity activity) {
                getInstance().currentActivityWeakRef = new WeakReference<>(activity);
            }

            @Override
            public void onActivityPaused(@NonNull Activity activity) {

            }

            @Override
            public void onActivityStopped(@NonNull Activity activity) {

            }

            @Override
            public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

            }

            @Override
            public void onActivityDestroyed(@NonNull Activity activity) {

            }
        });

        //获取所有路由注解

    }

    public static void openURL(String URL) {
        openURL(URL, null);
    }

    public static void openURL(String URL, TJCompletion completion) {
        openURL(URL, null, completion);
    }

    public static void openURL(String URL, Map<String, String> params, TJCompletion completion) {
        Uri uri = Uri.parse(URL);
        if (uri == null) {
            return;
        }
        if ("http".equals(uri.getScheme()) || "https".equals(uri.getScheme())) {
            String url = merge(URL, params);
            Intent intent = new Intent(getInstance().application, TJWebViewActivity.class);
            intent.putExtra("url", url);
            getInstance().application.startActivity(intent);
            return;
        }

        if ("flutter".equals(uri.getScheme())) {
            String url = merge(URL, params);
            TJFlutterManager.setRouteForCompletion(url, completion);
            Intent intent = new Intent(getInstance().application, TJFlutterActivity.class);
            intent.putExtra("url", url);
            getInstance().application.startActivity(intent);
            return;
        }
        //处理原生跳转

    }

    private static String merge(String URL, Map<String, String> params) {
        if (params == null || params.isEmpty()) {
            return URL;
        }
        String paramStr = URL;
        paramStr += URL.contains("?") ? "&" : "?";
        Iterator<String> iterator = params.keySet().iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            String value = params.get(key);
            paramStr += key + "=" + value + "&";
        }
        paramStr.substring(0, paramStr.length() - 1);

        return paramStr;
    }

    public static void pop() {
        if (getInstance().currentActivityWeakRef != null) {
            Activity activity = getInstance().currentActivityWeakRef.get();
            activity.finish();
        }
    }

    public static boolean canOpenURL(String URL) {
        Uri uri = Uri.parse(URL);
        if (uri == null) {
            return false;
        }
        if ("http".equals(uri.getScheme()) || "https".equals(uri.getScheme()) || "flutter".equals(uri.getScheme())) {
            return true;
        }

        return true;
    }


    public interface TJCompletion {
        public void completion(Object result);
    }
}
