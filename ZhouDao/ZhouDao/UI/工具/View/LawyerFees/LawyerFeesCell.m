//
//  LawyerFeesCell.m
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawyerFeesCell.h"

@interface LawyerFeesCell()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UISegmentedControl *segButton;
@end
@implementation LawyerFeesCell

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
    }
    
    return self;
}
#pragma mark - method
- (void)settingUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"所在地区",@"案件类型",@"是否涉及财产关系",@"诉讼标的（元）"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.text = arr1[row];

        switch (row) {
            case 0:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _segButton.hidden = YES;
                _textField.placeholder = @"请选择地区";
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);

            }
                break;
            case 1:
            {
                _textField.enabled = NO;
                _textField.hidden = NO;
                _segButton.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
                _textField.placeholder = @"请选择案件类型";
                
            }
                break;
            case 2:
            {
                _textField.hidden = YES;
                _segButton.hidden = NO;
                self.accessoryType = UITableViewCellAccessoryNone;
                ([arr1[2] isEqualToString:@"是"])?[_segButton setSelectedSegmentIndex:0]:[_segButton setSelectedSegmentIndex:1];
                
            }
                break;
            case 3:
            {
                _textField.hidden = NO;
                _textField.enabled = YES;
                _segButton.hidden = YES;
                _textField.text = arr1[row];
                _textField.placeholder = @"请输入金额";
                _textField.keyboardType = UIKeyboardTypeDecimalPad;
                self.accessoryType = UITableViewCellAccessoryNone;
                _lineView.hidden = YES;

            }
                break;

            default:
                break;
        }
    }else {
        NSMutableArray *arr2 = arrays[1];
        NSArray *titleArr;
        if (arr2.count > 2) {
            titleArr = @[@"计算结果",@"侦查阶段",@"审查起诉阶段",@"审判阶段"];
        }else {
            titleArr = @[@"计算结果",@"律师费"];
        }
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        _segButton.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        _textField.text = arr2[row];
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _textField.frame = CGRectMake(kMainScreenWidth - 215, 7, 200, 30);
        
        if (row == 0) {
            _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
            _titleLab.textAlignment = NSTextAlignmentCenter;
            _textField.hidden = YES;
            _lineView.frame = CGRectMake(0, 44.4f, kMainScreenWidth, .6f);
        }else if (row == arr2.count -1){
            
            _lineView.hidden = YES;

        }
        
    }
}
#pragma mark - seg
- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    if ([self.delegate respondsToSelector:@selector(aboutProperty:)]) {
        [self.delegate aboutProperty:Seg.selectedSegmentIndex];
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
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 215, 7, 200, 30)];
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
        _segButton = [[UISegmentedControl alloc]initWithItems:@[@"是",@"否"]];
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
