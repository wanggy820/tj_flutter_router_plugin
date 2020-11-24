#import "TJFlutterRouterPlugin.h"
#import "UIViewController+Router.h"
#import <objc/message.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "TJRouterManager.h"
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
        NSString *url = call.arguments[@"url"];
        [TJRouter openURL:url completion:^(id  _Nonnull result) {
            //flutter本身不需要回调
            if ([TJRouterManager sharedInstance].completeCache[url]) {
                return;
            }
            NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
            arguments[@"url"] = url;
            arguments[@"result"] = result;
            [self invokeMethod:@"completion" arguments:arguments];
        }];
    } else if([@"pop" isEqualToString:call.method]){
        UINavigationController *nav = [UIViewController currentNavigationController];
        [nav popViewControllerAnimated:YES];
    } else if ([@"sendRequestWithURL" isEqualToString:call.method]) {//请求网络
        NSDictionary *arguments = call.arguments;
        [self sendRequestWithURL:arguments[@"url"] params:arguments[@"params"]];
    } else if ([@"completion" isEqualToString:call.method]) {
        NSString *url = call.arguments[@"url"];
        id result = call.arguments[@"result"];
        if (url && [TJRouterManager sharedInstance].completeCache[url]) {
            [TJRouterManager sharedInstance].completeCache[url](result);
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

//调用flutter,把请求结果返回给flutter
- (void)invokeMethod:(NSString*)method arguments:(id)arguments {
    [self.channel invokeMethod:method arguments:arguments result:^(id  _Nullable result) {
        NSLog(@"*********result:%@", result);
    }];
}

- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params {
    if (![[TJRouterManager sharedInstance].delegate respondsToSelector:@selector(sendRequestWithURL:params:completion:)]) {
        return;
    }
    void (^completion)(NSString *, BOOL, NSString *) = ^(NSString *response, BOOL success, NSString *error) {
        //回调给flutter
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        arguments[@"url"] = url;
        arguments[@"success"] = @(success);
        arguments[@"error"] = error;
        arguments[@"response"] = response;

        [self invokeMethod:@"sendRequestWithURL" arguments:arguments];
    };
    [[TJRouterManager sharedInstance].delegate sendRequestWithURL:url params:params completion:completion];
}

@end
