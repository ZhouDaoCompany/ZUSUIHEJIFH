//
//  OverdueCell.m
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "OverdueCell.h"

@interface OverdueCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;

@end
@implementation OverdueCell

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
#pragma mark -
#pragma mark - methods
- (void)settingOverdueCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"标的金额（元）",@"还款方式",@"违约金利率（%/日）",@"起算日",@"截止日"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        switch (row) {
            case 0:
            {
                _textField.hidden = NO;
                _textField.enabled = YES;
                _textField.placeholder = @"请输入金额";
                _textField.frame = CGRectMake(kMainScreenWidth - 135, 7, 120, 30);
                _textField.keyboardType = UIKeyboardTypeDecimalPad;
                self.accessoryType = UITableViewCellAccessoryNone;
                _textField.text = arr1[0];

                
            }
                break;
            case 1:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _textField.text = arr1[1];
                _textField.placeholder = @"请选择还款方式";

                
            }
                break;
            case 2:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _textField.text = arr1[2];
                _textField.placeholder = @"请选择利率";

            }
                break;
            case 3:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _textField.text = arr1[3];
                _textField.placeholder = @"请选择起算日";

                
            }
                break;
            case 4:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _textField.text = arr1[4];
                _lineView.hidden = YES;
                _textField.placeholder = @"请选择截止日";

                
            }
                break;

            default:
                break;
        }
    }else {
        NSMutableArray *arr2 = arrays[1];
        
        NSArray *titleArr = @[@"计算结果",@"还款总额（元）",@"利息（元）",@"本金（元）"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _textField.text = arr2[row];
        _lineView.hidden = NO;

        switch (row) {
            case 0:
            {
                _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
                _titleLab.textAlignment = NSTextAlignmentCenter;
                _textField.hidden = YES;
                _lineView.frame = CGRectMake(0, 44.4f, kMainScreenWidth, .6f);
                _lineView.hidden = NO;
                
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
            case 3:
            {
                _lineView.hidden = YES;
                
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
