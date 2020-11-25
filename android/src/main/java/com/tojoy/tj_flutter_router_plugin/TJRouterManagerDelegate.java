package com.tojoy.tj_flutter_router_plugin;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public interface TJRouterManagerDelegate {
    /*
    * @param url     原生页面
    * @param params  页面所需参数
    * */
    public void openURL(String url, TJCompletion completion);

    public void sendRequestWithURL(String url, Map params, TJHTTPResponse response);

    public interface TJCompletion {
        public void completion(String url, Object result);
    }
}

