//
//  AnimationTools.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AnimationTools.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation AnimationTools

#pragma mark - 登录界面pop动画效果
+ (void)popViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    // 带有颤动  动画效果
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        // 设置旋转中心点
        [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- push动画
+ (void)pushViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
    //旋转角度
    viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    // 带有颤动  动画效果
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        // 设置旋转中心点
        [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((360.0f * M_PI) / 180.0f);
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -抖动
+(void)rippleEffectAnimation:(UIView *)views{
    CATransition *anima = [CATransition animation];
    anima.type = @"rippleEffect";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    anima.repeatCount = MAXFLOAT ;
    [views.layer addAnimation:anima forKey:@"rippleEffectAnimation"];
}
#pragma mark -摇动
+ (void)shakeAnimationWith:(UIView *)views
{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*2];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*2];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*2];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = MAXFLOAT;
    [views.layer addAnimation:anima forKey:@"shakeAnimation"];
}
#pragma mark -弹出
+ (void)makeAnimationBottom:(UIView *)views
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
+ (void)makeAnimationFade:(UIViewController *)nextVc :(UINavigationController *)nav
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav pushViewController:nextVc animated:NO];
    
}

+ (void)makeAnimationFade:(UINavigationController *)nav
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav popViewControllerAnimated:NO];
    
}


+ (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5f);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2.0f);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}
/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
     //y值向下拉的时候是负的值
     CGFloat yOffset = scrollView.contentOffset.y;
     //    NSLog(@"此时的Y坐标    %lf",y);
     if (yOffset < -180)
     {
         CGRect frame = _cycleScrollView.frame;
         frame.origin.y = yOffset;
         frame.size.height = - yOffset;
         _cycleScrollView.frame = frame;
     }
 }

 #pragma mark - SDCycleScrollViewDelegate
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
 {
 DLog(@"---点击了第%ld张图片", (long)index);
 }

 
 
 */
@end
