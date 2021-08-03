//
//  TJFlutterViewController.h
//  router_manager
//
//  Created by wanggy820 on 2020/11/20.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface TJFlutterViewController : FlutterViewController

- (instancetype)initWithRoute:(nullable NSString*)initialRoute completion:(void (^)(id result))completion;

@end

NS_ASSUME_NONNULL_END
