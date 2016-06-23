//
//  HyPopMenuView.m
//  HyPopMenuView
//
//  Created by  H y on 15/9/8.
//  Copyright (c) 2015年 ouy.Aberi. All rights reserved.
//

#import "MenuLabel.h"
#import <pop/POP.h>
#import "HyPopMenuView.h"
#import "UIColor+ImageGetColor.h"

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
//#define Interval (0.195 / _ItmesArr.count)

@interface HyPopMenuView ()
{
    UIWindow *window;
    UIImage *bulrImage;
}
@property (nonatomic,weak) UIView *BlurView;
@property (nonatomic,retain) NSArray *ItmesArr;
@property (nonatomic,strong) SelectdCompletionBlock block;
@property (nonatomic,assign) BOOL is;
@property (nonatomic,strong) UIView *botomView;//白底
@property (nonatomic,strong) UIImageView *botomImgView; //
@property (nonatomic,strong) UIImageView *rotatingImg;
@end

@implementation HyPopMenuView

+(void)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
                          TopView:(UIView *)topView
       OpenOrCloseAudioDictionary:(NSDictionary *)openOrCloseAudioDictionary
           SelectdCompletionBlock:(SelectdCompletionBlock)block{

    HyPopMenuView *menu = [[HyPopMenuView alloc] initWithItmes:Items];
    [menu SelectdCompletionBlock:block];
}

-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes
{
    self = [super init];
    if (self) {
        _is = true;
        _ItmesArr = Itmes;
        [self setFrame:CGRectMake(0, 0, kW, kH)];
        [self initUI];
        [self show];
        
    }
    return self;
}
-(void)initUI
{
    UIView *BlurView = [[UIView alloc] initWithFrame:self.bounds];
    BlurView.backgroundColor = [UIColor blackColor] ;
    BlurView.alpha = .3f;
    _BlurView = BlurView;
    [self addSubview:_BlurView];
    self.backgroundColor = [UIColor clearColor];
    
    float width = self.frame.size.width;
    // float height = self.frame.size.height;
  
    if (kMainScreenHeight >568) {
          _botomView = [[UIView alloc] initWithFrame:CGRectMake(15, kMainScreenHeight-329,width-30 , 280)];
    }else{
        _botomView = [[UIView alloc] initWithFrame:CGRectMake(15, kMainScreenHeight-299,width-30 , 250)];
    }

    _botomView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    _botomView.layer.cornerRadius = 5.f;
    _botomView.layer.masksToBounds = YES;
    [self addSubview:_botomView];
    

    _botomImgView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 145.5f)/2.f , Orgin_y(_botomView) -1, 145.5f, 48)];
    [_botomImgView setImage:[UIImage imageNamed:@"BottomImg"]];
    [self addSubview:_botomImgView];
    
    _rotatingImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fork"]];
//    _rotatingImg.userInteractionEnabled = YES;
    _rotatingImg.center = CGPointMake(_botomImgView.center.x +1, _botomImgView.center.y);
    _rotatingImg.bounds = CGRectMake(0, 0, 40, 40);
    [self addSubview:_rotatingImg];

    CGRect fromValue = CGRectMake(kMainScreenWidth/2.f, kMainScreenHeight, 0, 0);
    
    [self StartTheAnimationFromValue:fromValue ToValue:_botomView.frame Delay:.35 Object:_botomView CompletionBlock:^(BOOL CompletionBlock) {
    } HideDisplay:false];
    [self StartTheAnimationFromValue:fromValue ToValue:_botomImgView.frame Delay:.35 Object:_botomImgView CompletionBlock:^(BOOL CompletionBlock) {
    } HideDisplay:false];

    [UIView animateWithDuration:.2 animations:^{
        _rotatingImg.transform = CGAffineTransformRotate(_rotatingImg.transform, REES_TO_RADIANS(90));
    }];
   // [ConFunc rippleEffectAnimation:_botomView];

    [self CirculatingItmes];
}

