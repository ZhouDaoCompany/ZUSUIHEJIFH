//
//  AllReusableView.m
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import "AllReusableView.h"
#define Orgin_y(container)   (container.frame.origin.y+container.frame.size.height)
#define Orgin_x(container)   (container.frame.origin.x+container.frame.size.width)

@implementation AllReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = LRRGBColor(242, 242, 242);
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 160, 20)];
        lab.font = [UIFont systemFontOfSize:15.f];
        lab.text = @"擅长领域分类列表";
        [self addSubview:lab];
        
        self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 100, 20)];
        self.titLab.font = [UIFont systemFontOfSize:13.f];
        self.titLab.text = @"擅长领域领域分类列表";
        [self.titLab setTextColor:SIXCOLOR];
        [self addSubview:self.titLab];

    }
    return self;
}

-(void)setLabelText:(NSString *)text
{
    self.titLab.text = text;
}

@end
