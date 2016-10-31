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
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialSinaHandler.h"

#define MenuButtonHeight 110
#define MenuButtonVerticalPadding 10
#define MenuButtonHorizontalMargin 10
#define MenuButtonAnimationTime 0.2
#define MenuButtonAnimationInterval (MenuButtonAnimationTime / 5)
#define Duration 0.2

#define kMenuButtonBaseTag 7800
@interface ShareView()
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
        _headlab.textColor = THIRDCOLOR;
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
    
    NSArray *platformArrays = @[@"1",@"2",@"4",@"5",@"0"];
    [self shareToPlatformType:[platformArrays[tag] integerValue] withTitle:title withContent:contentString withUrl:url withImage:imgUrlString];

    
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
        if (!weak.block) {
            return ;
        }
        weak.block(button.MenuData,tag);
    }];
}
#pragma mark - 设置分享各个平台的方法
- (void)shareToPlatformType:(UMSocialPlatformType)platformType
                  withTitle:(NSString *)title
                withContent:(NSString *)content
                    withUrl:(NSString *)url
                    withImage:(NSString *)imgUrlString {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    id shareThumImage = (imgUrlString.length >0) ? imgUrlString : [QZManager getAppIcon];

    NSString *shareContent = (platformType == 0) ? [NSString stringWithFormat:@"%@ \n%@",content,url] : [NSString stringWithFormat:@"%@ \n%@",title,content];

    if (platformType == 0) {//新浪微博
        
        messageObject.text = shareContent;
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = shareThumImage;
        messageObject.shareObject = shareObject;
    } else {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:content descr:shareContent thumImage:shareThumImage];
        shareObject.webpageUrl = url;
        messageObject.shareObject = shareObject;
    }
 
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:_superVC completion:^(id result, NSError *error) {
        
        if (error) {
            DLog(@"************Share fail with error %@*********",error);
        }else{
            if ([result isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = result;
                //分享结果消息
                DLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
//                DLog(@"response originalResponse result is %@",resp.originalResponse);
            }else{
                DLog(@"response result is %@",result);
            }
        }

    }];
}


@end
