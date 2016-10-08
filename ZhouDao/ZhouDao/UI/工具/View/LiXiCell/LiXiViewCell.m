//
//  LiXiViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LiXiViewCell.h"

@interface LiXiViewCell()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *manualLabel;
@property (strong, nonatomic) UILabel *symbolLabel;

@end

@implementation LiXiViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.manualLabel];
        [self.contentView addSubview:self.symbolLabel];
    }
    
    return self;
}
#pragma mark - method
- (void)settingLiXiCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];

        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.text = arr1[row];
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        _textField.hidden = NO;
        _textField.borderStyle = UITextBorderStyleNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([arr1[4] isEqualToString:@"按约定利率"]) {
            
            NSArray *titleArr = @[@"本金总额（元）",@"贷款期限",@"贷款期限",@"还款方式",@"利率方式",@"利率选项",@""];
            _titleLab.text = titleArr[row];

            switch (row) {
                case 0:
                {
                    _textField.enabled = YES;
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    _textField.placeholder = @"请输入金额";
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 160, 30);
                    self.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                case 1:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择起算日";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);

                    
                }
                    break;
                case 2:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择截止日";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);

                }
                    break;
                case 3:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择还款方式";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);

                }
                    break;
                    
                case 4:
                {
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择利率方式";
                    
                }
                    break;
                case 5:
                {
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择利率选项";

                }
                    break;
                case 6:
                {
                    _manualLabel.hidden = NO;
                    _symbolLabel.hidden = NO;
                    _lineView.hidden = YES;
                    _textField.frame = CGRectMake(Orgin_x(_manualLabel) + 2 , 10, 64, 25);
                    _textField.borderStyle = UITextBorderStyleRoundedRect;
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    
                    
                }
                    break;
                default:
                    break;
            }

            
        }else{
            
            NSArray *titleArr = @[@"本金总额（元）",@"贷款期限",@"贷款期限",@"还款方式",@"利率方式",@""];
            _titleLab.text = titleArr[row];

            switch (row) {
                case 0:
                {
                    _textField.enabled = YES;
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    _textField.placeholder = @"请输入金额";
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 160, 30);
                    self.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                case 1:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择起算日";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    
                    
                }
                    break;
                case 2:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择截止日";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    
                }
                    break;
                case 3:
                {
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择还款方式";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    
                }
                    break;
                case 4:
                {
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    _textField.enabled = NO;
                    _textField.placeholder = @"请选择利率方式";
                    
                }
                    break;
  
                case 5:
                {
                    _manualLabel.hidden = NO;
                    _symbolLabel.hidden = NO;
                    _lineView.hidden = YES;
                    _manualLabel.text = @"银行折扣";
                    _textField.frame = CGRectMake(Orgin_x(_manualLabel) + 2 , 10, 64, 25);
                    _textField.borderStyle = UITextBorderStyleRoundedRect;
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    _textField.placeholder = @"100";
                }
                    break;
                default:
                    break;
            }
 
            
            
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
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        _textField.text = arr2[row];
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _textField.borderStyle = UITextBorderStyleNone;

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
                _textField.frame = CGRectMake(kMainScreenWidth - 215, 7, 200, 30);

                
            }
                break;
            case 2:
            {
                _textField.frame = CGRectMake(kMainScreenWidth - 215, 7, 200, 30);

            }
                break;
            case 3:
            {
                _textField.frame = CGRectMake(kMainScreenWidth - 215, 7, 200, 30);
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
- (UILabel *)manualLabel
{
    if (!_manualLabel) {
        _manualLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 210, 12, 115, 20)];
        _manualLabel.text = @"手动输入";
        _manualLabel.font = Font_14;
        _manualLabel.textAlignment = NSTextAlignmentRight;
        _manualLabel.backgroundColor = [UIColor clearColor];
        _manualLabel.textColor = hexColor(ADADAD);
    }
    return _manualLabel;
}
- (UILabel *)symbolLabel
{
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth - 26, 12, 13, 20)];
        _symbolLabel.text = @"%";
        _symbolLabel.font = Font_14;
        _symbolLabel.backgroundColor = [UIColor clearColor];
        _symbolLabel.textColor = hexColor(666666);
    }
    return _symbolLabel;
}

- (CaseTextField *)textField
{
    if (!_textField) {
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 135, 7, 120, 30)];
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
