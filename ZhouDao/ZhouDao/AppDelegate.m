//
//  AppDelegate.m
//  ZhouDao
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"

#import "ZDLTabBarControllerConfig.h"
#import "LoginViewController.h"
#import <StoreKit/StoreKit.h>
#import "SDImageCache.h"
#import "GcNoticeUtil.h"
#import "PushAlertWindow.h"
#import "Harpy.h"//检测更新

/**
 高德地图
 */
#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
/*
 *科大讯飞
 */
#import "Definition.h"
#import "iflyMSC/IFlyMSC.h"
//地图语音
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
/*
 *友盟统计
 */
#import "MobClick.h"
#import "UMessage.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
/**
 *  掉帧测试
 */
//#import "KMCGeigerCounter.h"

@interface AppDelegate ()<UITabBarControllerDelegate,SKStoreProductViewControllerDelegate,UNUserNotificationCenterDelegate,HarpyDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    //获取本地沙盒路径
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //获取完整路径
//    NSString *documentsPath = [path objectAtIndex:0];

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    application.applicationIconBadgeNumber = 0;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置缓存
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];

    WEAKSELF;
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        
        //键盘配置
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [self umengTrack];//友盟统计
        //高德地图
        [weakSelf setMapEvent];
        [weakSelf setIFlyVoice];
        [NetWorkMangerTools isAutoLogin];
    });
    //友盟分享
    [self uMSocialEvent];
    //友盟推送
    [self umengPushSettingWithOptions:launchOptions];
    //[KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    
//    [ZhouDao_NetWorkManger getWithUrl:@"https://dajiaochong.517w.com/dacu_app/app/?c=BookDetail&a=get_book_coin_rank" sg_cache:NO success:^(id response) {
//        
//        DLog(@"%@",response);
//    } fail:^(NSError *error) {
//        DLog(@"%@",error);
//    }];
    
    ZDLTabBarControllerConfig *tabBarControllerConfig = [[ZDLTabBarControllerConfig alloc] init];
    tabBarControllerConfig.tabBarController.delegate = self;
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
    
    //监测版本
    [self checkVersionUpdate];

    return YES;
}
#pragma mark -UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if ([PublicFunction ShareInstance].m_bLogin == NO) {
            LoginViewController *loginVC = [LoginViewController new];
            [tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}
#pragma mark -配置地图
- (void)setMapEvent
{
    if ([APIKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma mark -友盟分享
- (void)uMSocialEvent {
    
    // 获取友盟social版本号
    DLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    //打开调试log的开关
    [[UMSocialManager defaultManager] openLog:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:ZDWXAPPKEY appSecret:ZDWXAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:ZDQQAPPKEY  appSecret:ZDQQAppSecret redirectURL:@"http://mobile.umeng.com/social"];
//    [UMSocialHandler setSupportWebView:YES];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:ZDWBAPPKEY  appSecret:ZDWBAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}
#pragma mark -友盟统计
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    NSString *version = [QZManager getBuildVersion];
    [MobClick setAppVersion:version];
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];
    /**
     *  UMConfigInstance.channelId =  默认会被被当作@"App Store"渠道
     *  [MobClick updateOnlineConfig];  //在线参数配置
     */
}
#pragma mark -监测版本
- (void)checkVersionUpdate {
    
    [CalculateManager detectionOfUpdatePlistFile];//更新plist文件
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    [[Harpy sharedInstance] setDelegate:self];
    [[Harpy sharedInstance] setAppID:@"1105833212"];
    [[Harpy sharedInstance] setAppName:@"周道慧法"];
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeSkip];
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
    [[Harpy sharedInstance] setDebugEnabled:true];
    [[Harpy sharedInstance] checkVersion];
}

#pragma mark -讯飞语音
- (void)setIFlyVoice {
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    //所有服务启动前，需要确保执行createUtility
//    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,@"20000"]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    DLog(@"%@",url.host);
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
//         [[IFlySpeechUtility getUtility] handleOpenURL:url];
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    [[UMSocialSinaHandler defaultManager]  applicationDidBecomeActive];
}
#pragma mark -当app接收到内存警告时
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1 取消正在下载的操作
    [mgr cancelAll];
    
    // 2清除内存缓存
    [mgr.imageCache clearMemory];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //程序将要结束时，取消下载
    [[FGGDownloadManager shredManager] cancelAllTasks];
}
#pragma amrk -友盟推送
- (void)umengPushSettingWithOptions:(NSDictionary *)launchOptions{
    
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    if (CurrentSystemVersion >=10) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
                
            }
        }];
    }

    [UMessage setLogEnabled:YES];
    
    //点击推送打开
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [PublicFunction ShareInstance].openApp =  YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"presentView"
                                                                object:userInfo];
        });
    }
}
#pragma mark -远程推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self umPushToShowWithNotification:userInfo];
}
#pragma mark - 推送展示
- (void)umPushToShowWithNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    /*
     *   UIApplicationStateActive,     app运行在前台，并且在处理事件
     *   UIApplicationStateInactive,   app运行在前台，但是没有处理任何事件
     *   UIApplicationStateBackground  app运行在后台，还在内存中，并且执行代码
     */
    
    /*
     {
     aps =     {
     alert = "\U6d4b\U8bd5\U5185\U5bb9";
     badge = 0;
     sound = chime;
     };
     bell = 1;
     d = uu05286146614599613601;
     id = 12;
     p = 0;
     type = 2;
     }
     1、时事热点
     2、日程
     3、每日轮播
     4、自定义消息
     */
    
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentView"
                                                        object:userInfo];

}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        [self umPushToShowWithNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        [self umPushToShowWithNotification:userInfo];
    } else {
        //应用处于后台时的本地推送接受
    }
}

#pragma mark - HarpyDelegate
- (void)harpyDidShowUpdateDialog {
    DLog(@"%s", __FUNCTION__);
}

- (void)harpyUserDidLaunchAppStore {
    DLog(@"%s", __FUNCTION__);
}

@end
