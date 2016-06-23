//
//  SelectReusableView.m
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import "SelectReusableView.h"
#define Orgin_y(container)   (container.frame.origin.y+container.frame.size.height)
#define Orgin_x(container)   (container.frame.origin.x+container.frame.size.width)

@implementation SelectReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =rgb(242, 242, 242);
        self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
        self.titLab.font = [UIFont systemFontOfSize:15.f];
        self.titLab.text = @"您的擅长领域";
        [self.titLab setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [self addSubview:self.titLab];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(self.titLab) +10, 10, 100, 20)];
        lab.font = [UIFont systemFontOfSize:12.f];
        [lab setTextColor:[UIColor colorWithHexString:@"#666666"]];
        lab.text = @" (最多选择12项)";
        [self addSubview:lab];
        
        
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:_stateStr forState:0];
        [_editBtn setTitleColor:KNavigationBarColor forState:0];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"mine_box"] forState:0];
        _editBtn.titleLabel.font = Font_12;
        [_editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
        _editBtn.frame = CGRectMake(self.frame.size.width - 60, 5, 45, 20);
        [self addSubview:_editBtn];
    }
    return self;
}
- (void)setStateStr:(NSString *)stateStr
{
    _stateStr = nil;
    _stateStr = stateStr;
    [_editBtn setTitle:_stateStr forState:0];
}
#pragma mark -UIButtonEvent
- (void)editClick:(id)sender
{
    if ([self.delegete respondsToSelector:@selector(editStateShake)])
    {
        [self.delegete editStateShake];
    }
    DLog(@"进入编辑状态－");
    
}
//- (void) setLabelText:(NSString *)text
//{
//    self.titLab.text = nil;
//    self.titLab.text = text;
//}

@end
