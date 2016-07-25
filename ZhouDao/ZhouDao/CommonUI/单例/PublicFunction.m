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
////GCD的timer
//- (void)scheduleDispatchTimerWithName:(NSString *)timerName
//                         timeInterval:(double)interval
//                                queue:(dispatch_queue_t)queue
//                              repeats:(BOOL)repeats
//                               action:(dispatch_block_t)action
//{
//    if (nil == timerName) {
//        return;
//    }
//    if (nil == queue) {
//        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_source_t timer = [self.timercontainer objectForKey:timerName];
//
//        if (!timer) {
//            timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//            dispatch_resume(timer);
//            [self.timercontainer setObject:timer forKey:timerName];
//        }
//        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
//        __weak typeof(self) weakSelf = self;
//        dispatch_source_set_event_handler(timer, ^{
//            action();
//            if (!repeats) {
//                [weakSelf cancelTimerWithName:timerName];
//            }
//        });
//    }
//}
//- (void)cancelTimerWithName:(NSString *)timerName
//{
//    dispatch_source_t timer = [self.timercontainer objectForKey:timerName];
//    if (!timer) {
//        return;
//    }
//    [self.timercontainer removeObjectForKey:timer];
//}

@end
