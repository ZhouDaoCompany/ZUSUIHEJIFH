//
//  LitigationCell.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LitigationCell.h"

@implementation LitigationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.deviceLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.imgview1];

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];//lineColor;
        [self.contentView addSubview:lineView];
        

        
    }
    return self;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = Font_15;
        _titleLab.textColor = thirdColor;
    }
    return _titleLab;
}
- (UILabel *)deviceLabel
{
    if(!_deviceLabel){
        
        _deviceLabel = [[UILabel alloc] init];
        _deviceLabel.textAlignment = NSTextAlignmentRight;
        _deviceLabel.font = Font_14;
       _deviceLabel.textColor = thirdColor;
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
    }
    return _textField;
}
- (UIImageView *)imgview1
{
    if (!_imgview1) {
        _imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _imgview1.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _imgview1.userInteractionEnabled = YES;
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
    
    if (_section == 0)
    {
        if (_rowIndex == 6) {
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
                _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }else{
                _textField.keyboardType = UIKeyboardTypeDefault;
            }
        }
    }else{
        
        if ([_titleLab.text isEqualToString:@"审理类别"] || [_titleLab.text isEqualToString:@"仲裁结果"] || [_titleLab.text isEqualToString:@"审判结果"] || [_titleLab.text isEqualToString:@"收到法律文书时间"])
        {
            
            _deviceLabel.hidden = NO;
            _imgview1.hidden = NO;
            _textField.hidden = YES;
            _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 10, 150, 30);
            
        }else {
            
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

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
