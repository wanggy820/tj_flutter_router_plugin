#import "HybridManagerPlugin.h"
#import "UIViewController+Router.h"
#import <objc/message.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "HybridManager.h"
#import "TJRouter.h"

@interface HybridManagerPlugin ()

@property (nonatomic,strong) FlutterMethodChannel* methodChannel;

@end

@implementation HybridManagerPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    HybridManagerPlugin* instance = [HybridManagerPlugin new];
    instance.methodChannel = [FlutterMethodChannel methodChannelWithName:@"hybrid_manager" binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:instance.methodChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"openURL" isEqualToString:call.method]) {//flutter 打开原生
        NSString *url = call.arguments[@"url"];
        [TJRouter openURL:url completion:^(id  _Nonnull result) {
            //flutter本身不需要回调
            if ([HybridManager sharedInstance].completeCache[url]) {
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
        if (url && [HybridManager sharedInstance].completeCache[url]) {
            [HybridManager sharedInstance].completeCache[url](result);
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

//调用flutter,把请求结果返回给flutter
- (void)invokeMethod:(NSString*)method arguments:(id)arguments {
    [self.methodChannel invokeMethod:method arguments:arguments result:^(id  _Nullable result) {
        NSLog(@"*********result:%@", result);
    }];
}

- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params {
    if (![[HybridManager sharedInstance].delegate respondsToSelector:@selector(sendRequestWithURL:params:completion:)]) {
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
    [[HybridManager sharedInstance].delegate sendRequestWithURL:url params:params completion:completion];
}

@end
