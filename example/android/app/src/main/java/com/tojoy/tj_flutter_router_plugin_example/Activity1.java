package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import com.tojoy.tj_flutter_router_plugin.Route;
import com.tojoy.tj_flutter_router_plugin.TJRouter;

import java.util.HashMap;
import java.util.Map;

import androidx.annotation.Nullable;

@Route(url = "native://tojoy/vc1")
public class Activity1 extends Activity {
    private static String TAG = "Activity1";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout1);


        Route  r = this.getClass().getAnnotation(Route.class);
        Log.v(TAG, "注解url:"+r.url());

        Log.v(TAG, ">>>>>>");
    }
    
    public void click(View view) {

//        TJRouter.openURL("flutter://tojoy/page2?vc=vc2&key=value", new TJRouter.TJCompletion() {
//            @Override
//            public void completion(Object result) {
//                Log.v(TAG, "flutter completion result:" + result);
//            }
//        });

        Map params = new HashMap();
        params.put("key2", "value2");
        TJRouter.openURL("native://tojoy/vc2?vc=vc2&key=value", params, new TJRouter.TJCompletion() {
            @Override
            public void completion(Object result) {
                Log.v(TAG, "flutter completion result:" + result);
            }
        });
    } 
}
