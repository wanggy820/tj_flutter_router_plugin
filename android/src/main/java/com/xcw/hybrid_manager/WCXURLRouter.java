package com.xcw.hybrid_manager;

import android.content.Context;
import java.util.HashMap;

public class WCXURLRouter {
    public static void setAppContext(Context context, WCXURLRouterHandler handler){
        HybridManagerPlugin.sharedInstance().setAppContext(context);
        HybridManagerPlugin.sharedInstance().setNativeRouterHandler(handler);
    }

    public static void openFlutterWithURL(String url, HashMap params){
        HybridManagerPlugin.sharedInstance().openFlutterWithURL(url, params);
    }
}
