//
//  ConsultantHeadView.m
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "ConsultantHeadView.h"
#import "DefineHeader.h"

@interface ConsultantHeadView()

@property (nonatomic, assign) NSInteger section;

@end

@implementation ConsultantHeadView

- (id)initWithFrame:(CGRect)frame withSection:(NSInteger)section
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        
        _section = section;
        self.label = [[UILabel alloc] init];
        self.label.frame = CGRectMake(15, 0, 120, self.frame.size.height);
        self.label.font = [UIFont systemFontOfSize:15.f];
        [self.label setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [self addSubview:self.label];
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delBtn.titleLabel.font = Font_12;
        delBtn.backgroundColor = [UIColor colorWithHexString:@"#00c8aa"];
        delBtn.frame = CGRectMake(kMainScreenWidth - 55.f, 10.f, 40 , 25);
        [delBtn setTitle:@"删除" forState:0];
        delBtn.layer.masksToBounds = YES;
        delBtn.layer.cornerRadius = 5.f;
        [delBtn addTarget:self action:@selector(deleteEventRespose:) forControlEvents:UIControlEventTouchUpInside];
        _delBtn = delBtn;
        [self addSubview:_delBtn];
        
    }
    return self;
}
- (void)deleteEventRespose:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteSectionEventRespose:)])
    {
        [self.delegate deleteSectionEventRespose:_section];
    }
}
- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
    //    [self.label sizeToFit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
