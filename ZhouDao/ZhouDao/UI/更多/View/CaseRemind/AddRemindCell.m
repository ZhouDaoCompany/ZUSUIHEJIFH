//
//  AddRemindCell.m
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddRemindCell.h"

@implementation AddRemindCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = Font_14;
        self.titleLab.textColor = thirdColor;
        [self.contentView addSubview:self.titleLab];

        self.contentLab = [[UILabel alloc] init];
        self.contentLab.textAlignment = NSTextAlignmentRight;
        self.contentLab.font = Font_14;
        self.contentLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.contentLab];

        self.textField = [[UITextField alloc] init];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = Font_14;
        [self.contentView addSubview:self.textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.4f, kMainScreenWidth-15.f, .6f)];
        lineView.backgroundColor = hexColor(D4D4D4);
        [self.contentView addSubview:lineView];

    }
    
    return self;
}
- (void)settingFrame
{
    self.titleLab.frame = CGRectMake(15, 12.5, 120, 20);

    if (_rowIndex == 0) {
        
        _contentLab.hidden = YES;
//        _imgview1.hidden = YES;
        _textField.hidden = NO;
        _textField.placeholder = @"请输入提醒标签";
        _textField.frame = CGRectMake(kMainScreenWidth - 151.f, 7.5, 130, 30);

    }else{
        
        _contentLab.hidden = NO;
//        _imgview1.hidden = NO;
        _textField.hidden = YES;
        _contentLab.frame = CGRectMake(kMainScreenWidth - 180.f, 7.5, 150, 30);
        
        if (_contentLab.text.length == 0) {
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"请选择"];
            NSRange range1=[[hintString string]rangeOfString:@"请选择"];
            [hintString addAttribute:NSForegroundColorAttributeName value:sixColor range:range1];
            _contentLab.attributedText=hintString;
        }

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
