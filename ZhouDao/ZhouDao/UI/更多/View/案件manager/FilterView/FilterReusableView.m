//
//  FilterReusableView.m
//  UItext
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "FilterReusableView.h"

@implementation FilterReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        self.label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.label];
    }
    return self;
}

- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
}


@end
