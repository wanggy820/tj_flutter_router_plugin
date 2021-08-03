//
//  TJWebViewController.m
//  tj_flutter_router_plugin
//
//  Created by wanggy820 on 2021/7/30.
//

#import "TJWebViewController.h"
#import <WebKit/WebKit.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "TJRouter.h"

//是否为刘海屏
#define kiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

@interface TJWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hbd_barTintColor = UIColor.whiteColor;
    self.hbd_barStyle = UIBarStyleDefault;
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Images" ofType:@"bundle"];
    [self.backButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/back_icon", path]] forState:UIControlStateNormal];
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.backButton.tintColor = [UIColor grayColor];
    [self.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, 44, 44)];
    [self.closeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/close_icon", path]] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.tintColor = [UIColor grayColor];
    self.closeButton.hidden = YES;
    UIView *wapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [wapper addSubview:self.backButton];
    [wapper addSubview:self.closeButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:wapper];
    
    UIView *rightWapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightWapper];

    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    // 默认认为YES
    configuration.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.suppressesIncrementalRendering = YES; // 是否支持记忆读取
    [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.webView.opaque = NO;
    self.webView.userInteractionEnabled = NO;
    self.webView.backgroundColor = UIColor.whiteColor;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:NULL];
    
    self.progressView  = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 1/UIScreen.mainScreen.scale)];
    self.progressView.progressTintColor = [UIColor redColor];
    [self.webView addSubview:self.progressView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];

        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        self.closeButton.hidden = !self.webView.canGoBack;
        self.hbd_backInteractive = !self.webView.canGoBack;
    }
}

- (BOOL)hbd_backInteractive {
    return !self.webView.canGoBack;
}

- (IBAction)back:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self close:sender];
    }
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *jumpUrl = URL.absoluteString;
    if ([TJRouter canOpenURL:jumpUrl] && ![URL.scheme hasPrefix:@"http"]) {
        [TJRouter openURL:jumpUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.webView.userInteractionEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
