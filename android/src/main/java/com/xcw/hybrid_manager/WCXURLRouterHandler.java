package com.xcw.hybrid_manager;

import java.util.HashMap;
import java.util.Map;

public interface WCXURLRouterHandler {
    /*
    * @param url     原生页面
    * @param params  页面所需参数
    * */
    public void flutterOpenNativeWithURL(String url, HashMap params);

    public void sendRequestWithURL(String url, String command, Map params, WCXFlutterResponse response);
}

