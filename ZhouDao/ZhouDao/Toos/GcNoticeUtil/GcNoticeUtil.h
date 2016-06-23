//
//  GcNoticeUtil.h
//
//  Created by xu Huan on 14-12-11.
//  Copyright (c) 2014年 Geekc.pw && huan920410@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GcNoticeHander)();

@interface GcNoticeUtil : NSObject
{
    
}
/**
 *  发送通知
 *
 *  @param noticeName 通知名称
 */
+ (void)sendNotification:(NSString *)noticeName;

/**
 *  发送通知
 *
 *  @param noticeName 通知名称
 */
+ (void)sendNotification:(NSString *)noticeName UserInfo:(NSDictionary *)userInfo;

+ (void)sendNotification:(NSString *)noticeName UserInfo:(NSDictionary *)userInfo Object:(id)object;

/**
 *  处理通知
 *
 *  @param noticeName 通知名称
 *  @param selector   方法
 *  @param observer   观察者
 */
+ (void)handleNotification:(NSString *)noticeName Selector:(SEL)selector Observer:(id)observer;

+ (void)handleNotification:(NSString *)noticeName Selector:(SEL)selector Observer:(id)observer Object:(id)object;

+ (void)removeNotification:(NSString *)noticeName Observer:(id)observer Object:(id)object;

@end
