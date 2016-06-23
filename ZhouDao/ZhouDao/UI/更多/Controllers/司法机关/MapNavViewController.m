//
//  MapNavViewController.m
//  ZhouDao
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MapNavViewController.h"
#import "SpeechSynthesizer.h"
#import "MoreMenuView.h"

@interface MapNavViewController ()<AMapNaviWalkManagerDelegate,AMapNaviWalkViewDelegate,AMapNaviWalkDataRepresentable,MoreMenuViewDelegate>

@property (nonatomic, strong) AMapNaviWalkManager *walkManager;
@property (nonatomic, strong) AMapNaviWalkView *walkView;
@property (nonatomic, strong) MoreMenuView *moreMenu;

@end

@implementation MapNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_interactivePopDisabled = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    [self initWalkView];
    [self initWalkManager];
    [self initMoreMenu];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self calculateRoute];
}
- (void)initWalkManager
{
    if (self.walkManager == nil)
    {
        self.walkManager = [[AMapNaviWalkManager alloc] init];
        [self.walkManager setDelegate:self];
        
        [self.walkManager addDataRepresentative:self.walkView];
        [self.walkManager addDataRepresentative:self];
    }
}
- (void)initWalkView
{
    if (self.walkView == nil)
    {
        self.walkView = [[AMapNaviWalkView alloc] initWithFrame:self.view.bounds];
        [self.walkView setDelegate:self];
        [self.view addSubview:self.walkView];
    }
}
- (void)initMoreMenu
{
    if (self.moreMenu == nil)
    {
        self.moreMenu = [[MoreMenuView alloc] init];
        self.moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.moreMenu setDelegate:self];
    }
}

#pragma mark -路径规划
- (void)calculateRoute
{
    [self.walkManager calculateWalkRouteWithStartPoints:@[self.startPoint]
                                              endPoints:@[self.endPoint]];
}
#pragma mark - AMapNaviWalkDataRepresentable

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviMode:(AMapNaviMode)naviMode
{
//    if (naviMode == AMapNaviModeNone) {
//        [JKPromptView showWithImageName:nil message:@"导航失败"];
//    }
    DLog(@"updateNaviMode:%ld", (long)naviMode);
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviRouteID:(NSInteger)naviRouteID
{
    DLog(@"updateNaviRouteID:%ld", (long)naviRouteID);
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviRoute:(nullable AMapNaviRoute *)naviRoute;\
{
    DLog(@"updateNaviRoute");
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviInfo:(nullable AMapNaviInfo *)naviInfo
{
    
}

- (void)walkManager:(AMapNaviWalkManager *)walkManager updateNaviLocation:(nullable AMapNaviLocation *)naviLocation
{
    DLog(@"updateNaviLocation");
}

#pragma mark - AMapNaviWalkManager Delegate

- (void)walkManager:(AMapNaviWalkManager *)walkManager error:(NSError *)error
{
    DLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager
{
    DLog(@"计算路线成功");
    
    [self.walkManager startGPSNavi];
}
- (void)walkManager:(AMapNaviWalkManager *)walkManager onCalculateRouteFailure:(NSError *)error
{
    [JKPromptView showWithImageName:nil message:@"规划路线失败"];
    [self.walkManager stopNavi];
    [self.walkManager removeDataRepresentative:self.walkView];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];

    DLog(@"计算路线失败");
}
- (void)walkManagerNeedRecalculateRouteForYaw:(AMapNaviWalkManager *)walkManager
{
    DLog(@"计算偏航路线");
}
- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    DLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)walkManagerOnArrivedDestination:(AMapNaviWalkManager *)walkManager
{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:@"导航结束，您已到达目的地附近"];
    DLog(@"到达目的地");
}

#pragma mark - AMapNaviWalkViewDelegate
- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView
{
    [self.walkManager stopNavi];
    [self.walkManager removeDataRepresentative:self.walkView];
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)walkViewMoreButtonClicked:(AMapNaviWalkView *)walkView
{
    //配置MoreMenu状态
    [self.moreMenu setTrackingMode:self.walkView.trackingMode];
    [self.moreMenu setShowNightType:self.walkView.showStandardNightType];
    
    [self.moreMenu setFrame:self.view.bounds];
    [self.view addSubview:self.moreMenu];
}
- (void)walkViewTrunIndicatorViewTapped:(AMapNaviWalkView *)walkView
{
    if (self.walkView.showMode == AMapNaviWalkViewShowModeCarPositionLocked)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeNormal];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeNormal)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeOverview];
    }
    else if (self.walkView.showMode == AMapNaviWalkViewShowModeOverview)
    {
        [self.walkView setShowMode:AMapNaviWalkViewShowModeCarPositionLocked];
    }
}

- (void)walkView:(AMapNaviWalkView *)walkView didChangeShowMode:(AMapNaviWalkViewShowMode)showMode
{
    DLog(@"didChangeShowMode:%ld", (long)showMode);
}
#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked
{
    [self.moreMenu removeFromSuperview];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType
{
    [self.walkView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode
{
    [self.walkView setTrackingMode:trackingMode];
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
