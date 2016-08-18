//
//  ShareView.m
//  ZhouDao
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ShareView.h"
#import <pop/POP.h>
#import "CustomButton.h"
#import "MenuLabel.h"
#import "UMSocial.h"

#define MenuButtonHeight 110
#define MenuButtonVerticalPadding 10
#define MenuButtonHorizontalMargin 10
#define MenuButtonAnimationTime 0.2
#define MenuButtonAnimationInterval (MenuButtonAnimationTime / 5)
#define Duration 0.2

#define kMenuButtonBaseTag 7800
@interface ShareView()<UMSocialUIDelegate>
{
    UIWindow *window;
}
@property (nonatomic, copy)    SelectdCompletionBlock block;
@property (nonatomic, strong)  NSArray *items;
@property (nonatomic, strong)  UIView *whiteView;
@property (nonatomic, strong)  UILabel *headlab;
@property (nonatomic, strong) NSArray *shareArrays;//分享数组
@property (nonatomic, strong) UIViewController *superVC;

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
        _items = Itmes;
        _shareArrays = arrsys;
        _superVC = superVC;
        
        [self show];
        [self setup];
    }
    return self;
}
- (void)setup {WEAKSELF;
    [self setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    [self addSubview:self.whiteView];
    
    [_whiteView addSubview:self.headlab];
    
    float width = self.frame.size.width;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    closeBtn.titleLabel.font = Font_14;
    closeBtn.frame = CGRectMake(width-50, 10, 35 , 35);
    [closeBtn setImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:closeBtn];
    
    [self whenCancelTapped:^{
        [weakSelf dismiss];
    }];
    [_whiteView whenCancelTapped:^{
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, width, 1.f)];
    lineView.backgroundColor = ViewBackColor;
    [_whiteView addSubview:lineView];
    
    [self showButtons];
}

#pragma mark - private methods
#pragma mark - getters and setters
- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-320,kMainScreenWidth , 320)];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UILabel *)headlab
{
    if (!_headlab) {
        _headlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
        _headlab.text = @"分享到:";
        _headlab.font = Font_18;
        _headlab.textColor = thirdColor;
    }
    return _headlab;
}
- (void)showButtons {
    NSArray *items = [self menuItems];
    NSUInteger index = 0;
    NSInteger perRowItemCount = 3;
    CGFloat menuButtonWidth = (CGRectGetWidth(self.bounds) - ((perRowItemCount + 1) * MenuButtonHorizontalMargin)) / perRowItemCount;
    
#pragma mark -添加按钮
    for (MenuLabel *Obj in items) {
        CGRect toRect = [self getFrameWithItemCount:items.count perRowItemCount:perRowItemCount perColumItemCount:3 itemWidth:menuButtonWidth itemHeight:MenuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:MenuButtonHorizontalMargin atIndex:index onPage:0];
        CGRect fromRect = toRect;
        fromRect.origin.y = CGRectGetHeight(_whiteView.bounds);
        CustomButton *button = [self AllockButtonIndex:index];
        button.MenuData = Obj;
        [button setFrame:fromRect];
        double delayInSeconds = index * MenuButtonAnimationInterval;
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:button beginTime:delayInSeconds];
        index ++;
    }
}
-(CustomButton *)AllockButtonIndex:(NSInteger)index
{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button setTag:(index + 1) + kMenuButtonBaseTag];
    [button setTitleColor:[UIColor colorWithWhite:0.38 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectd:) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:button];
    return button;
}
-(void)SelectdCompletionBlock:(SelectdCompletionBlock) block{
    _block = block;
}
-(void)dismiss{
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
        
    }];
}
-(void)HidDelay:(NSTimeInterval)delay
CompletionBlock:(void(^)(BOOL completion))blcok
{WEAKSELF;
    [UIView animateKeyframesWithDuration:Duration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        weakSelf.whiteView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 360);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        if (!blcok) {
            return ;
        }
        blcok(finished);
    }];
}
- (NSArray *)menuItems {
    return self.items;
}
/**
 *  通过目标的参数，获取一个grid布局
 *
 *  @param perRowItemCount   每行有多少列
 *  @param perColumItemCount 每列有多少行
 *  @param itemWidth         gridItem的宽度
 *  @param itemHeight        gridItem的高度
 *  @param paddingX          gridItem之间的X轴间隔
 *  @param paddingY          gridItem之间的Y轴间隔
 *  @param index             某个gridItem所在的index序号
 *  @param page              某个gridItem所在的页码
 *
 *  @return 返回一个已经处理好的gridItem frame
 */
