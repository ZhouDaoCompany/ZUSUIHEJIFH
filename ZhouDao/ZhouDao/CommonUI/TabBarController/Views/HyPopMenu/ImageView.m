//
//  ImageView.m
//  ZhouDao
//
//  Created by cqz on 16/5/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view) {
        return view.superview.superview;//view.superview; or view.superview.superview; or view.superview.superview.superview;... if has
    }else
        return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
