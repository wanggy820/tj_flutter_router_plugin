package com.tojoy.tj_flutter_router_plugin;

import android.app.Activity;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;
import com.tojoy.router.AutoWired;
import androidx.annotation.Nullable;
import static android.view.KeyEvent.KEYCODE_BACK;

public class TJWebViewActivity extends Activity {
//    private ImageButton gobackBtn;
    private ImageButton closeBtn;
    private TextView titleView;
    private ProgressBar progressBar;
    private WebView webView;

    @AutoWired()
    String url;
    @AutoWired()
    TJRouter.TJCompletion completion;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.tj_web_view_layout);

//        gobackBtn = (ImageButton)findViewById(R.id.gobackBtn);
        closeBtn = (ImageButton)findViewById(R.id.closeBtn);
        titleView = (TextView)findViewById(R.id.titleView);
        progressBar = (ProgressBar)findViewById(R.id.progressBar);
        webView = (WebView)findViewById(R.id.webView);
        closeBtn.setVisibility(View.INVISIBLE);

        //声明WebSettings子类
        WebSettings webSettings = webView.getSettings();
        //如果访问的页面中要与Javascript交互，则webview必须设置支持Javascript
        webSettings.setJavaScriptEnabled(true);
        //支持插件
        webSettings.setPluginState(WebSettings.PluginState.ON);
        //设置自适应屏幕，两者合用
        webSettings.setUseWideViewPort(true); //将图片调整到适合webview的大小
        webSettings.setLoadWithOverviewMode(true); // 缩放至屏幕的大小
        //缩放操作
        webSettings.setSupportZoom(true); //支持缩放，默认为true。是下面那个的前提。
        webSettings.setBuiltInZoomControls(true); //设置内置的缩放控件。若为false，则该WebView不可缩放
        webSettings.setDisplayZoomControls(false); //隐藏原生的缩放控件
        //其他细节操作
        webSettings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK); //关闭webview中缓存
        webSettings.setAllowFileAccess(true); //设置可以访问文件
        webSettings.setJavaScriptCanOpenWindowsAutomatically(true); //支持通过JS打开新窗口
        webSettings.setLoadsImagesAutomatically(true); //支持自动加载图片
        webSettings.setDefaultTextEncodingName("utf-8");//设置编码格式

        webView.loadUrl(url);
        webView.setWebViewClient(new WebViewClient(){
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                //使用WebView加载显示url
                view.loadUrl(url);
                closeBtn.setVisibility(view.canGoBack() ? View.VISIBLE : View.INVISIBLE);
                Log.v("TAG", "url:"+url);
                //返回true
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                closeBtn.setVisibility(view.canGoBack() ? View.VISIBLE : View.INVISIBLE);
            }
            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {//页面开始加载
                Log.i("paypal","onPageStarted:" + url);
            }

            @Nullable
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                Log.i("paypal","shouldInterceptRequest:" + url);
                Uri uri = Uri.parse(url);
                if ("flutter".equals(uri.getScheme()) || "native".equals(uri.getScheme())) {
                    TJRouter.openURL(url);
                    return null;
                }
                return super.shouldInterceptRequest(view, url);
            }
        });

        webView.setWebChromeClient(new WebChromeClient(){
            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                titleView.setText(title);
                Log.v("TAG", "title:"+title);
            }

            @Override
            public void onProgressChanged(WebView view, int newProgress) {
                super.onProgressChanged(view, newProgress);
                if(newProgress==100){
                    progressBar.setVisibility(View.GONE);//加载完网页进度条消失
                } else{
                    progressBar.setVisibility(View.VISIBLE);//开始加载网页时显示进度条
                    progressBar.setProgress(newProgress);//设置进度值
                }
            }
        });
    }

    public void goback(View view) {
        if (webView.canGoBack()) {
            webView.goBack();
            closeBtn.setVisibility(webView.canGoBack() ? View.VISIBLE : View.INVISIBLE);
        } else  {
            finish();
        }
    }

    public void close(View view) {
        finish();
    }

    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KEYCODE_BACK) && webView.canGoBack()) {
            webView.goBack();
            closeBtn.setVisibility(webView.canGoBack() ? View.VISIBLE : View.INVISIBLE);
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}
