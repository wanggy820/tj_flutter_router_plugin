//
//  TJRouterManager.m
//  TJRouter_manager
//
//  Created by wanggy820 on 2020/11/20.
//

#import "TJRouterManager.h"

@implementation TJRouterManager

+ (instancetype)sharedInstance{
    static TJRouterManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TJRouterManager alloc] init];
        instance.completeCache = [NSMutableDictionary dictionary];
    });
    return instance;
}

@end
