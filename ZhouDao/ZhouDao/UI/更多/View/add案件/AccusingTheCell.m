//
//  AccusingTheCell.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AccusingTheCell.h"

@implementation AccusingTheCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self titleLab];
        
        [self deviceLabel];
        
        [self textField];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = lineColor;
        [self.contentView addSubview:lineView];
        
        [self imgview1];
    }
    return self;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = Font_15;
        [self.contentView addSubview:_titleLab];
    }
    
    return _titleLab;
}
- (UILabel *)deviceLabel
{
    if (!_deviceLabel) {
       
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.textAlignment = NSTextAlignmentRight;
        _deviceLabel.font = Font_14;
        _deviceLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_deviceLabel];
    }
    return _deviceLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = Font_14;
        [self.contentView addSubview:_textField];
    }
    return _textField;
}
- (UIImageView *)imgview1
{
    if (!_imgview1) {
        _imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _imgview1.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _imgview1.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgview1];
    }
    return _imgview1;
}
- (void)settingFrame
{
    self.titleLab.frame = CGRectMake(15, 15, 140, 20);
    
    if (_isEdit == YES) {
        if (_deviceLabel.text.length == 0) {
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"请选择"];
            NSRange range1=[[hintString string]rangeOfString:@"请选择"];
            [hintString addAttribute:NSForegroundColorAttributeName value:sixColor range:range1];
            _deviceLabel.attributedText=hintString;
        }
    }

    
    if (_rowIndex ==6 || _rowIndex == 7)
    {
        _deviceLabel.hidden = NO;
        _imgview1.hidden = NO;
        _textField.hidden = YES;
        _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 10, 150, 30);
    }else{
        _deviceLabel.hidden = YES;
        _imgview1.hidden = YES;
        _textField.hidden = NO;
        _textField.frame = CGRectMake(kMainScreenWidth - 151.f, 10, 130, 30);
        
        [_textField setValue:Font_12 forKeyPath:@"_placeholderLabel.font"];
        
        if ([QZManager isString:_titleLab.text withContainsStr:@"电话"]) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            _textField.keyboardType = UIKeyboardTypeDefault;
        }
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
