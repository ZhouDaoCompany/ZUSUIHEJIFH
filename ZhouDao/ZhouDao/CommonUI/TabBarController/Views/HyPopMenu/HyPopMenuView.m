//
//  HyPopMenuView.m
//  ZhouDao
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HyPopMenuView.h"
#import <pop/POP.h>
#import "CustomButton.h"

#define Duration 0.2
#define MenuButtonHeight ([UIScreen mainScreen].bounds.size.width > 320)?110:100
#define MenuButtonVerticalPadding 10
#define MenuButtonHorizontalMargin 10
#define MenuButtonAnimationTime 0.2
#define MenuButtonAnimationInterval (MenuButtonAnimationTime / 5)

#define kMenuButtonBaseTag 7700

@interface HyPopMenuView()
{
    UIWindow *window;
}

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy)   SelectdCompletionBlock block;
@property (nonatomic,strong) UIView *botomView;//白底
@property (nonatomic,strong) UIImageView *botomImgView; //
@property (nonatomic,strong) UIImageView *rotatingImg;
@end

@implementation HyPopMenuView
+(void)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
           SelectdCompletionBlock:(SelectdCompletionBlock)block
{
    HyPopMenuView *menu = [[HyPopMenuView alloc] initWithItmes:Items];
    [menu SelectdCompletionBlock:block];
}
-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes
{
    self = [super init];
    if (self) {
        _items = Itmes;
        [self show];
        [self setup];
    }
    return self;
}
- (void)setup {WEAKSELF;
    [self setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    
    [self addSubview:self.botomView];
    [self addSubview:self.botomImgView];
    [self addSubview:self.rotatingImg];
    
    [self whenCancelTapped:^{
        [weakSelf dismiss];
    }];
    [_botomView whenCancelTapped:^{
        
    }];
    
    [self showButtons];
}
#pragma mark - private methods
#pragma mark - getters and setters
- (UIView *)botomView
{
    if (!_botomView) {
        CGRect rect;
        if(kMainScreenWidth >320){
            rect = CGRectMake(15, kMainScreenHeight-299,kMainScreenWidth-30 , 250);
        }else {
            rect = CGRectMake(15, kMainScreenHeight-269,kMainScreenWidth-30 , 220);
        }
        _botomView = [[UIView alloc] initWithFrame:rect];
        _botomView.backgroundColor = [UIColor whiteColor];
        LRViewBorderRadius(_botomView, 5.f, 0, [UIColor clearColor]);
    }
    return _botomView;
}
- (UIImageView *)botomImgView
{
    if (!_botomImgView) {
        _botomImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 145.5f)/2.f , Orgin_y(_botomView) -1, 145.5f, 48)];
        [_botomImgView setImage:[UIImage imageNamed:@"BottomImg"]];
    }
    return _botomImgView;
}
- (UIImageView *)rotatingImg
{
    if (!_rotatingImg) {
        _rotatingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fork"]];
        _rotatingImg.center = CGPointMake(_botomImgView.center.x +1, _botomImgView.center.y);
        _rotatingImg.bounds = CGRectMake(0, 0, 40, 40);
    }
    return _rotatingImg;
}

- (void)showButtons {
    NSArray *items = [self menuItems];
    NSUInteger index = 0;
    NSInteger perRowItemCount = 3;
    CGFloat menuButtonWidth = (CGRectGetWidth(_botomView.bounds) - ((perRowItemCount + 1) * MenuButtonHorizontalMargin)) / perRowItemCount;
    
#pragma mark -添加按钮
    for (MenuLabel *Obj in items) {
        CGRect toRect = [self getFrameWithItemCount:items.count perRowItemCount:perRowItemCount perColumItemCount:3 itemWidth:menuButtonWidth itemHeight:MenuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:MenuButtonHorizontalMargin atIndex:index onPage:0];
        CGRect fromRect = toRect;
        fromRect.origin.y = CGRectGetHeight(_botomView.bounds);
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
    [_botomView addSubview:button];
    return button;
}
-(void)SelectdCompletionBlock:(SelectdCompletionBlock) block{
    _block = block;
}

- (NSArray *)menuItems {
    return self.items;
}
#pragma mark -UIButton Event
-(void)selectd:(CustomButton *)button
{WEAKSELF;
    NSInteger tag = button.tag - (kMenuButtonBaseTag + 1);
#pragma mark -消失动画
    [button SelectdAnimation];
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
        if (weakSelf.block) {
            
            weakSelf.block(button.MenuData,tag);
        }
    }];
}
#pragma mark - 消失
-(void)dismiss{
    for (MenuLabel *label in _items) {
        NSInteger index = [_items indexOfObject:label];
        CustomButton *buttons = (CustomButton *)[self viewWithTag:(index + 1) + kMenuButtonBaseTag];
        [buttons CancelAnimation];
    }
    [self HidDelay:0.25f CompletionBlock:^(BOOL completion) {
    }];
}
-(void)HidDelay:(NSTimeInterval)delay
CompletionBlock:(void(^)(BOOL completion))blcok
{WEAKSELF;
    [UIView animateKeyframesWithDuration:Duration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        weakSelf.botomView.frame = CGRectMake(0, kMainScreenHeight, kMainScreenWidth, 360);
        weakSelf.botomImgView.frame = CGRectMake(0, kMainScreenHeight +360, 145.5f, 48);
        weakSelf.rotatingImg.transform =CGAffineTransformRotate(_rotatingImg.transform, REES_TO_RADIANS(-45));//CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        blcok(finished);
        [weakSelf removeFromSuperview];
    }];
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
    _botomView = nil;
    _botomImgView = nil;
    _rotatingImg = nil;
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
    CGFloat insetY = (CGRectGetHeight(_botomView.bounds) - (itemHeight + paddingY) * rowCount) / 2.0;
    CGFloat originX = (index % perRowItemCount) * (itemWidth + paddingX) + paddingX + (page * CGRectGetWidth(self.bounds));
    CGFloat originY = ((index / perRowItemCount) - perColumItemCount * page) * (itemHeight + paddingY) + paddingY -10.f;
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

@end
