//
//  HouseViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HouseViewCell.h"

@interface HouseViewCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UISegmentedControl *segButton;
@property (strong, nonatomic) UILabel *manualLabel;
@property (strong, nonatomic) UILabel *symbolLabel;

@end

@implementation HouseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.segButton];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.manualLabel];
        [self.contentView addSubview:self.symbolLabel];
        
    }
    
    return self;
}
#pragma mark - method
- (void)settingHouseCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"贷款类型",@"计算方式",@"贷款金额（万元）",@"期限（年）",@"年利率（%）",@""];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _segButton.hidden = YES;
        _textField.hidden = NO;
        _textField.text = arr1[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;

        switch (row) {
            case 0:
            {
                _textField.placeholder = @"请选择贷款类型";
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);

                
            }
                break;
            case 1:
            {
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);

                
            }
                break;
            case 2:
            {
                _textField.enabled = YES;
                _textField.placeholder = @"请输入金额";
                self.accessoryType = UITableViewCellAccessoryNone;
                
            }
                break;
            case 3:
            {
                _textField.enabled = NO;
                _textField.placeholder = @"请选择期限";
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
                
            }
                break;
                
            case 4:
            {
                _textField.enabled = NO;
                _textField.placeholder = @"请选择利率";
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
                
                
            }
                break;
            case 5:
            {
                _manualLabel.hidden = NO;
                _symbolLabel.hidden = NO;
                _lineView.hidden = YES;
                _textField.frame = CGRectMake(Orgin_x(_manualLabel) + 2 , 10, 64, 25);
                _textField.borderStyle = UITextBorderStyleRoundedRect;
                _textField.keyboardType = UIKeyboardTypeDecimalPad;
                self.accessoryType = UITableViewCellAccessoryNone;

                
            }
                break;
            default:
                break;
        }
    }else {
        NSMutableArray *arr2 = arrays[1];
        
        NSArray *titleArr = @[@"计算结果",@"月供（元）",@"还款月数（月）",@"支持利息（元）",@"还款总额（元）"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        _segButton.hidden = YES;
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        _textField.text = arr2[row];
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        
        switch (row) {
            case 0:
            {
                _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
                _segButton.hidden = NO;
                _segButton.frame = CGRectMake((kMainScreenWidth - 180)/2.f, Orgin_y(_titleLab) + 10, 180, 25);
                _titleLab.textAlignment = NSTextAlignmentCenter;
                _textField.hidden = YES;
                _lineView.hidden = YES;
                
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
                _lineView.hidden = YES;
                
            }
                break;
                
            default:
                break;
        }
        
        
    }

}
#pragma mark - seg
- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    
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
        _manualLabel.text = @"您也可以手动输入";
        _manualLabel.font = Font_14;
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
- (UISegmentedControl *)segButton
{
    if (!_segButton) {
        _segButton = [[UISegmentedControl alloc]initWithItems:@[@"等额本息",@"等额本金"]];
        _segButton.frame = CGRectMake(kMainScreenWidth - 102, 9, 87, 27);
        _segButton.selectedSegmentIndex = 0;
        _segButton.tintColor = hexColor(00c8aa);
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_segButton setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                   NSForegroundColorAttributeName: hexColor(666666)};
        [_segButton setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [_segButton addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segButton;
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
