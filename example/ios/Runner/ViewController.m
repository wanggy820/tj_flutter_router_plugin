//
//  ViewController.m
//  Runner
//
//  Created by wanggy820 on 2020/11/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ViewController.h"
#import <tj_flutter_router_plugin/TJFlutterRouterPlugin.h>
#import <tj_flutter_router_plugin/TJRouter.h>
#import <tj_flutter_router_plugin/UIViewController+Router.h>

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    [TJRouter registerURLPattern:@"tojoy://native/vc1" toHandler:^(NSDictionary * _Nonnull routerParameters) {
        
        //根据url跳转到不同的页面，页面参数根据url qury传参
        ViewController *vc = [ViewController new];
        vc.completion = routerParameters[TJRouterParameterCompletion];
        vc.userInfo = routerParameters[TJRouterParameterUserInfo];
        [[UIViewController currentNavigationController] pushViewController:vc animated:YES];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 100)];
    //栈里有flutter页面才会有回调
    [btn setTitle:@"回调参数到flutter" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, 100)];
    [btn2 setTitle:@"跳到flutter vc2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (IBAction)btnClick:(id)sender {
    if (self.completion) {
        self.completion(@"啦啦-----回调!");
    }

//    [TJRouter openURL:@"tojoy://flutter?page=vc1&key=value&title=我的title" completion:^(id result) {
//        NSLog(@"vc1 flutter 回调 result:%@", result);
//    }];
}

- (IBAction)btn2Click:(id)sender {
    if (self.completion) {
        self.completion(@"啦啦-----push回调!");
    }
    
    [TJRouter openURL:@"tojoy://flutter?page=vc2&key=value" completion:^(id result) {
        NSLog(@"vc1 flutter 回调 result:%@", result);
    }];
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
