//
//  WCXFlutterViewController.m
//  AFNetworking
//
//  Created by rr wanggy on 2019/4/10.
//

#import "WCXFlutterViewController.h"

@interface WCXFlutterViewController ()

@property (nonatomic, assign) BOOL navigationBarHidden;

@end

@implementation WCXFlutterViewController

- (instancetype)init {
    if (self = [super init]) {
        self.navigationBarHidden = self.navigationController.navigationBar.hidden;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = self.navigationBarHidden;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = self.navigationBarHidden;
}

@end
