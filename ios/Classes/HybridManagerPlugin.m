#import "HybridManagerPlugin.h"
#import "UIViewController+Router.h"
#import <objc/message.h>
#import "WCXFlutterViewController.h"

void openURLWithParams(NSString *url, NSDictionary *params, BOOL isOpenFlutter){
    BOOL animated = params[@"animated"] ? [params[@"animated"] boolValue] : YES;
    if (isOpenFlutter) {
        [HybridManagerPlugin openFlutterWithURL:url params:params animated:animated];
        return;
    }
    if ([[HybridManagerPlugin sharedInstance].delegate respondsToSelector:@selector(flutterOpenNativeWithURL:params:)]) {
        [[HybridManagerPlugin sharedInstance].delegate flutterOpenNativeWithURL:url params:params];
    }
}
@implementation HybridManagerPlugin

+ (instancetype)sharedInstance{
    static HybridManagerPlugin * sharedInst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInst = [[HybridManagerPlugin alloc] init];
    });
    return sharedInst;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    HybridManagerPlugin* instance = [HybridManagerPlugin sharedInstance];
    instance.methodChannel = [FlutterMethodChannel methodChannelWithName:@"hybrid_manager" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:instance.methodChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"openNativeWithURL" isEqualToString:call.method]) {//flutter 打开原生
        NSDictionary *arguments = call.arguments;
        openURLWithParams(arguments[@"url"], arguments[@"params"], NO);
    } else if([@"openFlutterWithURL" isEqualToString:call.method]){//flutter 打开flutter
        NSDictionary *arguments = call.arguments;
        openURLWithParams(arguments[@"url"], arguments[@"params"], YES);
    } else if([@"pop" isEqualToString:call.method]){
        UINavigationController *nav = [UIViewController currentNavigationController];
        BOOL animated = call.arguments ? [call.arguments boolValue] : YES;
        [nav popViewControllerAnimated:animated];
    } else if([@"getMainEntryParams" isEqualToString:call.method]){//打开flutter入参
        result([HybridManagerPlugin sharedInstance].mainEntryParams);
    } else if ([@"sendRequestWithURL" isEqualToString:call.method]) {//请求网络
        NSDictionary *arguments = call.arguments;
        [self sendRequestWithURL:arguments[@"url"] params:arguments[@"params"]];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

+ (void)openFlutterWithURL:(NSString *)url params:(NSDictionary *)params {
    [self openFlutterWithURL:url params:params animated:YES];
}

+ (void)openFlutterWithURL:(NSString *)url params:(NSDictionary *)params animated:(BOOL)animated {
    UINavigationController *nav = [UIViewController currentNavigationController];
    WCXFlutterViewController *flutterVC = [[WCXFlutterViewController alloc] init];
    
    [flutterVC setInitialRoute:url];
    [HybridManagerPlugin sharedInstance].mainEntryParams = params;
    [nav pushViewController:flutterVC animated:animated];
    
    //注册
    ((void (*)(id, SEL, id))objc_msgSend)(NSClassFromString(@"GeneratedPluginRegistrant"), NSSelectorFromString(@"registerWithRegistry:"), flutterVC);
}

- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params {
    if (![self.delegate respondsToSelector:@selector(sendRequestWithURL:params:complete:)]) {
        return;
    }
    void (^complete)(NSString *,NSError *) = ^(NSString *response,NSError *error) {
        //回调给flutter
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        arguments[@"url"] = url?:@"";
        if (error) {
            arguments[@"error"] = error.domain?:@"网络请求失败";
        }
        arguments[@"response"] = response;
        //调用flutter,把请求结果返回给flutter
        [self.methodChannel invokeMethod:@"sendRequestWithURL" arguments:arguments result:^(id  _Nullable result) {
//            NSLog(@"*********result:%@", result);
        }];
    };
    [self.delegate sendRequestWithURL:url params:params complete:complete];
}

@end
