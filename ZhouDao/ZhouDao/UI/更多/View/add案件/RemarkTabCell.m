//
//  RemarkTabCell.m
//  ZhouDao
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RemarkTabCell.h"

@implementation RemarkTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self titleLab];
        [self textView];
        
        [self placeHoldlab];
    }
    return self;
}
- (UILabel *)titleLab
{
    if (!_titLab) {
       _titLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        _titLab.textAlignment = NSTextAlignmentLeft;
        _titLab.font = Font_15;
        _titLab.text = @"备注:";
        [self.contentView addSubview:_titLab];
    }
    return _titLab;
}
- (UITextView *)textView
{
    if (!_textView) {
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 30, kMainScreenWidth - 30.f, 75)];
        _textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        _textView.font = Font_14;
        _textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        _textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _textView.scrollEnabled = YES;//是否可以拖动
        _textView.layer.borderColor = ABORDERColor.CGColor;
        _textView.layer.borderWidth = .6f;
        [self.contentView addSubview:_textView];//加入到整个页面中
    }
    return _textView;
}
- (UILabel *)placeHoldlab
{
    if (!_placeHoldlab) {
        _placeHoldlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth - 30.f, 30)];
        _placeHoldlab.font = Font_14;
        _placeHoldlab.backgroundColor = [UIColor clearColor];
        _placeHoldlab.text = @" 写备注...";
        _placeHoldlab.textColor = SIXCOLOR;
        [self.textView addSubview:_placeHoldlab];
    }
    return _placeHoldlab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
