//
//  TJRouter.m
//  MeetingOnline
//
//  Created by wanggy820 on 2020/5/27.
//  Copyright © 2020 _Engineer_雷海洋_. All rights reserved.
//

#import "TJRouter.h"
#import "TJFlutterViewController.h"
#import "TJWebViewController.h"
#import "TJFlutterManager.h"

static NSString *TJ_ROUTER_HTTP    = @"http";
static NSString *TJ_ROUTER_HTTPS   = @"https";
static NSString *TJ_ROUTER_FLUTTER = @"flutter";

NSString *const TJRouterParameterURL = @"TJRouterParameterURL";
NSString *const TJRouterParameterCompletion = @"TJRouterParameterCompletion";
NSString *const TJRouterParameterUserInfo = @"TJRouterParameterUserInfo";

@interface TJRouter ()
/**
 *  保存了所有已注册的 URL
 *  结构类似 @{URL: {@"block":[block copy]}}
 */
@property (nonatomic) NSMutableDictionary *routes;

@end

@implementation TJRouter

+ (instancetype)sharedInstance {
    static TJRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)registerURL:(NSString *)URL block:(nonnull void (^)(NSDictionary * _Nonnull))block {
    NSURL *url = [NSURL URLWithString:URL];
    if (!url) {
        return;
    }
    NSMutableDictionary* subRoutes = [self sharedInstance].routes;
    NSString *path = [URL componentsSeparatedByString:@"?"].firstObject;
    NSMutableDictionary *parameters = subRoutes[path];
    if (!parameters) {
        parameters = [NSMutableDictionary dictionary];
        subRoutes[path] = parameters;
    }
    if (path && block) {
        parameters[@"block"] = [block copy];
    }
}

+ (void)unregisterURL:(NSString *)URL {
    NSURL *url = [NSURL URLWithString:URL];
    if (!url) {
        return;
    }
    NSString *path = [URL componentsSeparatedByString:@"?"].firstObject;
    [[self sharedInstance].routes removeObjectForKey:path];
}

+ (void)openURL:(NSString *)URL {
    [self openURL:URL completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion {
    [self openURL:URL userInfo:nil completion:completion];
}

+ (void)openURL:(NSString *)URL userInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion {
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:URL];
    if (!url) {
        return;
    }
    if ([url.scheme isEqualToString:TJ_ROUTER_HTTP] || [url.scheme isEqualToString:TJ_ROUTER_HTTPS]) {
        UINavigationController *nav = [NSObject currentNavigationController];

        TJWebViewController *webVC = [[TJWebViewController alloc] init];
        webVC.url = [self mergeURL:URL userInfo:userInfo];
        webVC.completion = completion;
        [nav pushViewController:webVC animated:YES];
        return;
    } else if ([url.scheme isEqualToString:TJ_ROUTER_FLUTTER]) {
        UINavigationController *nav = [NSObject currentNavigationController];
        NSString *route = [self mergeURL:URL userInfo:userInfo];
        TJFlutterViewController *flutterVC = [[TJFlutterViewController alloc] initWithRoute:route completion:completion];
        [nav pushViewController:flutterVC animated:YES];
        return;
    }
    NSMutableDictionary* subRoutes = [self sharedInstance].routes;
    NSString *path = [URL componentsSeparatedByString:@"?"].firstObject;
    if (subRoutes[path]) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:subRoutes[path]];
        void (^block)(NSDictionary *) = parameters[@"block"];
        if (completion) {
            parameters[TJRouterParameterCompletion] = completion;
        }
        //URL 参数合并到params
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        NSArray *query = [url.query componentsSeparatedByString:@"&"];
        for (NSString *str in query) {
            NSArray *array = [str componentsSeparatedByString:@"="];
            if (array.count == 2) {
                params[array.firstObject] = array.lastObject;
            }
        }
        
        if (params.count > 0) {
            parameters[TJRouterParameterUserInfo] = params;
        }
        if (block) {
            [parameters removeObjectForKey:@"block"];
            block(parameters);
        }
    }
}

+ (BOOL)canOpenURL:(NSString *)URL {
    NSURL *url = [NSURL URLWithString:URL];
    if (!url) {
        return NO;
    }
    if ([url.scheme isEqualToString:TJ_ROUTER_HTTP] || [url.scheme isEqualToString:TJ_ROUTER_HTTPS] || [url.scheme isEqualToString:TJ_ROUTER_FLUTTER]) {
        return YES;
    }
        
    NSString *path = [URL componentsSeparatedByString:@"?"].firstObject;
    return [self sharedInstance].routes[path];
}

- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

//URL userInfo合并
+ (NSString *)mergeURL:(NSString *)URL userInfo:(NSDictionary *)userInfo {
    if (userInfo.count == 0) {
        return URL;
    }
    NSMutableString *paramStr = [NSMutableString string];
    for (NSString *key in userInfo.allKeys) {
        [paramStr appendFormat:@"%@=%@&", key, userInfo[key]];
    }
    if (paramStr.length > 0) {
        [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
    }
    return [NSString stringWithFormat:@"%@%@%@", URL, ([URL containsString:@"?"] ? @"&" : @"?"), paramStr];
}

@end
