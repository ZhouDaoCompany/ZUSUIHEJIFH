//
//  DreiveMapVC.m
//  ZhouDao
//
//  Created by cqz on 16/6/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DeriveMapVC.h"
#import "DriveNaviViewController.h"
#import "SpeechSynthesizer.h"
#import "GovernmentDetailVC.h"
#import <MAMapKit/MAMapKit.h>

@interface DeriveMapVC ()<AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate,MAMapViewDelegate>

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation DeriveMapVC
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.mapView = nil;
//}
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_mapView);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBarWithTitle:@"驾车导航"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self initDriveManager];
    [self initMapView];

    self.fd_interactivePopDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    [self.driveManager calculateDriveRouteWithStartPoints:@[_startPoint]
                                                endPoints:@[_endPoint]
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategyDefault];

}
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64.f)];
        [self.view addSubview:self.mapView];
    }
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}
#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    [self.driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GovernmentDetailVC class]]) {
            [self.navigationController  popToViewController:vc
                                                   animated:YES];
        }
    }
}


#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    DLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    DLog(@"onCalculateRouteSuccess");
    
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加到AMapNaviDriveManager中
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startGPSNavi];
}
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    DLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
    [JKPromptView showWithImageName:nil message:@"规划路线失败"];
    [self.driveManager stopNavi];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[GovernmentDetailVC class]]) {
            [self.navigationController  popToViewController:vc
                                                   animated:YES];
        }
    }
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    DLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    DLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    DLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    DLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    DLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"导航结束，您已到达目的地附近"];
    DLog(@"onArrivedDestination");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
