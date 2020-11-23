package com.tojoy.hybrid_manager;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class HybridManager {
    public static HybridManager shareManager = new HybridManager();
    public static HybridManagerDelegate delegate;
    public static HashMap<String, HybridManagerDelegate.Completion> completeCache = new HashMap<>();
    private static List<TJFlutterActivity> stack = new ArrayList<>();


    //入栈
    static void push(TJFlutterActivity activity) {
        stack.add(activity);
    }

    //出栈
    static void pop() {
        if (!stack.isEmpty()) {
            TJFlutterActivity activity = stack.get(stack.size() - 1);
            activity.finish();
            stack.remove(activity);
        }
    }
}
