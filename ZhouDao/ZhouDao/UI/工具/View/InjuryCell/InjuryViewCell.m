//
//  InjuryViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "InjuryViewCell.h"

@interface InjuryViewCell()

@property (strong, nonatomic) UIView *lineView;

@end

@implementation InjuryViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.textField];
        
    }
    
    return self;
}

#pragma mark - method

- (void)settingUIDetailWithDictionary:(NSDictionary *)dictionary
{
    _titleLab.frame = CGRectMake(15, 12, 160, 20);
    _textField.enabled = NO;
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _lineView.hidden = NO;
    _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
    _titleLab.text = dictionary[@"title"];
    float showMoney = [dictionary[@"money"] floatValue];
    _textField.text = CancelPoint2(showMoney);
}
- (void)settingInjuryViewCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    NSArray *titleArr = @[@"选择地区",@"伤残等级",@"工资（元/月)"];
    _titleLab.frame = CGRectMake(15, 12, 160, 20);
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = titleArr[row];
    _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
    _lineView.hidden = NO;
    _textField.hidden = NO;
    _textField.text = arrays[row];
    _textField.placeholder = @"";
    _textField.enabled = NO;
    
    switch (row) {
        case 0:
        {
            _textField.placeholder = @"请选择地区";
            _textField.frame = CGRectMake(kMainScreenWidth - 195, 7, 160, 30);
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
            break;
        case 1:
        {
            _textField.placeholder = @"请选择";
            _textField.frame = CGRectMake(kMainScreenWidth - 195, 7, 160, 30);
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
            break;
        case 2:
        {
            _textField.enabled = YES;
            _lineView.hidden = YES;
            _textField.placeholder = @"请输入金额";
            _textField.keyboardType = UIKeyboardTypeDecimalPad;
            self.accessoryType = UITableViewCellAccessoryNone;
            
        }
            break;
        default:
            break;
    }


}
#pragma mark - setter and getter
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = Font_15;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textColor = hexColor(000000);
    }
    return _titleLab;
}

- (CaseTextField *)textField
{
    if (!_textField) {
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 175, 7, 160, 30)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = hexColor(666666);
        [_textField setValue:hexColor(ADADAD) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.font = Font_14;
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = hexColor(E5E5E5);
    }
    return _lineView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
