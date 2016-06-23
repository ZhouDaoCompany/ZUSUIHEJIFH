//
//  CollectEmptyView.m
//  ZhouDao
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CollectEmptyView.h"
#import "NSString+Size.h"

#define MAXFLOAT    0x1.fffffep+127f

@implementation CollectEmptyView
- (id)initWithFrame:(CGRect)frame WithText:(NSString *)textStr{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 71 ) / 2.f, 140, 71, 71)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"CollectEmpty"];
        [self addSubview:img];
        
        UILabel* lab = [[UILabel alloc] init];
        lab.text = textStr;
        lab.textColor = [UIColor colorWithHexString:@"#cccccc"];
        lab.font = [UIFont systemFontOfSize:15];
        CGSize s = [lab.text textSizeWithFont:lab.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lab.frame = CGRectMake((self.frame.size.width - s.width) / 2, 231, s.width, s.height);
        [self addSubview:lab];
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
