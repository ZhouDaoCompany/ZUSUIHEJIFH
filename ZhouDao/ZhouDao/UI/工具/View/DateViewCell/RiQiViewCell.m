//
//  RiQiViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RiQiViewCell.h"

@interface RiQiViewCell()

@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UISegmentedControl *segButton;

@end

@implementation RiQiViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.segButton];

    }
    
    return self;
}
#pragma mark -
#pragma mark - methods

- (void)settingRiQiCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"选择日期",@"间隔天数（天）",@"推算方式",@"是否仅计算工作日"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.text = arr1[row];
        _textField.enabled = NO;
        _segButton.hidden = YES;
        _textField.textAlignment = NSTextAlignmentRight;

        switch (row) {
            case 0:
            {

                _textField.hidden = NO;
                _segButton.hidden = YES;
                _textField.placeholder = @"请选择开始日期";
                
            }
                break;
            case 1:
            {
                _textField.hidden = NO;
                _textField.enabled = YES;
                _textField.placeholder = @"请输入间隔天数";
                _textField.keyboardType = UIKeyboardTypeDecimalPad;
                
                
            }
                break;
            case 2:
            {
                _textField.hidden = YES;
                _segButton.hidden = NO;
                [_segButton removeAllSegments];
                [_segButton insertSegmentWithTitle:@"向前推算" atIndex:0 animated:NO];
                [_segButton insertSegmentWithTitle:@"向后推算" atIndex:0 animated:NO];
                _segButton.selectedSegmentIndex = 0;
            }
                break;
            case 3:
            {
               
                _segButton.hidden = NO;
                _lineView.hidden = YES;
                
                
            }
                break;
                
            default:
                break;
        }
    }else {
        NSMutableArray *arr2 = arrays[1];
        
        NSArray *titleArr = @[@"计算结果",@""];
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
        _textField.textAlignment = NSTextAlignmentRight;

        switch (row) {
            case 0:
            {
                _titleLab.hidden = NO;
                _titleLab.frame = CGRectMake(15, 12, kMainScreenWidth - 30, 20);
                _titleLab.textAlignment = NSTextAlignmentCenter;
                _textField.hidden = YES;
                _lineView.frame = CGRectMake(0, 44.4f, kMainScreenWidth, .6f);
                
            }
                break;
            case 1:
            {
                _lineView.hidden = YES;
                _titleLab.hidden = YES;
                _textField.frame = CGRectMake(0, 6, kMainScreenWidth, 30);
                _textField.text = @"2016年3月10日（周二，工作日）";
                _textField.textAlignment = NSTextAlignmentCenter;
                
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
