//
//  TJFlutterRequestManager.m
//  TJFlutterRequestManager
//
//  Created by wanggy820 on 2020/11/20.
//

#import "TJFlutterManager.h"

@interface TJFlutterManager ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray <void (^)(id _Nullable result)>*>*flutterRouteCompletions;

@end
@implementation TJFlutterManager

+ (instancetype)sharedInstance{
    static TJFlutterManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TJFlutterManager alloc] init];
        instance.flutterRouteCompletions = [NSMutableDictionary dictionary];
    });
    return instance;
}

- (void)setCompletion:(void (^)(id _Nullable))completion forRoute:(nonnull NSString *)route {
    if (!route || !completion) {
        return;
    }
    NSMutableArray *array = self.flutterRouteCompletions[route];
    if (!array) {
        array = [NSMutableArray array];
        self.flutterRouteCompletions[route] = array;
    }
    [array addObject:completion];
}

- (void)result:(id)result completionForRoute:(nonnull NSString *)route{
    if (!route) {
        return;
    }
    NSMutableArray *array = self.flutterRouteCompletions[route];
    if (!array.count) {
        return;
    }
    void (^block)(id result) = array.lastObject;
    if (block) {
        block(result);
    }
}

- (void)removeCompletionForRoute:(NSString *)route{
    if (!route) {
        return;
    }
    NSMutableArray *array = self.flutterRouteCompletions[route];
    if (!array.count) {
        return;
    }
    [array removeLastObject];
    if (!array.count) {
        [self.flutterRouteCompletions removeObjectForKey:route];
    }
}

@end
