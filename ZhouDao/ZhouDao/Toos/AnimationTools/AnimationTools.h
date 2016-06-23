//
//  AnimationTools.h
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationTools : NSObject
+ (void)popViewControllerAnimatedWithViewController:(UIViewController *)viewController;
#pragma mark -- push动画
+ (void)pushViewControllerAnimatedWithViewController:(UIViewController *)viewController;
#pragma mark -抖动
+(void)rippleEffectAnimation:(UIView *)views;
//摇动
+ (void)shakeAnimationWith:(UIView *)views;
#pragma mark -弹出
+ (void)makeAnimationBottom:(UIView *)views;

//界面渐消
+ (void)makeAnimationFade:(UIViewController *)nextVc :(UINavigationController *)nav;
+ (void)makeAnimationFade:(UINavigationController *)nav;

@end
