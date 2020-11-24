package com.tojoy.tj_flutter_router_plugin;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class TJRouterManager {
    public static TJRouterManager shareManager = new TJRouterManager();
    public static TJRouterManagerDelegate delegate;
    public static HashMap<String, TJRouterManagerDelegate.TJCompletion> completeCache = new HashMap<>();
    private static List<TJFlutterActivity> stack = new ArrayList<>();


    //入栈
    static void push(TJFlutterActivity activity) {
        stack.add(activity);
    }

    //出栈
    public static void pop() {
        if (!stack.isEmpty()) {
            TJFlutterActivity activity = stack.get(stack.size() - 1);
            activity.finish();
            stack.remove(activity);
        }
    }
}
