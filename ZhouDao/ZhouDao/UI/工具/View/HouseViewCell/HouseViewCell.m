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
@property (assign, nonatomic) NSInteger section;

@end

@implementation HouseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.segButton];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.manualLabel];
        [self.contentView addSubview:self.symbolLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return self;
}
#pragma mark - method
- (void)settingHouseCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        _segButton.hidden = YES;
        _textField.hidden = NO;
        _textField.text = arr1[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.borderStyle = UITextBorderStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;

       if ([arr1[0] isEqualToString:@"组合贷款"]){
           NSArray *titleArr = @[@"贷款类型",@"期限 (年)",@"公积金贷款金额(万元)",@"年利率",@"商业贷款金额(万元)",@"年利率",@""];
           _titleLab.text = titleArr[row];
           switch (row) {
               case 0:
               {
                   _textField.placeholder = @"请选择贷款类型";
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                   self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               }
                   break;
               case 1:
               {
                   _textField.enabled = YES;
                   _textField.placeholder = @"请输入金额";
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 160, 30);
                   _textField.keyboardType = UIKeyboardTypeDecimalPad;
               }
                   break;
               case 2:
               {
                   _textField.placeholder = @"请选择贷款期限";
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                   self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               }
                   break;
               case 3:
               {
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
               }
                   break;
               case 4:
               {
                   _textField.enabled = YES;
                   _textField.placeholder = @"请输入金额";
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 160, 30);
                   _textField.keyboardType = UIKeyboardTypeDecimalPad;

               }
                   break;
               case 5:
               {
                   _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
               }
                   break;
               case 6:
               {
                   _textField.enabled = YES;
                   _lineView.hidden= YES;
                   _manualLabel.hidden = NO;
                   _symbolLabel.hidden = NO;
                   _textField.frame = CGRectMake(Orgin_x(_manualLabel) + 2 , 10, 64, 25);
                   _textField.borderStyle = UITextBorderStyleRoundedRect;
                   _textField.keyboardType = UIKeyboardTypeDecimalPad;
               }
                   break;
               default:
                   break;
           }

        }else{
            
            NSArray *titleArr = @[@"贷款类型",@"贷款金额(万元)",@"期限 (年)",@"年利率",@""];
            _titleLab.text = titleArr[row];

            switch (row) {
                case 0:
                {
                    _textField.placeholder = @"请选择贷款类型";
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 1:
                {
                    _textField.enabled = YES;
                    _textField.placeholder = @"请输入金额";
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 2:
                {
                    _textField.placeholder = @"请选择贷款期限";
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                }
                    break;
                case 3:
                {
                    _lineView.hidden = ([arr1[0] isEqualToString:@"商业贷款"])?NO:YES;
                    _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 140, 30);
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                    break;
                case 4:
                {
                    _textField.enabled = YES;
                    _lineView.hidden= YES;
                    _manualLabel.hidden = NO;
                    _symbolLabel.hidden = NO;
                    _textField.frame = CGRectMake(Orgin_x(_manualLabel) + 2 , 10, 64, 25);
                    _textField.borderStyle = UITextBorderStyleRoundedRect;
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                    self.accessoryType = UITableViewCellAccessoryNone;

                }
                    break;
                default:
                    break;
            }

        }
    }else if(section == 1){
        
        NSMutableArray *arr2 = arrays[1];

        NSArray *smallArr ;
        NSArray *titleArr;
        if (_isBJ == NO) {
            
            smallArr = arr2[0];
            titleArr = @[@"计算结果",@"月供（元）",@"还款月数（月）",@"支付利息（万元）",@"还款总额（万元）"];
        }else {

            smallArr = arr2[1];
            titleArr = @[@"计算结果",@"还款月数（月）",@"支付利息（万元）",@"还款总额（万元）"];
        }
        
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
       
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        _segButton.hidden = YES;
        _symbolLabel.hidden = YES;
        _manualLabel.hidden = YES;
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.frame = CGRectMake(kMainScreenWidth - 175, 7, 160, 30);

        _titleLab.text = titleArr[row];
        _textField.text = smallArr[row];

        switch (row) {
            case 0:
            {
                _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
                _segButton.hidden = NO;
                _segButton.frame = CGRectMake((kMainScreenWidth - 180)/2.f, Orgin_y(_titleLab) + 10, 180, 25);
                _titleLab.textAlignment = NSTextAlignmentCenter;
                _textField.hidden = YES;
                _lineView.hidden = YES;
                _segButton.selectedSegmentIndex = (_isBJ == NO)?0:1;
                
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

                _lineView.hidden = (_isBJ == NO)?NO:YES;
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
    if ([self.delegate respondsToSelector:@selector(optionEvent:withCell:)]) {
        [self.delegate optionEvent:Seg.selectedSegmentIndex withCell:self];
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
        _manualLabel.text = @"浮动比例";
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
- (UISegmentedControl *)segButton
{
    if (!_segButton) {
        _segButton = [[UISegmentedControl alloc]initWithItems:@[@"等额本息",@"等额本金"]];
        _segButton.frame = CGRectMake(kMainScreenWidth - 102, 9, 87, 27);
        _segButton.selectedSegmentIndex = 0;
        _segButton.tintColor = hexColor(00c8aa);
        _segButton.tag = 4006;
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
