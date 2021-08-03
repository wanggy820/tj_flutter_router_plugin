//
//  NSObject+Router.m
//  AFNetworking
//
//  Created by rr wanggy on 2019/4/10.
//

#import "NSObject+Router.h"

@implementation NSObject (Router)

+ (UIViewController*)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [self window].rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController && ![vc.presentedViewController isKindOfClass:UIAlertController.class]) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

+ (UIWindow *)window {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([NSStringFromClass(window.class) hasPrefix:@"_"]) {
        window = [UIApplication sharedApplication].delegate.window;
    }
    return window;
}

+ (UINavigationController*)currentNavigationController {
    UIViewController *currentVC = [UIViewController currentViewController];
    UINavigationController *currentNav = currentVC.navigationController;
    if (!currentNav) {
        UIViewController * tabbarVC = [self window].rootViewController;
        if ([tabbarVC isKindOfClass:[UITabBarController class]]) {
            currentNav = ((UITabBarController *)tabbarVC).selectedViewController;
        } else {
            currentNav = currentVC.navigationController;
        }
    }
    if ([currentNav isKindOfClass:[UINavigationController class]]) {
        return currentNav;
    }
    return nil;
}

@end
