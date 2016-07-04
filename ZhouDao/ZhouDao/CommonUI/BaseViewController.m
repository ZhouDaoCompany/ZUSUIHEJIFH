//
//  BaseViewController.m
//  GNETS
//
//  Created by tcnj on 16/2/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsWedViewVC.h"
#import "BaseViewController.h"
#define TitleFont 20.0f
#define LeftFont 13.0f
#define kDefaultWidth   44.0
#import "CompensationVC.h"
#import "GcNoticeUtil.h"
#import "PushAlertWindow.h"

@interface BaseViewController ()
{
    CGFloat barSpacing;
}

@end

@implementation BaseViewController
- (id)init
{
    self = [super init];
    if (self)
    {
        //
        barSpacing = 0.0;
    }
    return self;
}

- (void)initWithStatusBar
{
    CGRect frame = CGRectZero;
    // The status bar default color by red color.
    frame = CGRectMake(0.0, 0.0, kMainScreenWidth, barSpacing);
    self.statusBarView = [[UIView alloc] initWithFrame:frame];
    [self.statusBarView setBackgroundColor:KNavigationBarColor];
    [self.view addSubview:_statusBarView];
}
- (void)initWithNaviBar
{
    CGRect frame = CGRectZero;
    // The status bar default color by red color.
    frame = CGRectMake(0.0, barSpacing, kMainScreenWidth, kDefaultWidth);
    self.naviBarView = [[UIView alloc] initWithFrame:frame];
    [self.naviBarView setBackgroundColor:KNavigationBarColor];
    [self.view addSubview:_naviBarView];
    
    // Left button
    frame = CGRectMake(0.0, 0.0, kDefaultWidth, kDefaultWidth);
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = frame;
    [self.leftBtn addTarget:self
                     action:@selector(handleBtnAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setTag:NaviLeftBtn];
    [self.leftBtn setHidden:YES];
    [self.naviBarView addSubview:_leftBtn];
    
    // Right button
    frame = CGRectMake(CGRectGetWidth(_naviBarView.bounds) - kDefaultWidth, 0.0, kDefaultWidth, kDefaultWidth);
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = frame;
    [self.rightBtn addTarget:self
                      action:@selector(handleBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTag:NaviRightBtn];
    [self.rightBtn setHidden:YES];
    [self.naviBarView addSubview:_rightBtn];
    
    // Title label
    frame = CGRectMake(0.0, 0.0, 0.0, kDefaultWidth);
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    // [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.naviBarView addSubview:_titleLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(delayInitialLoading) withObject:nil afterDelay:0.05];
    
    //隐藏手势的导航栏
    self.fd_prefersNavigationBarHidden = YES;


    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        barSpacing = 20.0;
        [self initWithStatusBar];
    }
    
    // init navi bar
    [self initWithNaviBar];
    self.view.backgroundColor = ViewBackColor;
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [GcNoticeUtil handleNotification:@"presentView"
                            Selector:@selector(presentview:)
                            Observer:self];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [GcNoticeUtil removeNotification:@"presentView"
                            Observer:self
                              Object:nil];
}
- (void)presentview:(NSNotification *)notification
{WEAKSELF;
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
    NSDictionary *notiDic = (NSDictionary *)notification.object;

    NSString *type = notiDic[@"type"];
    NSString *alertString = notiDic[@"aps"][@"alert"];
    NSString *tit = notiDic[@"title"];
    NSUInteger indexType = [type integerValue] -1;
    
    if ([type isEqualToString:@"2"]){
        NSString *bellName = [NetWorkMangerTools getSoundName:notiDic[@"bell"]];
        [[SoundManager sharedSoundManager] musicPlayByName:bellName];
        tit  = @"周道慧法-日程";
    }else if ([type isEqualToString:@"1"]){
        tit  = @"周道慧法-时事热点";
    }else if ([type isEqualToString:@"3"]){
        tit  = @"周道慧法-每日轮播";
    }else if ([type isEqualToString:@"4"]){
        tit  = @"周道慧法-消息提醒";
    }
    
    if ([PublicFunction ShareInstance].openApp ==  YES) {
        
        [PublicFunction ShareInstance].openApp =  NO;
        [self pushWithUserInfo:notiDic];
        if ([type isEqualToString:@"2"]){
            PushAlertWindow *alertWindow = [[PushAlertWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:tit WithContent:alertString withType:indexType];
            alertWindow.pushBlock = ^(){
                
                [[SoundManager sharedSoundManager] musicStop];
            };
            [self.view addSubview:alertWindow];
        }

    }else {
        
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            PushAlertWindow *alertWindow = [[PushAlertWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:tit WithContent:alertString withType:indexType];
            
            alertWindow.pushBlock = ^(){
                
                [[SoundManager sharedSoundManager] musicStop];
                [weakSelf pushWithUserInfo:notiDic];
            };
            [self.view addSubview:alertWindow];
        }else {
            [self pushWithUserInfo:notiDic];
            
            if ([type isEqualToString:@"2"]){
                
                PushAlertWindow *alertWindow = [[PushAlertWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:tit WithContent:alertString withType:indexType];
                alertWindow.pushBlock = ^(){
                    
                    [[SoundManager sharedSoundManager] musicStop];
                };
                [self.view addSubview:alertWindow];
            }
        }
    }
}
#pragma mark - 分析跳转 显示
- (void)pushWithUserInfo:(NSDictionary *)notiDic
{
    NSString *type = notiDic[@"type"];
    NSString *alertString = notiDic[@"aps"][@"alert"];

    NSString *idstr = notiDic[@"id"];
    if ([type isEqualToString:@"1"]) {
        
        [self CurrentEventHotSpot:idstr withTit:alertString];
        
    }else if ([type isEqualToString:@"2"]){
        
//        PushAlertWindow *alertWindow = [[PushAlertWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:tit WithContent:alertString withType:indexType];
//        alertWindow.pushBlock = ^(){
//            
//            [[SoundManager sharedSoundManager] musicStop];
//        };
//        [self.view addSubview:alertWindow];
        
    }else if ([type isEqualToString:@"3"]){
        
        [self TheDailyRoundOfPlay:idstr withTit:alertString];
        
    }else {
        
    }
}
#pragma amrk -每日轮播
- (void)TheDailyRoundOfPlay:(NSString *)idStr withTit:(NSString *)tit
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,dailyInfo,idStr];
    ToolsWedViewVC *vc = [ToolsWedViewVC new];
    vc.url = url;
    vc.tType = FromHotType;
    vc.shareContent =tit;
    vc.format = @"Noti";
    vc.navTitle = @"";//model.title;
    [self.navigationController  pushViewController:vc animated:YES];
}
#pragma amrk -时事热点
- (void)CurrentEventHotSpot:(NSString *)idStr withTit:(NSString *)tit
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,DetailsEventHotSpot,idStr];
    ToolsWedViewVC *vc = [ToolsWedViewVC new];
    vc.url = url;
    vc.tType = FromHotType;
    vc.shareContent = tit;//model.title;
    vc.navTitle = @"";//model.title;
    vc.format = @"Noti";
    [self presentViewController:vc animated:YES completion:^{
    }];
}
- (void)customRefreshTitle{
    
    
}
-(void)delayInitialLoading
{
    //子类使用，延时加载，避免页面卡顿
}
#pragma mark - Public method

