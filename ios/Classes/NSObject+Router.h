//
//  NSObject+Router.h
//  AFNetworking
//
//  Created by rr wanggy on 2019/4/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Router)

+ (UIViewController*)currentViewController;
+ (UINavigationController*)currentNavigationController;

@end

NS_ASSUME_NONNULL_END
