package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import com.tojoy.router.Router;
import com.tojoy.tj_flutter_router_plugin.TJRouter;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.Nullable;

@Router(url = "native://tojoy/vc1?key=value")
public class Activity1 extends Activity {
    private static String TAG = "Activity1";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout1);

//        Router r = this.getClass().getAnnotation(Router.class);
//        Log.v(TAG, "注解url:"+r.url());

        Log.v(TAG, ">>>>>>");
    }
    
    public void click(View view) {

        TJRouter.openURL("flutter://tojoy/page2?vc=vc2&key=value", new TJRouter.TJCompletion() {
            @Override
            public void completion(Object result) {
                Log.v(TAG, "flutter completion result:" + result);
            }
        });

        Map params = new HashMap();
        params.put("key2", "value2");
//        TJRouter.openURL("native://tojoy/vc2?vc=vc2&key=ss", params, new TJRouter.TJCompletion() {
//            @Override
//            public void completion(Object result) {
//                Log.v(TAG, "native completion result:" + result);
//            }
//        });

//        TJRouter.openURL("https://www.baidu.com");
    } 
}
