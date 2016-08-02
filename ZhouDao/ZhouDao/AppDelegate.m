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
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "ZDLTabBarControllerConfig.h"
#import "LoginViewController.h"
#import <StoreKit/StoreKit.h>
#import "SDImageCache.h"
#import "GcNoticeUtil.h"
#import "PushAlertWindow.h"

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
/**
 *  掉帧测试
 */
//#import "KMCGeigerCounter.h"

@interface AppDelegate ()<UITabBarControllerDelegate,SKStoreProductViewControllerDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    application.applicationIconBadgeNumber = 0;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        //键盘配置
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [self umengTrack];//友盟统计
        //高德地图
        [self setMapEvent];
        [self setIFlyVoice];
        [NetWorkMangerTools isAutoLogin];
        //监测版本
        [self MonitorVersion];
        
    });
    //友盟分享
    [self uMSocialEvent];
    //友盟推送
    [self umengPushSettingWithOptions:launchOptions];
    //[KMCGeigerCounter sharedGeigerCounter].enabled = YES;
    
    ZDLTabBarControllerConfig *tabBarControllerConfig = [[ZDLTabBarControllerConfig alloc] init];
    tabBarControllerConfig.tabBarController.delegate = self;
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark -UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if ([PublicFunction ShareInstance].m_bLogin == NO) {
            LoginViewController *loginVC = [LoginViewController new];
            loginVC.closeBlock = ^{
            };
            [tabBarController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVC] animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}
#pragma mark -配置地图
- (void)setMapEvent
{
    if ([APIKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"apiKey为空，请检查key是否正确设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}
#pragma mark -友盟分享
- (void)uMSocialEvent
{
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENG_APPKEY];
    //打开调试log的开关
    [UMSocialData openLog:NO];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:ZDWXAPPKEY appSecret:ZDWXAppSecret url:@"http://www.zhoudao.cc"];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:ZDQQAPPKEY appKey:ZDQQAppSecret url:@"http://www.zhoudao.cc"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:ZDWBAPPKEY
                                              secret:ZDWBAppSecret
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
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
- (void)MonitorVersion{
    
    [NetWorkMangerTools checkHistoryVersionRequestSuccess:^(NSString *desc) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新版本了马上更新" message:desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即升级", nil];
        alert.tag = 2201;
        [alert show];
    }];
}

#pragma mark -讯飞语音
- (void)setIFlyVoice
{
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
    BOOL result = [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
     //    [[IFlySpeechUtility getUtility] handleOpenURL:url];
    }
    return result;
}
/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2201) {
        if (buttonIndex == 1) {
            [self openAppStoreEvent];
        }
    }
//    [UMessage sendClickReportForRemoteNotification:self.userInfo];
    
}
#pragma mark -跳转App Store
- (void)openAppStoreEvent
{
    //第一种方法  直接跳转
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1105833212"]];
//    exit(0);
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController __TVOS_PROHIBITED NS_AVAILABLE_IOS(6_0);
{
    //点击取消后的操作
}

@end
