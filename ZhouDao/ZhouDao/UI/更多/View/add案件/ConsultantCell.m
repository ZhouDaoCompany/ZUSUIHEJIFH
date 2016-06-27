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
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = Font_15;
        [self.contentView addSubview:self.titleLab];
        
        self.deviceLabel = [[UILabel alloc] init];
        self.deviceLabel.textAlignment = NSTextAlignmentRight;
        self.deviceLabel.font = Font_14;
        self.deviceLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.deviceLabel];
        
        
        self.textField = [[CaseTextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = Font_14;
        [self.contentView addSubview:self.textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 49.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = lineColor;
        [self.contentView addSubview:lineView];
        
        _arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth-21, 20, 6, 10)];
        _arrowImg.image = [UIImage imageNamed:@"Esearch_jiantou"];
        _arrowImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_arrowImg];
        
    }
    return self;
}

- (void)layoutSubviews
{
    self.titleLab.frame = CGRectMake(15, 15, 140, 20);

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
