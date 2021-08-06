package com.tojoy.tj_flutter_router_plugin;


import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import com.tojoy.router.AutoWired;
import java.lang.ref.WeakReference;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class TJRouter {
    private static final String TAG = "TJRouter";
    private static final String WebRouterURL = "native://tojoy/web";
    private static final String FlutterRouterURL = "native://tojoy/flutter";

    private Application application;
    private static TJRouter router = null;

    private volatile static boolean hasInit = false;
    private static Map<String, Map<String, Object>> routers = new HashMap<>();
    private WeakReference<Activity> currentActivityWeakRef;
    private static TJRouter getInstance () {
        if (!hasInit) {
            throw new TJException("TJRouter::Init::Invoke init(application) first!");
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
                autoWired(activity);
            }

            @Override
            public void onActivityStarted(@NonNull Activity activity) {
//                Log.v(TAG, "onActivityStarted:"+activity.toString());
            }

            @Override
            public void onActivityResumed(@NonNull Activity activity) {
                getInstance().currentActivityWeakRef = new WeakReference<>(activity);
//                Log.v(TAG, "onActivityResumed:"+activity.toString());
            }

            @Override
            public void onActivityPaused(@NonNull Activity activity) {
//                Log.v(TAG, "onActivityPaused:"+activity.toString());
            }

            @Override
            public void onActivityStopped(@NonNull Activity activity) {
//                Log.v(TAG, "onActivityStopped:"+activity.toString());
            }

            @Override
            public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {
//                Log.v(TAG, "onActivitySaveInstanceState:"+activity.toString());
            }

            @Override
            public void onActivityDestroyed(@NonNull Activity activity) {
//                Log.v(TAG, "onActivityDestroyed:"+activity.toString());
            }
        });

        //获取所有路由注解
