//
//  EconomicViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "EconomicViewCell.h"

@interface EconomicViewCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation EconomicViewCell

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

- (void)settingEconomicCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"工作开始日期",@"工作结束日期",@"平均工资（元/月）",@"工作城市"];
        _titleLab.frame = CGRectMake(15, 12, 180, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.placeholder = @"请输入金额";
        _textField.text = arr1[row];
        _textField.enabled = NO;
        
        switch (row) {
            case 0:
            {
                _textField.placeholder = @"请选择起算日期";
                _textField.frame = CGRectMake(kMainScreenWidth - 135, 7, 120, 30);
                self.accessoryType = UITableViewCellAccessoryNone;

            }
                break;
            case 1:
            {
                _textField.placeholder = @"请选择结束日期";
                _textField.frame = CGRectMake(kMainScreenWidth - 135, 7, 120, 30);
                self.accessoryType = UITableViewCellAccessoryNone;

            }
                break;
            case 2:
            {
                _textField.enabled = YES;
                _textField.placeholder = @"请输入离职前12个月平均薪资";
                _textField.frame = CGRectMake(kMainScreenWidth - 200, 7, 185, 30);
                self.accessoryType = UITableViewCellAccessoryNone;

            }
                break;
            case 3:
            {
                _textField.frame =  CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
                _lineView.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
                break;
            default:
                break;
        }
    }else {
        
        NSMutableArray *arr2 = arrays[1];
        NSArray *titleArr = @[@"计算结果",@"经济补偿金（元）",@"补偿月数（月）"];
        _titleLab.frame = CGRectMake(15, 12, 180, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
        _textField.text = arr2[row];
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        
        switch (row) {
            case 0:
            {
                _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
                _titleLab.textAlignment = NSTextAlignmentCenter;
                _textField.hidden = YES;
                _lineView.frame = CGRectMake(0, 44.4f, kMainScreenWidth, .6f);
                
            }
                break;
            case 1:
            {
                
                
            }
                break;
            case 2:
            {
                
            }
                break;
            default:
                break;
        }
        
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
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 155, 7, 120, 30)];
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
