//
//  ViewController2.h
//  Runner
//
//  Created by wanggy820 on 2020/11/19.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController2 : UIViewController
@property (nonatomic, copy) void (^completion)(id result);
@property (nonatomic, copy) NSDictionary *userInfo;
@end

NS_ASSUME_NONNULL_END
