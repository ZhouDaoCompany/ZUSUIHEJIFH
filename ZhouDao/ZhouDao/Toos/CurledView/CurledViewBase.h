//
//  AppDelegate.m
//  KindergartenApp
//
//  Created by apple on 14/12/19.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CurledViewBase : NSObject

+(UIImage*)rescaleImage:(UIImage*)image forView:(UIView*)view;
+(UIBezierPath*)curlShadowPathWithShadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset forView:(UIView*)view;
@end
