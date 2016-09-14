//
//  ConsultantCell.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ConsultantCell.h"

@implementation ConsultantCell

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
        lineView.backgroundColor = LINECOLOR;
        [self.contentView addSubview:lineView];
        
        [self arrowImg];
    }
    return self;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = Font_15;
        _titleLab.textColor = THIRDCOLOR;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}
- (UILabel *)deviceLabel
{
    if(!_deviceLabel){
        
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.textAlignment = NSTextAlignmentRight;
        _deviceLabel.font = Font_14;
        _deviceLabel.textColor = THIRDCOLOR;
        [self.contentView addSubview:_deviceLabel];
    }
    return _deviceLabel;
}
- (CaseTextField *)textField
{
    if (!_textField)
    {
        self.textField = [[CaseTextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = Font_14;
        //        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        //        [self.textField setValue:[UIFont  systemFontOfSize:9] forKeyPath:@"_placeholderLabel.font"];
        [self.contentView addSubview:self.textField];
    }
    return _textField;
}
- (UIImageView *)arrowImg
{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _arrowImg.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _arrowImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_arrowImg];
    }
    
    return _arrowImg;
}
- (void)settingFrame
{
    self.titleLab.frame = CGRectMake(15, 15, 140, 20);
    
    if (_isEdit == YES) {
        if (_deviceLabel.text.length == 0) {
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"请选择"];
            NSRange range1=[[hintString string]rangeOfString:@"请选择"];
            [hintString addAttribute:NSForegroundColorAttributeName value:SIXCOLOR range:range1];
            _deviceLabel.attributedText=hintString;
        }
    }
    
    if ((_sectionIndex ==0 && _rowIndex == 1) || (_sectionIndex ==0 && _rowIndex == 2))
    {
        _deviceLabel.hidden = NO;
        _arrowImg.hidden = NO;
        _textField.hidden = YES;
        _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 10, 150, 30);
    }else{
        
        _deviceLabel.hidden = YES;
        _arrowImg.hidden = YES;
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
