//
//  DivorceViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DivorceViewCell.h"

@interface DivorceViewCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@end

@implementation DivorceViewCell

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
        NSArray *titleArr = @[@"购买时诉争房产价格（元）",@"结婚时诉争房产价格（元）",@"离婚时诉争房产价格（元）",@"共同已还利息（元）",@"契税等其他费用（元）",@"共同还贷部分（元）"];
        _titleLab.frame = CGRectMake(15, 12, 180, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryNone;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.placeholder = @"请输入金额";
        _textField.frame = CGRectMake(kMainScreenWidth - 135, 7, 120, 30);
        _textField.text = arr1[row];
        
        switch (row) {
            case 0:
            {
                
                
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
                
                
            }
                break;
            case 4:
            {
                
                
            }
                break;

            case 5:
            {
                _lineView.hidden = YES;
                
                
            }
                break;
                
            default:
                break;
        }
    }else {

        NSMutableArray *arr2 = arrays[1];
        NSArray *titleArr = @[@"计算结果",@"诉争房产的升值率（%）",@"婚后增值金额"];
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
