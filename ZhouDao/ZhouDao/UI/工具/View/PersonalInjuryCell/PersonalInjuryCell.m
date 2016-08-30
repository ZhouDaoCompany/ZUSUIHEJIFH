//
//  PersonalInjuryCell.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PersonalInjuryCell.h"

@interface PersonalInjuryCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UISegmentedControl *segButton;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation PersonalInjuryCell

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
- (void)settingPersonalCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    NSArray *titleArr = @[@"选择地区",@"选择户口",@"伤残项",@"伤残等级"];
    _titleLab.frame = CGRectMake(15, 12, 160, 20);
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.text = titleArr[row];
    _textField.placeholder = @"";
    _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
    _lineView.hidden = NO;
    _textField.text = arrays[row];
    _textField.enabled = NO;
    _textField.hidden = NO;
    _segButton.hidden = YES;
    self.accessoryType = UITableViewCellAccessoryNone;

    switch (row) {
        case 0:
        {
            _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            _textField.hidden = YES;
            _segButton.hidden = NO;
            
            
        }
            break;
        case 2:
        {
            _textField.hidden = YES;
            _segButton.hidden = NO;
            [_segButton removeAllSegments];
            [_segButton insertSegmentWithTitle:@"一级" atIndex:0 animated:NO];
            [_segButton insertSegmentWithTitle:@"多级" atIndex:1 animated:NO];
            _segButton.selectedSegmentIndex = 0;

        }
            break;
        case 3:
        {
            _textField.placeholder = @"请输入金额";
            _lineView.hidden = YES;
            _textField.enabled = YES;
            
            
        }
            break;
            
        default:
            break;
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
- (UITextField *)textField
{
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
- (UISegmentedControl *)segButton
{
    if (!_segButton) {
        _segButton = [[UISegmentedControl alloc]initWithItems:@[@"城镇",@"农村"]];
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
