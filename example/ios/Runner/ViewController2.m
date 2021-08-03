//
//  ViewController2.m
//  Runner
//
//  Created by wanggy820 on 2020/11/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import "ViewController2.h"
#import <tj_flutter_router_plugin/TJRouter.h>


@interface ViewController2 ()

@end

@implementation ViewController2

+ (void)load {
    [TJRouter registerURL:@"native://tojoy/vc2" block:^(NSDictionary * _Nonnull routerParameters) {

        //根据url跳转到不同的页面，页面参数根据url qury传参
        ViewController2 *vc = [ViewController2 new];
        vc.completion = routerParameters[TJRouterParameterCompletion];
        vc.userInfo = routerParameters[TJRouterParameterUserInfo];
        [[UIViewController currentNavigationController] pushViewController:vc animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"ViewController2";
    self.view.backgroundColor = [UIColor redColor];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"跳到flutter vc1" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    [btn1 setTitle:@"返回" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(300, 100, 100, 100)];
    [btn2 setTitle:@"跳到flutter vc2" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(500, 100, 100, 100)];
    [btn3 setTitle:@"跳到h5" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

- (IBAction)btnClick:(id)sender {
    if (self.completion) {
        self.completion(@"啦啦-----push回调!");
    }

    [TJRouter openURL:@"flutter://tojoy/page1?page=vc1&key=value" completion:^(id result) {
        NSLog(@"flutter 回调 result:%@", result);
    }];
}

- (IBAction)pop:(id)sender {
    if (self.completion) {
        self.completion(@"啦啦-----pop回调!");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn2Click:(id)sender {
    if (self.completion) {
        self.completion(@"啦啦-----push回调!");
    }

    [TJRouter openURL:@"flutter://tojoy/page2?page=vc2&key=value" completion:^(id result) {
        NSLog(@"flutter 回调 result:%@", result);
    }];
}

- (IBAction)btn3Click:(id)sender {
    [TJRouter openURL:@"https://www.baidu.com"];
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
