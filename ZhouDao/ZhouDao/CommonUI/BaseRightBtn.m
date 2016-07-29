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
    if (self.imageView.image) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//文字相对按钮的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.imageView.image) {
        return CGRectMake(0, 12, self.frame.size.width - 25, 20);
    }
    return CGRectMake(0, 12, self.frame.size.width, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width - 25, 6, 20, 30);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
