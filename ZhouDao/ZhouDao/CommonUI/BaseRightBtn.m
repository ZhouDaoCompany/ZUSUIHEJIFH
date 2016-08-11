//
//  BaseRightBtn.m
//  ZhouDao
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BaseRightBtn.h"

@implementation BaseRightBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rectFrame ;
    CGRect imgFrame ;
    
    if (self.imageView.image && self.titleLabel.text.length >0) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        rectFrame = CGRectMake(0, 12, self.frame.size.width - 28, 20);
        imgFrame = CGRectMake(self.frame.size.width - 28, 6, 20, 30);
    }else if (!self.imageView.image && self.titleLabel.text.length >0){
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        rectFrame = CGRectMake(0, 12, self.frame.size.width, 20);
        imgFrame = CGRectMake(0, 0, 0, 0);

    }else if (self.imageView.image && self.titleLabel.text.length ==0){
        imgFrame = CGRectMake((self.frame.size.width - 24)/2.f, 10, 24, 24);
        rectFrame = CGRectMake(0, 0, 0, 0);
    }else {
        rectFrame = CGRectMake(0, 0, 0, 0);
        imgFrame = CGRectMake(0, 0, 0, 0);
    }

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.frame = rectFrame;
    self.imageView.frame = imgFrame;
}

//文字相对按钮的位置
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//}
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(self.frame.size.width - 25, 6, 20, 30);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
