//
//  UIViewController+Router.m
//  AFNetworking
//
//  Created by rr wanggy on 2019/4/10.
//

#import "UIViewController+Router.h"

@implementation UIViewController (Router)

+ (UIViewController*)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

+ (UINavigationController*)currentNavigationController {
    UIViewController * aCurrentVC = [UIViewController currentViewController];
    UINavigationController * aCurrentNav = aCurrentVC.navigationController;
    if (!aCurrentNav) {
        UITabBarController * aTabbarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([aTabbarVC isKindOfClass:[UITabBarController class]]) {
            aCurrentNav = aTabbarVC.selectedViewController;
        } else {
            aCurrentNav = aCurrentVC.navigationController;
        }
    }
    return aCurrentNav;
}

@end
