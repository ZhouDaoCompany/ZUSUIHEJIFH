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
    
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.font = Font_15;
}

//文字相对按钮的位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
   return CGRectMake(0, 12, self.frame.size.width - 30, 20);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width - 30, 12, 20, 20);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
