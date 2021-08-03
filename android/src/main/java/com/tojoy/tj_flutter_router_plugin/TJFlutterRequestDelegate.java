package com.tojoy.tj_flutter_router_plugin;

import java.util.Map;

public interface TJFlutterRequestDelegate {
    public void sendRequestWithURL(String url, Map params, TJHTTPResponse response);
}

