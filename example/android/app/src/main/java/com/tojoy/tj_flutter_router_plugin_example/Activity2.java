package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.tojoy.router.AutoWired;
import com.tojoy.router.Router;
import com.tojoy.tj_flutter_router_plugin.TJRouter;

import androidx.annotation.Nullable;

@Router(url = "native://tojoy/vc2")
public class Activity2 extends Activity {
    private static final String TAG = "Activity2";
//    @AutoWired()
//    private String vc;

    @AutoWired(name = "key")
    CharSequence test;

//    @AutoWired(name = "key")
//    byte test1;

//    @AutoWired(name = "key")
//    short test2;
//
//    @AutoWired(name = "key")
//    Short test3;

//    @AutoWired()
//    String key2;
    @AutoWired()
    TJRouter.TJCompletion completion;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout2);

        Log.v(TAG, "test:"+test);
//        Log.v(TAG, "test1:"+test1);
//        Log.v(TAG, "test2:"+test2);
//        Log.v(TAG, "test3:"+test3);
//        Log.v(TAG, "vc:" + vc + ", test:" + test +", key2:" + key2);
//        Log.v(TAG, test+",class:"+test.getClass());
        if (completion != null) {
            completion.completion(test);
        } else  {
            Log.v(TAG, "completion is null");
        }
    }
}
