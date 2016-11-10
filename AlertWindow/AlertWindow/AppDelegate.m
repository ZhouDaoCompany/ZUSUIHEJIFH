//
//  AppDelegate.m
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    [self group2];
    return YES;
}
- (void)group1 {
    
    // 1. 调度组
    dispatch_group_t group = dispatch_group_create();
    // 2. 队列
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    // 3. 将任务添加到队列和调度组
    dispatch_group_async(group, q, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务 1 ");
    });
    dispatch_group_async(group, q, ^{
        NSLog(@"任务 2 ");
    });
    dispatch_group_async(group, q, ^{
        NSLog(@"任务 3 ");
    });
    
    // 4. 监听所有任务完成
    dispatch_group_notify(group, q, ^{
        NSLog(@"所有任务完成");
    });
    
    // 5. 判断异步
    NSLog(@"come here");
}
- (void)group2 {
    // 1. 调度组
    dispatch_group_t group = dispatch_group_create();
    
    // 2. 队列
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    // dispatch_group_enter & dispatch_group_leave 必须成对出现
    dispatch_group_enter(group);
    dispatch_group_async(group, q, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"任务 1");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, q, ^{
        NSLog(@"任务 2");
        // dispatch_group_leave 必须是 block 的最后一句
        dispatch_group_leave(group);
    });
    // 4. 监听所有任务完成
    dispatch_group_notify(group, q, ^{
        NSLog(@"所有任务完成");
    });
    
    NSLog(@"异步不影响");

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