- (void)setupStatusBarWithColor:(UIColor *)color
{
    if (![color isEqual:_statusBarView.backgroundColor])
    {
        [self.statusBarView setBackgroundColor:color];
    }
}

- (void)setupStatusBarHidden:(BOOL)hidden {
    [self.statusBarView setHidden:hidden];
}

- (void)setupNaviBarWithColor:(UIColor *)color {
    if (![color isEqual:_naviBarView.backgroundColor]) {
        [self.naviBarView setBackgroundColor:color];
    }
}

- (void)setupNaviBarHidden:(BOOL)hidden {
    [self.naviBarView setHidden:hidden];
}

- (void)setupNaviBarWithTitle:(NSString *)title {
    if (_titleLabel && [title length] > 0) {
        [self.titleLabel setText:title];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:TitleFont]];
        
        CGRect frame = _titleLabel.frame;
        frame.size.width = [QZManager getLabelWidth:_titleLabel];
//        [self.titleLabel setFrame:frame];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.titleLabel.frame = CGRectMake(60, 0.0, kMainScreenWidth-120.f, 44.f);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGPoint center = CGPointMake(self.naviBarView.center.x, self.naviBarView.center.y - barSpacing);
        [self.titleLabel setCenter:center];
    }
}

- (void)setupNaviBarHiddenBtnWithLeft:(BOOL)left
                                right:(BOOL)right {
    if (left != _leftBtn.isHidden) {
        [self.leftBtn setHidden:left];
    }
    
    if (right != _rightBtn.isHidden) {
        [self.rightBtn setHidden:right];
    }
}

