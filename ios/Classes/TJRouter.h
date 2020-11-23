//
//  TJRouter.h
//  MeetingOnline
//
//  Created by wanggy820 on 2020/5/27.
//  Copyright © 2020 _Engineer_雷海洋_. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const TJRouterParameterURL;
extern NSString *const TJRouterParameterCompletion;
extern NSString *const TJRouterParameterUserInfo;

/**
*  routerParameters 里内置的几个参数会用到上面定义的 string
*/
typedef void (^TJRouterHandler)(NSDictionary *routerParameters);
/**
 *  需要返回一个 object，配合 objectForURL: 使用
 */
typedef id _Nullable (^TJRouterObjectHandler)(NSDictionary *routerParameters);

@interface TJRouter : NSObject

/**
 *  注册 URLPattern 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
 *
 *  @param URLPattern 带上 scheme，如 tojoy://nativepage/:id
 *  @param handler    该 block 会传一个字典，包含了注册的 URL 中对应的变量。
 *                    假如注册的 URL 为 tojoy://nativepage/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来
 */
+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(TJRouterHandler)handler;

/**
 *  取消注册某个 URL Pattern
 *
 *  @param URLPattern URLPattern
 */
+ (void)deregisterURLPattern:(NSString *)URLPattern;

/**
 *  打开此 URL
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *
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
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary * _Nullable)userInfo completion:(void (^ _Nullable)(id result))completion;

/**
 *  注册 URLPattern 对应的 ObjectHandler，需要返回一个 object 给调用方
 *
 *  @param URLPattern 带上 scheme，如 tojoy://nativepage/:id
 *  @param handler    该 block 会传一个字典，包含了注册的 URL 中对应的变量。
 *                    假如注册的 URL 为 tojoy://nativepage/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来
 *                    自带的 key 为 @"url" 和 @"completion" (如果有的话)
 */
+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(TJRouterObjectHandler)handler;


/**
 * 查找谁对某个 URL 感兴趣，如果有的话，返回一个 object
 *
 *  @param URL 带 Scheme，如 tojoy://nativepage/3
 */
+ (id)objectForURL:(NSString *)URL;

/**
 * 查找谁对某个 URL 感兴趣，如果有的话，返回一个 object
 *
 *  @param URL 带 Scheme，如 tojoy://nativepage/3
 *  @param userInfo 附加参数
 */
+ (id _Nullable)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *_Nullable)userInfo;


/**
 *  调用此方法来拼接 urlpattern 和 parameters
 *
 *  #define TJ_ROUTE_BEAUTY @"beauty/:id"
 *  [TJRouter generateURLWithPattern:TJ_ROUTE_BEAUTY, @[@13]];
 *
 *
 *  @param pattern    url pattern 比如 @"beauty/:id"
 *  @param parameters 一个数组，数量要跟 pattern 里的变量一致
 *
 *  @return 返回生成的URL String
 */
+ (NSString *)generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters;




/// 打开此 URL，带上附加信息
/// @param URL 带 Scheme 的 URL，如 tojoy://nativepage/4
/// @param detailId 页面所需参数
+ (void)openURL:(NSString *)URL detailId:(NSString * _Nullable)detailId;

/// 打开此 URL，带上附加json信息，同时当操作完成时，执行额外的代码
/// @param URL 带 Scheme 的 URL，如 tojoy://nativepage/4
/// @param detailId 页面所需参数
/// @param ext 页面所需参数
+ (void)openURL:(NSString *)URL detailId:(NSString * _Nullable)detailId ext:(NSDictionary * _Nullable)ext;

/// 打开h5 URL
/// @param URL h5 URL
//+ (void)openH5WithURL:(NSString *)URL;



@end

NS_ASSUME_NONNULL_END