- (CGRect)getFrameWithItemCount:(NSInteger)itemCount
                perRowItemCount:(NSInteger)perRowItemCount
              perColumItemCount:(NSInteger)perColumItemCount
                      itemWidth:(CGFloat)itemWidth
                     itemHeight:(NSInteger)itemHeight
                       paddingX:(CGFloat)paddingX
                       paddingY:(CGFloat)paddingY
                        atIndex:(NSInteger)index
                         onPage:(NSInteger)page {
    NSUInteger rowCount = itemCount / perRowItemCount + (itemCount % perColumItemCount > 0 ? 1 : 0);
    CGFloat insetY = (CGRectGetHeight(_whiteView.bounds) - (itemHeight + paddingY) * rowCount) / 2.0;
    
    CGFloat originX = (index % perRowItemCount) * (itemWidth + paddingX) + paddingX + (page * CGRectGetWidth(self.bounds));
    CGFloat originY = ((index / perRowItemCount) - perColumItemCount * page) * (itemHeight + paddingY) + paddingY + 10.f;
    
    CGRect itemFrame = CGRectMake(originX, originY + insetY, itemWidth, itemHeight);
    return itemFrame;
}

#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}
#pragma mark -移除
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
   _superVC = nil;
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

#pragma mark -分享事件
-(void)selectd:(CustomButton *)button
{
    NSInteger tag = button.tag - (kMenuButtonBaseTag + 1);
    typeof(self) weak = self;
    [button SelectdAnimation];
    
    NSString *title =@"";
    NSString *contentString = @"";
    NSString *url = @"";
    NSString *imgUrlString = @"";

    for (NSUInteger i = 0; i<_shareArrays.count; i++) {
        if (i == 0) {
            title =_shareArrays[0];
        }else if (i ==1){
            contentString = _shareArrays[1];
        }else if (i == 2){
            url = [_shareArrays[2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }else if (i == 3) {
            imgUrlString = [_shareArrays[3] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    switch (tag) {
        case 0:{//微信好友
            [self shareToWX:title withContent:contentString withUrl:url withImg:imgUrlString];
        }
            break;
        case 1:{//朋友圈
            
            [self shareToWXFriend:title withContent:contentString withUrl:url withImg:imgUrlString];
        }
            break;
        case 2:{//qq好友
            [self shareToQQ:title withContent:contentString withUrl:url withImg:imgUrlString];
        }
            break;
        case 3:{//qq空间
            [self shareToQQFriends:title withContent:contentString withUrl:url withImg:imgUrlString];
        }
            break;
        case 4:{//新浪
            [self shareToSina:title withContent:contentString withUrl:url withImg:imgUrlString];
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
            withImg:(NSString *)imgUrlString
{
    NSString *shareContent = [NSString stringWithFormat:@"%@ \n%@",content,url];
    //    [[UMSocialControllerService defaultControllerService] setShareText:shareContent shareImage:shareImg socialUIDelegate:self];
    //    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(_superVC,[UMSocialControllerService defaultControllerService],YES);
    UMSocialUrlResource *urlResource = nil;
    if (imgUrlString.length >0) {
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrlString];
    }else {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:url];
    }

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareContent image:nil location:nil urlResource:urlResource presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
    
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
          withImg:(NSString *)imgUrlString
{
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;

    UMSocialUrlResource *urlResource = nil;
    UIImage *image = nil;
    if (imgUrlString.length >0) {
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrlString];
    }else {
        image = [QZManager getAppIcon];
        urlResource = nil;
    }
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:content image:image location:nil urlResource:urlResource presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到QQ空间
- (void)shareToQQFriends:(NSString *)title
             withContent:(NSString *)content
                 withUrl:(NSString *)url
                 withImg:(NSString *)imgUrlString

{
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    UMSocialUrlResource *urlResource = nil;
    UIImage *image = nil;
    if (imgUrlString.length >0) {
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrlString];
    }else {
        image = [QZManager getAppIcon];
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:content image:image location:nil urlResource:urlResource presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到微信朋友圈
- (void)shareToWXFriend:(NSString *)title
            withContent:(NSString *)content
                withUrl:(NSString *)url  withImg:(NSString *)imgUrlString
{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    UMSocialUrlResource *urlResource = nil;
    if (imgUrlString.length >0) {
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrlString];
    }else {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:nil location:nil urlResource:urlResource presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}
#pragma mark - 分享到微信
- (void)shareToWX:(NSString *)title
      withContent:(NSString *)content
          withUrl:(NSString *)url withImg:(NSString *)imgUrlString
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    
    UMSocialUrlResource *urlResource = nil;
    if (imgUrlString.length >0) {
        urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:imgUrlString];

    }else {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    }
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:content image:nil location:nil urlResource:urlResource presentedController:_superVC completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            DLog(@"分享成功！");
        }
    }];
}

@end
