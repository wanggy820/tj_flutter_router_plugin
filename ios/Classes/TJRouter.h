//
//  TJRouter.h
//  MeetingOnline
//
//  Created by wanggy820 on 2020/5/27.
//  Copyright © 2020 _Engineer_雷海洋_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Router.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const TJRouterParameterURL;
extern NSString *const TJRouterParameterCompletion;
extern NSString *const TJRouterParameterUserInfo;


@interface TJRouter : NSObject

/**
 *  注册 URL 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
 *
 *  @param URL 带上 scheme，如 tojoy://nativepage
 *  @param block    该 block 会传一个字典，包含了注册的 URL 中对应的变量,，内置的三个参数会用到上面定义的 extern NSString。
 */
+ (void)registerURL:(NSString *)URL block:(void (^)(NSDictionary *routerParameters))block;

/**
 *  取消注册某个 URL
 *
 *  @param URL URL
 */
+ (void)unregisterURL:(NSString *)URL;

/**
 *  打开此 URL
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *  默认所有flutter页面都是打开
 *  @param URL 带 Scheme，如 tojoy://nativepage/3
 */
+ (BOOL)canOpenURL:(NSString *)URL;

/**
 *  打开此 URL
 *  默认跳原生页面
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *
 *  @param URL 带 Scheme，如 tojoy://nativepage/3
 */
+ (void)openURL:(NSString *)URL;

/**
 *  打开此 URL，同时当操作完成时，执行额外的代码
 *  默认跳原生页面
 *  @param URL        带 Scheme 的 URL，如 tojoy://nativepage/4
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL completion:(void (^ _Nullable)(id result))completion;

/**
 *  打开此 URL，带上附加信息，同时当操作完成时，执行额外的代码
 *  默认跳原生页面
 *  @param URL        带 Scheme 的 URL，如 tojoy://nativepage/4
 *  @param userInfo 附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)URL userInfo:(NSDictionary * _Nullable)userInfo completion:(void (^ _Nullable)(id result))completion;


@end

NS_ASSUME_NONNULL_END
