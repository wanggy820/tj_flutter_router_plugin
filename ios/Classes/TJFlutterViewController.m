//
//  TJFlutterViewController.m
//  router_manager
//
//  Created by wanggy820 on 2020/11/20.
//

#import "TJFlutterViewController.h"
#import "TJRouter.h"
#import "UIViewController+Router.h"
#import <objc/message.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "TJRouterManager.h"

@interface TJFlutterViewController ()

@end

@implementation TJFlutterViewController

+ (void)load {
    [TJRouter registerURLPattern:@"tojoy://flutter" toHandler:^(NSDictionary * _Nonnull routerParameters) {
        UINavigationController *nav = [UIViewController currentNavigationController];
        NSString *url = routerParameters[TJRouterParameterURL];
        TJFlutterViewController *flutterVC = [[TJFlutterViewController alloc] initWithProject:nil initialRoute:url nibName:nil bundle:nil];

        [nav pushViewController:flutterVC animated:YES];
        [TJRouterManager sharedInstance].completeCache[url] = routerParameters[TJRouterParameterCompletion];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hbd_barHidden = YES;
    
    //注册
    ((void (*)(id, SEL, id))objc_msgSend)(NSClassFromString(@"GeneratedPluginRegistrant"), NSSelectorFromString(@"registerWithRegistry:"), self);
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
