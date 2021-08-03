//
//  TJFlutterViewController.m
//  router_manager
//
//  Created by wanggy820 on 2020/11/20.
//

#import "TJFlutterViewController.h"
#import <objc/message.h>
#import <HBDNavigationBar/UIViewController+HBD.h>
#import "TJFlutterManager.h"

@interface TJFlutterViewController ()

@property (nonatomic, copy) NSString *route;

@end

@implementation TJFlutterViewController

- (instancetype)initWithRoute:(NSString *)initialRoute completion:(void (^)(id _Nonnull))completion {
    if (self = [super initWithProject:nil initialRoute:initialRoute nibName:nil bundle:nil]) {
        self.route = initialRoute;
        [[TJFlutterManager sharedInstance] setCompletion:completion forRoute:initialRoute];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hbd_barHidden = YES;
    
    //注册
    ((void (*)(id, SEL, id))objc_msgSend)(NSClassFromString(@"GeneratedPluginRegistrant"), NSSelectorFromString(@"registerWithRegistry:"), self);
}

- (void)dealloc {
    [[TJFlutterManager sharedInstance] removeCompletionForRoute:self.route];
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
