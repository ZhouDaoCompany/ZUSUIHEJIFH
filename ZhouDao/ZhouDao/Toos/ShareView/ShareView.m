//
//  ShareView.m
//  ZhouDao
//
//  Created by cqz on 16/5/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ShareView.h"
#import "MenuLabel.h"
#import <pop/POP.h>
#import "UIColor+ImageGetColor.h"
#import "UMSocial.h"

#define Duration 0.2
#define KeyPath @"transform.scale"
#define kTitleRatio 0.4
#define kW [UIScreen mainScreen].bounds.size.width
#define kH [UIScreen mainScreen].bounds.size.height
#define HowMucHline 3
#define ButtonWidth self.botomView.frame.size.width/HowMucHline
#define ButtonHigh ButtonWidth
#define ButtonTag 200
#define Interval (0.35 / _ItmesArr.count)
@interface ShareView()<UMSocialUIDelegate>
{
    UIWindow *window;
    UIImage *bulrImage;
}
@property (nonatomic,weak) UIView *BlurView;
@property (nonatomic,retain) NSArray *ItmesArr;
@property (nonatomic,strong) SelectdCompletionBlock block;
@property (nonatomic,assign) BOOL is;
@property (nonatomic,strong) UIView *botomView;//白底
@property (nonatomic,strong) UIView *whiteView;
@property (nonatomic,strong) NSArray *shareArrays;//分享数组
@property (nonatomic,strong) UIViewController *superVC;
@end
@implementation ShareView
+(void)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
                    contentArrays:(NSArray *)arrays
          withPresentedController:(UIViewController *)presentedVC
           SelectdCompletionBlock:(SelectdCompletionBlock)block{

    ShareView *menu = [[ShareView alloc] initWithItmes:Items withArrays:arrays withVC:presentedVC];
    [menu SelectdCompletionBlock:block];
}
-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes
                   withArrays:(NSArray *)arrsys
                       withVC:(UIViewController *)superVC
{
    self = [super init];
    if (self) {
        _is = true;
        _ItmesArr = Itmes;
        _shareArrays = arrsys;
        _superVC = superVC;
        [self setFrame:CGRectMake(0, 0, kW, kH)];
        [self initUI];
        [self show];
    }
    return self;
}
-(void)initUI
{
    float width = self.frame.size.width;

    UIView *BlurView = [[UIView alloc] initWithFrame:self.bounds];
    BlurView.backgroundColor = [UIColor blackColor] ;
    BlurView.alpha = .3f;
    _BlurView = BlurView;
    [self addSubview:_BlurView];
    self.backgroundColor = [UIColor clearColor];

    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-320,width , 320)];
    whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView = whiteView;
    [self addSubview:_whiteView];

    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    headlab.text = @"分享到:";
    headlab.font = Font_18;
    headlab.textColor = thirdColor;
    [_whiteView addSubview:headlab];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = Font_14;
    closeBtn.frame = CGRectMake(width-50, 10, 35 , 35);
    [closeBtn setImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:closeBtn];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, width, 1.f)];
    lineView.backgroundColor = ViewBackColor;
    [_whiteView addSubview:lineView];

    _botomView = [[UIView alloc] initWithFrame:CGRectMake(25, 80,width-50 , 220)];
    _botomView.backgroundColor = [UIColor whiteColor];
    [_whiteView addSubview:_botomView];
    
    CGRect fromValue = CGRectMake(kMainScreenWidth/2.f, kMainScreenHeight, 0, 0);
    [self StartTheAnimationFromValue:fromValue ToValue:_botomView.frame Delay:.35 Object:_botomView CompletionBlock:^(BOOL CompletionBlock) {
    } HideDisplay:false];
    [self CirculatingItmes];
}
-(void)CirculatingItmes
{
    NSInteger index = 0;
    
    float heightH = self.botomView.frame.size.height;

#pragma mark -添加按钮
    for (MenuLabel *Obj in _ItmesArr) {
        CGFloat buttonX,buttonY;
        buttonX = (index % HowMucHline) * ButtonWidth;
        if (kMainScreenHeight >667) {
            buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (heightH/2.85) -105;
        }else if(kMainScreenHeight >568 && kMainScreenHeight <=667){
            buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (heightH/2.85) -95;
        }else {
            buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (heightH/2.85) -70;
        }
        CGRect fromValue = CGRectMake(buttonX, 50, ButtonWidth, ButtonHigh);
        CGRect toValue = CGRectMake(buttonX, buttonY, ButtonWidth, ButtonHigh);
        if (index == 0) {
            // _MaxTopViewY = CGRectGetMinY(toValue);
        }
        CustomButton *button = [self AllockButtonIndex:index];
        button.MenuData = Obj;
        [button setFrame:fromValue];
        double delayInSeconds = index * Interval;
        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
        
        [self StartTheAnimationFromValue:fromValue ToValue:toValue Delay:delay Object:button CompletionBlock:^(BOOL CompletionBlock) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(dismiss)];
            [_BlurView addGestureRecognizer:tap];
        } HideDisplay:false];
        index ++;
    }
}

