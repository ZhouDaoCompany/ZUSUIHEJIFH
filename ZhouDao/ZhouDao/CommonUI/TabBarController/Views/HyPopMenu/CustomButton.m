//
//  CustomButton.m
//  ZhouDao
//
//  Created by cqz on 16/5/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CustomButton.h"
#import "MenuLabel.h"

#define KeyPath @"transform.scale"

@interface CustomButton ()<CAAnimationDelegate>

@end

@implementation CustomButton

-(instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //2.文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        //3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addTarget:self action:@selector(scaleToSmall)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(scaleToDefault)
       forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

-(void)setMenuData:(MenuLabel *)MenuData{
    
    _MenuData = MenuData;
    UIImage *image = [UIImage imageNamed:MenuData.iconName];
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:MenuData.title forState:UIControlStateNormal];
    //UIColor *color = [UIColor getPixelColorAtLocation:CGPointMake(50, 20) inImage:image];
    UIColor *color = [UIColor colorWithHexString:@"#333333"];
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)scaleToSmall
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:KeyPath];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.1f];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

- (void)scaleToDefault
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:KeyPath];
    theAnimation.delegate = self;
    theAnimation.duration = 0.1;
    theAnimation.repeatCount = 0;
    theAnimation.removedOnCompletion = FALSE;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1.1f];
    theAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.imageView.layer addAnimation:theAnimation forKey:theAnimation.keyPath];
}

-(void)SelectdAnimation{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:KeyPath];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @1.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
}

-(void)CancelAnimation{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:KeyPath];
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 0;
    scaleAnimation.removedOnCompletion = FALSE;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.delegate = self;
    opacityAnimation.duration = 0.2;
    opacityAnimation.repeatCount = 0;
    opacityAnimation.removedOnCompletion = FALSE;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.fromValue = @1;
    opacityAnimation.toValue = @0;
    
    [self.layer addAnimation:scaleAnimation forKey:scaleAnimation.keyPath];
    [self.layer addAnimation:opacityAnimation forKey:opacityAnimation.keyPath];
    
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWidth =contentRect.size.width/1.5f;
    if (kMainScreenWidth >=375) {
        imageWidth = contentRect.size.width/1.6f;
    }
    CGFloat imageX = CGRectGetWidth(contentRect)/2.f - imageWidth/2.f;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = CGRectGetHeight(self.bounds) - (imageHeight + 30);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = 20;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX,titleY, titleWidth, titleHeight);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
