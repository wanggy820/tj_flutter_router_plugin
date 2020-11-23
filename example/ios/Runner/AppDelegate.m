#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "ViewController.h"
#import <hybrid_manager/UIViewController+Router.h>
#import <hybrid_manager/HybridManager.h>
#import <hybrid_manager/TJRouter.h>
#import <HBDNavigationBar/HBDNavigationController.h>

@interface AppDelegate ()<HybridManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [HybridManager sharedInstance].delegate = self;
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
