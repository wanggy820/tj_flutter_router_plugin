//
//  TJFlutterRequestManager.h
//  TJFlutterRequestManager
//
//  Created by wanggy820 on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TJFlutterRequestDelegate <NSObject>

@optional
//走原生网络请求
- (void)sendRequestWithURL:(NSString *)url params:(NSDictionary *)params completion:(void (^)(NSString *reponse, BOOL success, NSString *error))completion;

@end

@interface TJFlutterManager : NSObject

@property (nonatomic, weak) id<TJFlutterRequestDelegate> requestDelegate;

+ (instancetype)sharedInstance;
- (void)setCompletion:(void (^)(id _Nullable result))completion forRoute:(NSString *)route;
- (void)result:(id)result completionForRoute:(NSString *)route;
- (void)removeCompletionForRoute:(NSString *)route;

@end

NS_ASSUME_NONNULL_END
