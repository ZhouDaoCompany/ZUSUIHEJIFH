//
//  commonReusableView.m
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import "commonReusableView.h"

@implementation commonReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = LRRGBColor(242, 242, 242);
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        self.label.font = [UIFont systemFontOfSize:13.f];
        [self.label setTextColor:sixColor];
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
