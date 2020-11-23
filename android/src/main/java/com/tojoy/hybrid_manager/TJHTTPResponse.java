package com.tojoy.hybrid_manager;

public interface TJHTTPResponse {
    public void onSuccess(String response);
    public void onError(String error);
}
