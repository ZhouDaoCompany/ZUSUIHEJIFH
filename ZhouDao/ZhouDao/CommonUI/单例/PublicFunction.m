//
//  PublicFunction.m
//  ZhouDao
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PublicFunction.h"

@implementation PublicFunction
+(PublicFunction *)ShareInstance
{
    static PublicFunction *hanle= nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        hanle = [[self alloc] init];
    });
    return hanle;
}
//是否登录
- (BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}
#pragma mark - 应用是否为第一次启动
- (BOOL)isFirstLaunch
{
    NSString *versionKey = (NSString *)kCFBundleVersionKey;
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    NSString *currentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:versionKey];
    if ([lastVersion isEqualToString:currentVersion])
    {
        return NO;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    return NO;
}

@end
