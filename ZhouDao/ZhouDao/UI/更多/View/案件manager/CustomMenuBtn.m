//
//  CustomMenuBtn.m
//  ZhouDao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CustomMenuBtn.h"
#define BtnWidth [UIScreen mainScreen].bounds.size.width/4.f
#define leftX    (BtnWidth-20.f)/2.f
#define TopY     13.f

@implementation CustomMenuBtn
- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.font = Font_14;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//文字相对按钮的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 40, BtnWidth, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(leftX, TopY, 20, 20);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
