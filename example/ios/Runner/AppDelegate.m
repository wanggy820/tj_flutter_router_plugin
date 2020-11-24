#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "ViewController.h"
#import <tj_flutter_router_plugin/UIViewController+Router.h>
#import <tj_flutter_router_plugin/TJRouterManager.h>
#import <tj_flutter_router_plugin/TJRouter.h>
#import <HBDNavigationBar/HBDNavigationController.h>

@interface AppDelegate ()<TJRouterManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [TJRouterManager sharedInstance].delegate = self;
    ViewController *vc = [ViewController new];
    HBDNavigationController *nav = [[HBDNavigationController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
//  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return YES;
}

- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSString *, BOOL, NSString *))completion {
    
    dispatch_after(1, dispatch_get_main_queue(), ^{
        if (completion) {
            completion(@"----response----", YES, @"error -- error");
        }
    });
}





@end
