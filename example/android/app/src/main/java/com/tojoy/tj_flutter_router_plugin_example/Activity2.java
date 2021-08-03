package com.tojoy.tj_flutter_router_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import com.tojoy.tj_flutter_router_plugin.Route;

import androidx.annotation.Nullable;

@Route(url = "native://tojoy/vc2")
public class Activity2 extends Activity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout2);

    }
}
