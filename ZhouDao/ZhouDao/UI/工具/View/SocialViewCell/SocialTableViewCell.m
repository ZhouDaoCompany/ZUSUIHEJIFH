//
//  SocialTableViewCell.m
//  ZhouDao
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialTableViewCell.h"

@interface SocialTableViewCell()

@property (nonatomic, strong) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation SocialTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}
#pragma mark - methods
- (void)setUIWithTitle:(NSString *)titleName
          withShowText:(NSString *)showText
             withIndex:(NSInteger)index {
    
    _titleLab.text = titleName;
    _textField.text = showText;
    
    if (index == 0) {
        
        _lineView.hidden = NO;
        _textField.enabled = NO;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.frame = CGRectMake(kMainScreenWidth - 165, 7, 130, 30);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _textField.placeholder = @"请选择所在城市";
    } else {
        
        _lineView.hidden = YES;
        _textField.enabled = YES;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.placeholder = @"请输入税前工资";
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - setter and getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, 100, 30)];
        _titleLab.font = Font_15;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = hexColor(000000);
    }
    return _titleLab;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 135, 7, 120, 30)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = hexColor(666666);
        [_textField setValue:hexColor(ADADAD) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.font = Font_14;
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f)];
        _lineView.backgroundColor = hexColor(E5E5E5);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
