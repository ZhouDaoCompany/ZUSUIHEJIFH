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
    if (self) {
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 71 ) / 2.f, 120, 71, 71)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"CollectEmpty"];
        [self addSubview:img];
        
        UILabel* lab = [[UILabel alloc] init];
        lab.text = textStr;
        lab.textColor = [UIColor colorWithHexString:@"#cccccc"];
        lab.font = [UIFont systemFontOfSize:15];
        CGSize s = [lab.text textSizeWithFont:lab.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lab.frame = CGRectMake((self.frame.size.width - s.width) / 2, 211, s.width, s.height);
        [self addSubview:lab];
    }
    return self;
}

- (instancetype)initTingShiTheDefaultWithDelegate:(id<CollectEmptyViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64)];
    
    if (self) { WEAKSELF;
        
        _delegate = delegate;
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 71 ) / 2.f, 120, 71, 71)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"CollectEmpty"];
        [self addSubview:img];
        
        
        UILabel *lab1 = [[UILabel alloc] init];
        CGSize s = [@"暂无庭室信息，立即添加" textSizeWithFont:Font_14 constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lab1.frame = CGRectMake((self.frame.size.width - s.width) / 2, 211, s.width, s.height);
        lab1.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"暂无庭室信息，立即添加"];
        NSRange range1=[[hintString string]rangeOfString:@"暂无庭室信息，"];
        [hintString addAttribute:NSForegroundColorAttributeName value:SIXCOLOR range:range1];
        NSRange range2=[[hintString string]rangeOfString:@"立即添加"];
        [hintString addAttribute:NSForegroundColorAttributeName value:KNavigationBarColor range:range2];
        lab1.attributedText=hintString;
        lab1.font = Font_14;
        [self addSubview:lab1];
        
        [lab1 whenCancelTapped:^{
            
            if ([weakSelf.delegate respondsToSelector:@selector(clickAddText)]) {
                
                [weakSelf.delegate clickAddText];
            }
        }];

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
