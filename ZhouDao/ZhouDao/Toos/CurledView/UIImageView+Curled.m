//
//  AppDelegate.m
//  KindergartenApp
//
//  Created by apple on 14/12/19.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "UIImageView+Curled.h"
#import "CurledViewBase.h"
#import "QuartzCore/QuartzCore.h"


@interface UIImageView(private)
-(void)setImage:(UIImage*)image withBorderWidth:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset;
@end


@implementation UIImageView (Curled)

-(void)configureBorder:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset

{
    [self.layer setBorderWidth:borderWidth];
    [self setContentMode:UIViewContentModeCenter];
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.0, 4.0)];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOpacity:0.4];
    
    UIBezierPath* path = [CurledViewBase curlShadowPathWithShadowDepth:shadowDepth
                                                   controlPointXOffset:controlPointXOffset
                                                   controlPointYOffset:controlPointYOffset
                                                               forView:self];
    [self.layer setShadowPath:path.CGPath];
}

-(void)setImage:(UIImage*)image borderWidth:(CGFloat)borderWidth shadowDepth:(CGFloat)shadowDepth controlPointXOffset:(CGFloat)controlPointXOffset controlPointYOffset:(CGFloat)controlPointYOffset
{
    self.backgroundColor = [UIColor clearColor];
    
    // delegate to CurledViewBase
    [self configureBorder:borderWidth shadowDepth:shadowDepth controlPointXOffset:controlPointXOffset controlPointYOffset:controlPointYOffset];
    
    UIImage* scaledImage = [CurledViewBase rescaleImage:image forView:self];
    [self setImage:scaledImage];
}

@end
