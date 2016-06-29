//
//  FinanceTabCell.m
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FinanceTabCell.h"

@implementation FinanceTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = Font_15;
        [self.contentView addSubview:self.titleLab];
        
        self.deviceLabel = [[UILabel alloc] init];
        self.deviceLabel.textAlignment = NSTextAlignmentRight;
        self.deviceLabel.font = Font_14;
        self.deviceLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.deviceLabel];
        
        self.textField = [[UITextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = Font_14;
        //        [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        //        [self.textField setValue:[UIFont  systemFontOfSize:9] forKeyPath:@"_placeholderLabel.font"];
        
        [self.contentView addSubview:self.textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];//lineColor;
        [self.contentView addSubview:lineView];
        
        _imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _imgview1.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _imgview1.userInteractionEnabled = YES;
        [self.contentView addSubview:_imgview1];
        
    }
    return self;
}
- (void)AdjustmentOfTheCell{
    
    self.titleLab.frame = CGRectMake(15, 15, 140, 20);

    
    if (_currentBtnTag == 1 || _currentBtnTag == 4)
    {
        
        if (_currentBtnTag == 1 && [_titleLab.text isEqualToString:@"提成金额(%)"]) {
            _deviceLabel.hidden = NO;
            _imgview1.hidden = YES;
            _textField.hidden = YES;
            _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 7.5f, 150, 30);
        }else {
            _deviceLabel.hidden = YES;
            _imgview1.hidden = YES;
            _textField.hidden = NO;
            _textField.frame = CGRectMake(kMainScreenWidth - 151.f, 7.5f, 130, 30);
            [_textField setValue:Font_12 forKeyPath:@"_placeholderLabel.font"];
            
            if ([_titleLab.text isEqualToString:@"总金额"] || [_titleLab.text isEqualToString:@"提成比例"] || [_titleLab.text isEqualToString:@"费用"]) {
                _textField.keyboardType = UIKeyboardTypeDecimalPad;
            }else{
                _textField.keyboardType = UIKeyboardTypeDefault;
            }

        }

    }else{
        _deviceLabel.hidden = NO;
        _imgview1.hidden = NO;
        _textField.hidden = YES;
        _deviceLabel.frame = CGRectMake(kMainScreenWidth - 175.f, 7.5f, 150, 30);

    }

    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self AdjustmentOfTheCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
