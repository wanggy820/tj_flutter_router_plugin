//
//  HybridManager.m
//  hybrid_manager
//
//  Created by wanggy820 on 2020/11/20.
//

#import "HybridManager.h"

@implementation HybridManager

+ (instancetype)sharedInstance{
    static HybridManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HybridManager alloc] init];
        instance.completeCache = [NSMutableDictionary dictionary];
    });
    return instance;
}

@end
