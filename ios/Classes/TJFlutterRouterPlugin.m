#import "TJFlutterRouterPlugin.h"
#import "NSObject+Router.h"
#import <objc/message.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "TJFlutterManager.h"
#import "TJRouter.h"

@interface TJFlutterRouterPlugin ()

@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

@implementation TJFlutterRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tj_flutter_router_plugin"
            binaryMessenger:[registrar messenger]];
    TJFlutterRouterPlugin* instance = [[TJFlutterRouterPlugin alloc] init];
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"openURL" isEqualToString:call.method]) {//flutter 打开原生
        [TJRouter openURL:call.arguments completion:^(id  _Nonnull result) {
            NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
            arguments[@"url"] = call.arguments;
            arguments[@"result"] = result;
            [self invokeMethod:@"completion" arguments:arguments];
        }];
    } else if([@"pop" isEqualToString:call.method]){
        UINavigationController *nav = [UIViewController currentNavigationController];
        [nav popViewControllerAnimated:YES];
    } else if ([@"sendRequestWithURL" isEqualToString:call.method]) {//请求网络
        NSDictionary *arguments = call.arguments;
        [self sendRequestWithURL:arguments[@"url"] params:arguments[@"params"] result:result];
    } else if ([@"completion" isEqualToString:call.method]) {
        NSString *url = call.arguments[@"url"];
        id result = call.arguments[@"result"];
        [[TJFlutterManager sharedInstance] result:result completionForRoute:url];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

//调用flutter,把请求结果返回给flutter
- (void)invokeMethod:(NSString*)method arguments:(id)arguments {
    [self.channel invokeMethod:method arguments:arguments result:^(id  _Nullable result) {
        NSLog(@"flutter invokeMethod result:%@", result);
    }];
}

- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params result:(FlutterResult)result {
    if (![[TJFlutterManager sharedInstance].requestDelegate respondsToSelector:@selector(sendRequestWithURL:params:completion:)]) {
        return;
    }
    void (^completion)(NSString *, BOOL, NSString *) = ^(NSString *response, BOOL success, NSString *error) {
        //回调给flutter
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        arguments[@"success"] = @(success);
        arguments[@"error"] = error;
        arguments[@"response"] = response;

        result(arguments);
    };
    [[TJFlutterManager sharedInstance].requestDelegate sendRequestWithURL:url params:params completion:completion];
}

@end
