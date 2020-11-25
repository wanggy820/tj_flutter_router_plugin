package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import com.tojoy.tj_flutter_router_plugin.TJRouterManager;
import com.tojoy.tj_flutter_router_plugin_example.R;

import androidx.annotation.Nullable;

public class Activity1 extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout1);

    }
    
    public void click(View view) {
        String url = getIntent().getStringExtra("url");
        if (url == null) {
            return;
        }
        if (TJRouterManager.completeCache.get(url) == null) {
            return;
        }
        TJRouterManager.completeCache.get(url).completion(url, "Activity1---");
    } 
}
