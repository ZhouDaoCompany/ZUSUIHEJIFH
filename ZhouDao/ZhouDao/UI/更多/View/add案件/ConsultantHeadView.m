//
//  ConsultantHeadView.m
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "ConsultantHeadView.h"

@interface ConsultantHeadView()

@property (nonatomic, assign) NSInteger section;

@end

@implementation ConsultantHeadView

- (id)initWithFrame:(CGRect)frame withSection:(NSInteger)section
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
        
        _section = section;
        [self addSubview:self.label];
        [self addSubview:self.delBtn];
        
    }
    return self;
}
- (void)deleteEventRespose:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteSectionEventRespose:)]) {
        
        [self.delegate deleteSectionEventRespose:_section];
    }
}
- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
}
#pragma mark - setters and getters
- (UIButton *)delBtn
{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(kMainScreenWidth - 55.f, 10.f, 40 , 25);
        [_delBtn setImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
        [_delBtn addTarget:self action:@selector(deleteEventRespose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(15, 0, 120, self.frame.size.height);
        _label.font = [UIFont systemFontOfSize:15.f];
        [_label setTextColor:hexColor(333333)];
        _label.text = @"添加更多信息";
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