//        RouterInit.init();
        try {
            Class TJRouter = Class.forName("com.tojoy.router.RouterInit");
            try {
                Method method = TJRouter.getDeclaredMethod("init");
                try {
                    method.invoke(null);
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                }
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            };
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        register(TJWebViewActivity.class.getName(), WebRouterURL);
        register(TJFlutterActivity.class.getName(), FlutterRouterURL);
    }

    public static void register(String className, String url) {
        if (className == null) {
            return;
        }
        Uri uri = Uri.parse(url);
        if (uri == null) {
            return;
        }
        String path = url;
        int index = url.indexOf("?");
        if ( index > 0) {
            path = url.substring(0, index);
        }
        Map params = routers.get(path);
        if (params == null) {
            params = new HashMap();
            routers.put(path, params);
        }
        params.put("className", className);
    }

    public static void unregister(String url) {
        Uri uri = Uri.parse(url);
        if (uri == null) {
            return;
        }
        String path = url;
        int index = url.indexOf("?");
        if ( index > 0) {
            path = url.substring(0, index);
        }
        routers.remove(path);
    }

    public static void openURL(String url) {
        openURL(url, null);
    }

    public static void openURL(String url, TJCompletion completion) {
        openURL(url, null, completion);
    }

    /*
    * url  页面url，可以放入需要传递的参数
    * userInfo  传递的参数
    * completion  回调
    * 特殊参数请放到userInfo 传递
    * */
    public static void openURL(String url, Map<String, Object> userInfo, TJCompletion completion) {
        Uri uri = Uri.parse(url);
        if (uri == null) {
            return;
        }
        if ("http".equals(uri.getScheme()) || "https".equals(uri.getScheme()) || "flutter".equals(uri.getScheme())) {
            String mergeUrl = merge(url, userInfo);
            Map map = new HashMap();
            map.put("url", mergeUrl);
            if ("flutter".equals(uri.getScheme())) {
                openURL(FlutterRouterURL, map, completion);
            } else {
                openURL(WebRouterURL, map, completion);
            }
            return;
        }

        if (!canOpenURL(url)) {
            return;
        }

        //处理原生跳转
        Map map = new HashMap();
        if (userInfo != null) {
            map.putAll(userInfo);
        }
        Set<String> set = uri.getQueryParameterNames();
        for (Iterator iterator = set.iterator(); iterator.hasNext();) {
            String key = (String) iterator.next();
            String value = uri.getQueryParameter(key);
            map.put(key, value);
        }
        String path = url;
        int index = url.indexOf("?");
        if ( index > 0) {
            path = url.substring(0, index);
        }
        Map params = routers.get(path);
        if (map.size() > 0) {
            params.put("userInfo", map);
        }
        if (completion != null) {
            params.put("completion", completion);
        }

        Log.v(TAG, params.get("className").toString());
        try {
            Class className = Class.forName((String) params.get("className"));
            Intent intent = new Intent(getInstance().application, className);
            getInstance().application.startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static boolean canOpenURL(String url) {
        Uri uri = Uri.parse(url);
        if (uri == null) {
            return false;
        }
        if ("http".equals(uri.getScheme()) || "https".equals(uri.getScheme()) || "flutter".equals(uri.getScheme())) {
            return true;
        }

        String path = url;
        int index = url.indexOf("?");
        if ( index > 0) {
            path = url.substring(0, index);
        }
        Map params = routers.get(path);
        if (params == null) {
            return false;
        }
        if (params.get("className") == null) {
            return false;
        }
        return true;
    }

    private static String merge(String url, Map<String, Object> userInfo) {
        if (userInfo == null || userInfo.isEmpty()) {
            return url;
        }
        String paramStr = url;
        paramStr += url.contains("?") ? "&" : "?";
        Iterator<String> iterator = userInfo.keySet().iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            String value = userInfo.get(key).toString();
            paramStr += key + "=" + value + "&";
        }
        paramStr.substring(0, paramStr.length() - 1);

        return paramStr;
    }

    private static String getRegisteredUrl(String className) {
        Iterator<String> iterator = routers.keySet().iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();
            Map value = routers.get(key);
            if (value.get("className").equals(className)) {
                return key;
            }
        }
        return null;
    }

    private static void autoWired(Activity activity) {
        String className = activity.getClass().getName();
        Log.v(TAG, "autoWired:"+className);
        String url = getRegisteredUrl(className);
        if (url == null) {
            return;
        }
        Map<String, Object> params = routers.get(url);
        if (params == null) {
            return;
        }
        Log.v(TAG, "params:"+params);
        Map<String, Object> userInfo = (Map) params.get("userInfo");
        if (userInfo == null) {
            return;
        }

        //绑定数据
        for (Field field : activity.getClass().getDeclaredFields()) {
            if (field.isAnnotationPresent(AutoWired.class)) {
                AutoWired autoWired = field.getAnnotation(AutoWired.class);
                if (autoWired == null) {
                    continue;
                }
                String key = autoWired.name();
                if (TextUtils.isEmpty(key)) {
                    key = field.getName();
                }
                Object value = userInfo.get(key);

                Log.v(TAG, "type:" + field.getType().toString());

                if (value == null) {
                    if (params.get("completion") == null || !field.getType().toString().equals(TJCompletion.class.toString())) {
                        continue;
                    }
                }
                //处理回调
                if (field.getType().toString().equals(TJCompletion.class.toString())) {
                    value = params.get("completion");
                } else if (field.getType().toString().equals(int.class.toString())) {
                    value = Integer.valueOf(value.toString());
                } else if (field.getType().toString().equals(Integer.class.toString())) {
                    value = Integer.valueOf(value.toString());
                } else if (field.getType().toString().equals(Long.class.toString())) {
                    value = Long.valueOf(value.toString());
                } else if (field.getType().toString().equals(long.class.toString())) {
                    value = Long.valueOf(value.toString());
                } else if (field.getType().toString().equals(Double.class.toString())) {
                    value = Double.valueOf(value.toString());
                } else if (field.getType().toString().equals(double.class.toString())) {
                    value = Double.valueOf(value.toString());
                } else if (field.getType().toString().equals(Float.class.toString())) {
                    value = Float.valueOf(value.toString());
                } else if (field.getType().toString().equals(float.class.toString())) {
                    value = Float.valueOf(value.toString());
                } else if (field.getType().toString().equals(Boolean.class.toString())) {
                    value = Boolean.valueOf(value.toString());
                } else if (field.getType().toString().equals(boolean.class.toString())) {
                    value = Boolean.valueOf(value.toString());
                } else if (field.getType().toString().equals(Short.class.toString())) {
                    value = Short.valueOf(value.toString());
                } else if (field.getType().toString().equals(short.class.toString())) {
                    value = Short.valueOf(value.toString());
                } else if (field.getType().toString().equals(Byte.class.toString())) {
                    value = Byte.valueOf(value.toString());
                } else if (field.getType().toString().equals(byte.class.toString())) {
                    value = Byte.valueOf(value.toString());
                } else if (field.getType().toString().equals(char.class.toString())) {
                    value = value.toString().charAt(0);
                } else if (field.getType().toString().equals(CharSequence.class.toString())) {
                    value = String.valueOf(value.toString());
                }
                Log.v(TAG, "value:"+value.toString());
                try {
                    // step1 获取属性指针
                    Field declaredField = activity.getClass().getDeclaredField(field.getName());
                    // step2 设置属性可访问
                    declaredField.setAccessible(true);
                    // step3 设置属性的值
                    try {
                        declaredField.set(activity, value);
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                }
            }
        }

        if (params != null) {
            params.remove("userInfo");
            params.remove("completion");
        }
    }

    public static void pop() {
        if (getInstance().currentActivityWeakRef != null) {
            Activity activity = getInstance().currentActivityWeakRef.get();
            activity.finish();
        }
    }

    public interface TJCompletion {
        public void completion(Object result);
    }

    public static class TJException extends RuntimeException {
        public TJException(String detailMessage) {
            super(detailMessage);
        }
    }
}