- (void)setupNaviBarWithBackAndTitle:(NSString *)title {
    [self setupNaviBarWithTitle:title];
    
    if ([[self.navigationController viewControllers] count] > 1) {
        [self setupNaviBarWithBtn:NaviLeftBtn
                            title:@""
                              img:@"back"];
    }
}

- (void)setupNaviBarWithBtn:(NaviBarBtn)btnTag
                      title:(NSString *)title
                        img:(NSString *)imgName {
    UIButton *btn = nil;
    if (btnTag == NaviLeftBtn) {
        btn = _leftBtn;
    } else if (btnTag == NaviRightBtn) {
        btn = _rightBtn;
    }
    
    if (!btn) return;
    if ([btn isHidden]) [btn setHidden:NO];
    
    CGRect frame = btn.frame;
    UIImage *image = nil;
    if ([imgName length] > 0) {
        image = [UIImage imageNamed:imgName];
        [btn setImage:image forState:UIControlStateNormal];
        
        frame.size.width = MAX(image.size.width, 44.0);
    }
    
    if ([title length] > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:LeftFont]];
        
        if (image) {
            frame.size.width = image.size.width + [QZManager getLabelWidth:btn.titleLabel] + 20.0;
        } else {
            frame.size.width = [QZManager getLabelWidth:btn.titleLabel] + 20.0;
        }
    }
    
    frame.size.width = MAX(CGRectGetWidth(frame), CGRectGetWidth(btn.frame));
    
    if (btn.tag == NaviRightBtn) {
        frame.origin.x = CGRectGetWidth(_naviBarView.bounds) - CGRectGetWidth(frame);
    }
    
    [btn setFrame:frame];
}

- (void)setupNaviBarWithCustomView:(UIView *)view {
    if (view) {
        //
        [self.titleLabel setHidden:YES];
        
        [self.naviBarView addSubview:view];
    }
}

- (CGFloat)getNaviBarHeight {
    if (_naviBarView && !_naviBarView.isHidden) {
        return barSpacing + CGRectGetHeight(_naviBarView.frame);
    }
    return barSpacing;
}

- (CGFloat)getContentHeight {
    return CGRectGetHeight(self.view.bounds) - [self getNaviBarHeight];
}

- (UIView *)getNaviBarView {
    return self.naviBarView;
}

- (UILabel *)getTitleLabel {
    return self.titleLabel;
}

//#pragma mark -通知栏字体颜色
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
#pragma mark - Public method

- (void)handleBtnAction:(UIButton *)btn
{
    if (btn.tag == NaviLeftBtn)
    {
        if ([[self.navigationController viewControllers] count] == 1)
        {
            //点击根viewController上面的自定义navBar左侧的按钮时需要进行的操作
            [self leftBtnAction];
        }
        else
        {
            //nav中不止一个Viewcontroller时默认的操作
            [self leftBtnAction];
        }
    }
    else if (btn.tag == NaviRightBtn)
    {
        [self rightBtnAction];
    }
}
- (void)leftBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnAction
{
    //子类继承实现
}


@end