-(void)CirculatingItmes
{
//    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
//    UIView *downView = [CancelButton superview];
//    
//    typeof(self) weak = self;
//    [UIView animateWithDuration:Duration animations:^{
//        [weak setAlpha:1];
//        CancelButton.transform=CGAffineTransformMakeRotation((M_PI/2)/2);
//    }];
    
    NSInteger index = 0;
    
    //float widthW = self.botomView.frame.size.width;
    float heightH = self.botomView.frame.size.height;
    
#pragma mark -添加按钮
    for (MenuLabel *Obj in _ItmesArr) {
        CGFloat buttonX,buttonY;
        buttonX = (index % HowMucHline) * ButtonWidth;
        if (kMainScreenHeight >568) {
             buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (heightH/2.85) -95;
        }else{
             buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (heightH/2.85) -70;
        }

        CGRect fromValue = CGRectMake(buttonX, CGRectGetMinY(self.botomImgView.frame) +50, ButtonWidth, ButtonHigh);
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

//    NSInteger index = 0;
//    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
//    UIView *downView = CancelButton.superview;

    //    for (MenuLabel *label in _ItmesArr) {
//        CustomButton *button = (CustomButton *)[self viewWithTag:(index + 1) + ButtonTag];
//        button.MenuData = label;
//        CGFloat buttonX,buttonY;
//        buttonX = (index % HowMucHline) * ButtonWidth;
//        buttonY = ((index / HowMucHline) * (ButtonHigh +10)) + (kH/2.9);
//        
//        CGRect toValue = CGRectMake(buttonX, kH, ButtonWidth, ButtonHigh);
//        CGRect fromValue = CGRectMake(buttonX, buttonY, ButtonWidth, ButtonHigh);
//        double delayInSeconds = (_ItmesArr.count - index) * Interval;
//        CFTimeInterval delay = delayInSeconds + CACurrentMediaTime();
//        
//        [UIView animateWithDuration:0.35f animations:^{
//            [button setAlpha:0.1f];
//            [self setBackgroundColor:[UIColor clearColor]];
//        }];
//        
//        [self StartTheAnimationFromValue:fromValue ToValue:toValue Delay:delay Object:button CompletionBlock:^(BOOL CompletionBlock) {
//        } HideDisplay:true];
//        index ++;
//    }
    [UIView animateWithDuration:0.25 animations:^{
//       [_botomImgView removeFromSuperview];
        [_botomImgView setAlpha:0.1f];
         [_botomView setAlpha:0.1f];
        _botomImgView.backgroundColor = [UIColor clearColor];
        _botomView.backgroundColor = [UIColor clearColor];
    }];
//    [_botomImgView removeFromSuperview];
//    CGRect fromValue = CGRectMake(kMainScreenWidth/2.f, kMainScreenHeight+10.f, 0, 0);
//    
//    [self StartTheAnimationFromValue:_botomView.frame ToValue:fromValue Delay:.35f Object:_botomView CompletionBlock:^(BOOL CompletionBlock) {
//        
//    } HideDisplay:false];

    [self HidDelay:0.3f CompletionBlock:^(BOOL completion) {
        
    }];
}
-(void)selectd:(CustomButton *)button
{
    NSInteger tag = button.tag - (ButtonTag + 1);
    typeof(self) weak = self;
#pragma mark -消失动画
    for (MenuLabel *label in _ItmesArr) {
        NSInteger index = [_ItmesArr indexOfObject:label];
        CustomButton *buttons = (CustomButton *)[self viewWithTag:(index + 1) + ButtonTag];
        if (index == tag) {
            [button SelectdAnimation];
        }else{
            [buttons CancelAnimation];
        }
    }
    [self HidDelay:0.3f CompletionBlock:^(BOOL completion) {
        if (!weak.block) {
            return ;
        }
        weak.block(button.MenuData,tag);
    }];
}

-(void)HidDelay:(NSTimeInterval)delay
CompletionBlock:(void(^)(BOOL completion))blcok
{
//    ImageView *CancelButton = (ImageView *)[self viewWithTag:11];
//    UIView *downView = [CancelButton superview];
//    [self setUserInteractionEnabled:false];
      typeof(self) weak = self;
//    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//       
//        [downView setBackgroundColor:[UIColor clearColor]];
//        CancelButton.transform = CGAffineTransformMakeRotation(0);
//        [CancelButton setAlpha:0.1f];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    [UIView animateKeyframesWithDuration:Duration delay:delay options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [weak setAlpha:0.0f];
        
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
    
    [UIView animateWithDuration:.35 animations:^{
        
        _rotatingImg.transform =CGAffineTransformRotate(_rotatingImg.transform, REES_TO_RADIANS(-45));//CGAffineTransformIdentity;
    }];
//    UIView *button = [self viewWithTag:10];
//    [button setUserInteractionEnabled:false];
//    [self setUserInteractionEnabled:false];
    typeof(self) weak = self;
    [self DismissCompletionBlock:^(BOOL CompletionBlock) {
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

@end