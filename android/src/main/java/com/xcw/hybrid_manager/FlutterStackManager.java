package com.xcw.hybrid_manager;

import java.util.ArrayList;
import java.util.List;


public class FlutterStackManager {
    public static List<WCXFlutterActivity> stack = new ArrayList<>();

    //入栈
    static void push(WCXFlutterActivity activity) {
        stack.add(activity);
    }

    //出栈
    static void pop() {
        if (!stack.isEmpty()) {
            WCXFlutterActivity activity = stack.get(stack.size() - 1);
            activity.finish();
            stack.remove(activity);
        }
    }
}
