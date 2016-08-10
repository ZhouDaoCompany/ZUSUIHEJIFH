//
//  GcNoticeCenter.m
//   
//
//  Created by xu Huan on 14-12-11.
//  Copyright (c) 2014年 Geekc.pw && huan920410@gmail.com. All rights reserved.
//

#import "GcNoticeUtil.h"

@implementation GcNoticeUtil

/**
 *  发送通知
 *
 *  @param noticeName 通知名称
 */
+ (void)sendNotification:(NSString *)noticeName
{
//    DLog(@"sendNotification ---- :%@",noticeName);
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil];
}

/**
 *  发送通知
 *
 *  @param noticeName 通知名称
 */
+ (void)sendNotification:(NSString *)noticeName UserInfo:(NSDictionary *)userInfo
{
//    DLog(@"sendNotification ---- :%@\nUserInfo ---- :%@",noticeName,userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:nil];
}

+ (void)sendNotification:(NSString *)noticeName UserInfo:(NSDictionary *)userInfo Object:(id)object
{
//    DLog(@"sendNotification ---- :%@\nUserInfo ---- :%@\nObject ---- :%@",noticeName,userInfo,object);
    [[NSNotificationCenter defaultCenter] postNotificationName:noticeName object:object userInfo:userInfo];
}


/**
 *  处理通知
 *
 *  @param noticeName 通知名称
 *  @param selector   方法
 *  @param observer   观察者
 */
+ (void)handleNotification:(NSString *)noticeName Selector:(SEL)selector Observer:(id)observer
{
//    DLog(@"handleNotification ---- :%@",noticeName);
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:noticeName object:nil];
}

+ (void)handleNotification:(NSString *)noticeName Selector:(SEL)selector Observer:(id)observer Object:(id)object
{
//    DLog(@"handleNotification ---- :%@\nObject ---- :%@",noticeName,object);
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:noticeName object:object];
}

+ (void)removeNotification:(NSString *)noticeName Observer:(id)observer Object:(id)object
{
//    DLog(@"removeNotification ---- :%@\nObserver ---- :%@\nObject ---- :%@",noticeName,observer,object);
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:noticeName
                                                  object:object];
}
+ (void)removeAllNotification:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}


@end
