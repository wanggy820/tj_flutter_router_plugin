package com.tojoy.tj_flutter_router_plugin;

import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class TJFlutterManager {
    private static String TAG = "TJFlutterManager";

    public static TJFlutterRequestDelegate requestDelegate;
    private static HashMap<String, List<TJRouter.TJCompletion>> flutterRouteCompletions = new HashMap<>();

    public static void setRouteForCompletion(String route, TJRouter.TJCompletion completion) {
        if (route == null) {
            return;
        }
        if (completion == null) {//站位用
            completion = new TJRouter.TJCompletion() {
                @Override
                public void completion(Object result) {

                }
            };
        }
        List <TJRouter.TJCompletion> list = flutterRouteCompletions.get(route);
        if (list == null) {
            list = new ArrayList<>();
            flutterRouteCompletions.put(route, list);
        }
        list.add(completion);
        Log.v(TAG, "set route:"+route);
    }

    public static void completionForRoute(String route, Object object) {
        if (route == null) {
            return;
        }
        List <TJRouter.TJCompletion> list = flutterRouteCompletions.get(route);
        if (list == null || list.size() == 0) {
            return;
        }
        TJRouter.TJCompletion completion = list.get(list.size() - 1);
        completion.completion(object);
        Log.v(TAG, "completion route:"+route);
    }

    public static void removeCompletionForRoute(String route) {
        if (route == null) {
            return;
        }
        List <TJRouter.TJCompletion> list = flutterRouteCompletions.get(route);
        if (list == null || list.size() == 0) {
            return;
        }
        list.remove(list.size() - 1);
        if (list.isEmpty()) {
            flutterRouteCompletions.remove(route);
        }
        Log.v(TAG, "remove route:"+route);
    }
}
