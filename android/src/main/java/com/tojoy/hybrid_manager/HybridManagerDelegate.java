package com.tojoy.hybrid_manager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;

public interface HybridManagerDelegate {
    /*
    * @param url     原生页面
    * @param params  页面所需参数
    * */
    public void openURL(String url, Completion completion);

    public void sendRequestWithURL(String url, Map params, TJHTTPResponse response);

    public void registerWith(FlutterActivity activity);
    public interface Completion {
        public void completion(Object result);
    }
}

