//
//  LPPageControl.m
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LPPageControl.h"

@implementation LPPageControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _pageControl = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, self.frame.size.width - 10, self.frame.size.height - 6)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pageControl];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
