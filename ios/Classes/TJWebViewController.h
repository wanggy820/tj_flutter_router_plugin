//
//  TJWebViewController.h
//  tj_flutter_router_plugin
//
//  Created by wanggy820 on 2021/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJWebViewController : UIViewController

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) void (^completion)(id result);

@end

NS_ASSUME_NONNULL_END