-(CustomButton *)AllockButtonIndex:(NSInteger)index
{
    CustomButton *button = [[CustomButton alloc] init];
    [button setTag:(index + 1) + ButtonTag];
    [button setAlpha:0.0f];
    [button setTitleColor:[UIColor colorWithWhite:0.38 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectd:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:button];
    return button;
}
-(void)StartTheAnimationFromValue:(CGRect)fromValue
                          ToValue:(CGRect)toValue
                            Delay:(CFTimeInterval)delay
                           Object:(id/*<UIView *>*/)obj
                  CompletionBlock:(void(^) (BOOL CompletionBlock))completionBlock HideDisplay:(BOOL)HideDisplay{
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = delay;
    CGFloat springBounciness = 10.f;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    CGFloat springSpeed = 20.f;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toValue];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromValue];
    
    POPSpringAnimation *SpringAnimationAlpha = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    SpringAnimationAlpha.removedOnCompletion = YES;
    SpringAnimationAlpha.beginTime = delay;
    SpringAnimationAlpha.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat toV,fromV;
    if (HideDisplay) {
        fromV = 1.0f;
        toV = 0.0f;
    }else{
        fromV = 0.0f;
        toV = 1.0f;
    }
    SpringAnimationAlpha.springSpeed = springSpeed;     // value between 0-20
    SpringAnimationAlpha.toValue = @(toV);
    SpringAnimationAlpha.fromValue = @(fromV);
    
    [obj pop_addAnimation:SpringAnimationAlpha forKey:SpringAnimationAlpha.name];
    [obj pop_addAnimation:springAnimation forKey:springAnimation.name];
    [springAnimation setCompletionBlock:^(POPAnimation *spring, BOOL Completion) {
        if (!completionBlock) {
            return ;
        }
        completionBlock(Completion);
    }];
}
-(void)DismissCompletionBlock:(void(^) (BOOL CompletionBlock)) completionBlock{
    
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
        
    }];
}

-(void)selectd:(CustomButton *)button
{
    NSInteger tag = button.tag - (ButtonTag + 1);
    typeof(self) weak = self;
    [button SelectdAnimation];
    
    NSString *title =@"";
    NSString *contentString = @"";
    NSString *url = @"";
    
    for (NSUInteger i = 0; i<_shareArrays.count; i++) {
        if (i == 0) {
            title =_shareArrays[0];
        }else if (i ==1){
            contentString = _shareArrays[1];
        }else if (i == 2){
            url = [_shareArrays[2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
   
    switch (tag) {
        case 0:{//微信好友
            [self shareToWX:title withContent:contentString withUrl:url];
        }
            break;
        case 1:{//朋友圈
            [self shareToWXFriend:title withContent:contentString withUrl:url];
        }
            break;
        case 2:{//qq好友
            [self shareToQQ:title withContent:contentString withUrl:url];
        }
            break;
        case 3:{//qq空间
            [self shareToQQFriends:title withContent:contentString withUrl:url];
        }
            break;
        case 4:{//新浪
            [self shareToSina:title withContent:contentString withUrl:url];
        }
            break;

        default:
            break;
    }
    
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
        if (!weak.block) {
            return ;
        }
        weak.block(button.MenuData,tag);
    }];
}

#pragma mark - 分享到新浪微博
- (void)shareToSina:(NSString *)title
        withContent:(NSString *)content
            withUrl:(NSString *)url
{
    NSString *shareContent = [NSString stringWithFormat:@"%@\n%@ %@",title,content,url];
    UIImage *shareImg = [QZManager getAppIcon];
    [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImg socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(_superVC,[UMSocialControllerService defaultControllerService],YES);
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        //        XYShowAlert(@"分享成功！", @"我知道了");
    }
}

#pragma mark - 分享到QQ
- (void)shareToQQ:(NSString *)title
      withContent:(NSString *)content
          withUrl:(NSString *)url
{
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    UIImage *shareImg = [QZManager getAppIcon];

//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:url];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:shareImg location:nil urlResource:nil presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到QQ空间
- (void)shareToQQFriends:(NSString *)title
             withContent:(NSString *)content
                 withUrl:(NSString *)url
{
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    UIImage *shareImg = [QZManager getAppIcon];

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:shareImg location:nil urlResource:nil presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到微信朋友圈
- (void)shareToWXFriend:(NSString *)title
            withContent:(NSString *)content
                withUrl:(NSString *)url
{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    UIImage *shareImg = [QZManager getAppIcon];

//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:shareImg location:nil urlResource:nil presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到微信
- (void)shareToWX:(NSString *)title
      withContent:(NSString *)content
          withUrl:(NSString *)url
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    UIImage *shareImg = [QZManager getAppIcon];

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:shareImg location:nil urlResource:nil presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}

-(void)HidDelay:(NSTimeInterval)delay
CompletionBlock:(void(^)(BOOL completion))blcok
{
    typeof(self) weak = self;
    [UIView animateKeyframesWithDuration:Duration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        _whiteView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 360);
//        [weak setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        [weak removeFromSuperview];
        if (!blcok) {
            return ;
        }
        blcok(finished);
    }];
}

-(void)SelectdCompletionBlock:(SelectdCompletionBlock) block{
    
    _block = block;
}

-(void)dismiss{
    
    typeof(self) weak = self;
    [self DismissCompletionBlock:^(BOOL CompletionBlock) {
        _superVC = nil;
        [weak removeFromSuperview];
    }];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
}
-(void)dealloc
{
    NSArray *SubViews = [window subviews];
    for (id obj in SubViews) {
        [obj removeFromSuperview];
    }
    [window resignKeyWindow];
    [window removeFromSuperview];
    _whiteView = nil;
    window = nil;
    DLog(@"正常释放");
}

-(void)show{
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.alpha = 1;
    window.hidden = false;
    [window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
