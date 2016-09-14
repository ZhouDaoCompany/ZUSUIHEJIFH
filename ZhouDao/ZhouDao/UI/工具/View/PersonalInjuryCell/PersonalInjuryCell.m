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
- (void)settingPersonalCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays withDelegate:(id<PersonalInjuryDelegate>)delegate
{
    self.delegate = delegate;
    if (section == 0) {
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"选择地区",@"选择户口",@"是否伤亡",@"伤残项",@"伤残等级"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.enabled = NO;
        _textField.hidden = NO;
        _segButton.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        switch (row) {
            case 0:
            {
                _textField.placeholder = @"请选择地区";
                _textField.text = arr1[row];
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                _textField.hidden = YES;
                _segButton.hidden = NO;
                _segButton.selectedSegmentIndex = [arr1[row] integerValue];

            }
                break;
            case 2:
            {
                _textField.hidden = YES;
                _segButton.hidden = NO;
                [_segButton removeAllSegments];
                [_segButton insertSegmentWithTitle:@"否" atIndex:0 animated:NO];
                [_segButton insertSegmentWithTitle:@"是" atIndex:1 animated:NO];
                _segButton.selectedSegmentIndex = [arr1[row] integerValue];
                
            }
                break;
            case 3:
            {
                _textField.hidden = YES;
                _segButton.hidden = NO;
                [_segButton removeAllSegments];
                [_segButton insertSegmentWithTitle:@"单级" atIndex:0 animated:NO];
                [_segButton insertSegmentWithTitle:@"多级" atIndex:1 animated:NO];
                _segButton.selectedSegmentIndex = [arr1[row] integerValue];
                
                
            }
                break;
            case 4:
            {
                _lineView.hidden = YES;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                UILabel *lab = (UILabel *)[self.contentView viewWithTag:9000];
                [lab removeFromSuperview];

                if ([arr1[3] integerValue] == 0) {
                    
                    _textField.hidden = NO;
                    _textField.placeholder = @"选择伤残等级";
                    _textField.text = arr1[row];

                }else{
                    NSArray *levelArr = arr1[4];
                    if (levelArr.count == 0) {
                        
                        _textField.hidden = NO;
                        _textField.text = @"";
                        _textField.placeholder = @"选择伤残等级";

                    }else {
                        
                        _textField.hidden = YES;
                        
                        NSDictionary *dict = levelArr[0];
                        UILabel *lab = [[UILabel alloc] init];
                        lab.frame = CGRectMake(kMainScreenWidth - 175, 7, 130, 30);
                        lab.font = Font_14;
                        lab.backgroundColor = [UIColor clearColor];
                        lab.textColor = hexColor(333333);
                        lab.textAlignment = NSTextAlignmentRight;
                        if (levelArr.count >1) {
                            
                            lab.text = [NSString stringWithFormat:@"%@:%@处···",dict[@"level"],dict[@"several"]];
                        }else {
                            
                            lab.text = [NSString stringWithFormat:@"%@  %@处",dict[@"level"],dict[@"several"]];
                        }
                        lab.tag = 9000;
                        [self.contentView addSubview:lab];
                    }
                    
                    
                }
                
            }
                break;
 
            default:
                break;
        }
    }else{
        
        
        
        
    }
}
#pragma mark - seg
- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg
{
    if ([self.delegate respondsToSelector:@selector(optionEventWithCell:withSelecIndex:)])
    {
        [self.delegate optionEventWithCell:self withSelecIndex:Seg.selectedSegmentIndex];
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
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 215, 7, 180, 30)];
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
        _segButton.frame = CGRectMake(kMainScreenWidth - 122, 9, 107, 27);
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
