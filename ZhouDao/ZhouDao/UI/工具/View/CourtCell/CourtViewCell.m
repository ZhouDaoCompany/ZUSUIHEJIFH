//
//  CourtViewCell.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CourtViewCell.h"

@interface CourtViewCell()

@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UISegmentedControl *segButton;
@property (strong, nonatomic) UISegmentedControl *segButtonTwo;
@property (assign, nonatomic) NSInteger row;
@end

@implementation CourtViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.segButton];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.segButtonTwo];
    }
    return self;
}
#pragma mark -  methods
- (void)settingUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays
{
    _textField.section = section;
    _textField.row = row;
    _row = row;
    if (section == 0) {
        
        NSMutableArray *arr1 = arrays[0];
        NSArray *titleArr = @[@"案件类型",@"是否涉及财产关系",@"诉讼标的（元）",@"计算方式"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _lineView.frame = CGRectMake(15, 44.4f, kMainScreenWidth - 15, .6f);
        _lineView.hidden = NO;
        _textField.text = arr1[row];
        self.accessoryType = UITableViewCellAccessoryNone;
        _segButtonTwo.hidden = YES;
        _segButton.hidden = YES;

        if ([arr1[0] isEqualToString:@"财产案件"] || [arr1[0] isEqualToString:@"支付令"]) {
            
            switch (row) {
                case 0:
                {
                    _textField.enabled = NO;
                    _textField.hidden = NO;
                    _textField.placeholder = @"选择案件类型";
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 235, 7, 200, 30);
                    
                }
                    break;
                case 1:
                {
                    _textField.hidden = NO;
                    _textField.enabled = YES;
                    _titleLab.text = @"诉讼标的（元）";
                    _textField.placeholder = @"请输入金额";
                    _textField.keyboardType = UIKeyboardTypeDecimalPad;
                }
                    break;
                case 2:
                {
                    _textField.hidden = YES;
                    _segButtonTwo.hidden = NO;
                    _lineView.hidden = YES;
                    _segButtonTwo.selectedSegmentIndex = [arr1[2] isEqualToString:@"全额"]?0:1;
                    _titleLab.text = [titleArr lastObject];

                }
                    break;
                default:
                    break;
            }

        }else if ([arr1[0] isEqualToString:@"离婚案件"] || [arr1[0] isEqualToString:@"人格权案件"] || [arr1[0] isEqualToString:@"知识产权案件"] || [arr1[0] isEqualToString:@"财产保全案件"] || [arr1[0] isEqualToString:@""]){
            
            if (arr1.count == 3) {
                
                switch (row) {
                    case 0:
                    {
                        _textField.enabled = NO;
                        _textField.hidden = NO;
                        _textField.placeholder = @"选择案件类型";
                        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        _textField.frame = CGRectMake(kMainScreenWidth - 235, 7, 200, 30);
                        
                    }
                        break;
                    case 1:
                    {
                        _textField.enabled = NO;
                        _textField.hidden = YES;
                        _textField.frame = CGRectMake(kMainScreenWidth - 155, 7, 120, 30);
                        _segButton.hidden = NO;
                        _segButton.selectedSegmentIndex = [arr1[1] isEqualToString:@"是"]?0:1;

                        
                    }
                        break;
                    case 2:
                    {
                        _textField.hidden = YES;
                        _segButtonTwo.hidden = NO;
                        _lineView.hidden = YES;
                        _segButtonTwo.selectedSegmentIndex = [arr1[2] isEqualToString:@"全额"]?0:1;
                        _titleLab.text = [titleArr lastObject];

                    }
                        break;
                    default:
                        break;
                }

                
            }else {
                
                switch (row) {
                    case 0:
                    {
                        _textField.enabled = NO;
                        _textField.hidden = NO;
                        _textField.placeholder = @"选择案件类型";
                        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        _textField.frame = CGRectMake(kMainScreenWidth - 235, 7, 200, 30);
                        
                    }
                        break;
                    case 1:
                    {
                        _textField.enabled = NO;
                        _textField.hidden = YES;
                        _segButton.hidden = NO;
                        _segButton.selectedSegmentIndex = [arr1[1] isEqualToString:@"是"]?0:1;

                        
                    }
                        break;
                    case 2:
                    {
                        _textField.hidden = NO;
                        _textField.enabled = YES;
                        _textField.placeholder = @"请输入金额";
                        _textField.keyboardType = UIKeyboardTypeDecimalPad;
                        _titleLab.text = @"诉讼标的（元）";
                        
                    }
                        break;
                    case 3:
                    {
                        _textField.hidden = YES;
                        _segButtonTwo.hidden = NO;
                        _lineView.hidden = YES;
                        _segButtonTwo.selectedSegmentIndex = [arr1[3] isEqualToString:@"全额"]?0:1;
                        _titleLab.text = [titleArr lastObject];

                    }
                        break;
                        
                    default:
                        break;
                }

            }
        }else {
            
            switch (row) {
                case 0:
                {
                    _textField.enabled = NO;
                    _textField.hidden = NO;
                    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _textField.frame = CGRectMake(kMainScreenWidth - 235, 7, 200, 30);
                    
                }
                    break;
                case 1:
                {
                    _textField.hidden = YES;
                    _segButtonTwo.hidden = NO;
                    _lineView.hidden = YES;
                    _segButtonTwo.selectedSegmentIndex = [arr1[1] isEqualToString:@"全额"]?0:1;
                    _titleLab.text = [titleArr lastObject];

                    
                }
                    break;
                default:
                    break;
            }

        }

    }else {
        NSMutableArray *arr2 = arrays[1];
        NSArray *titleArr = @[@"计算结果",@"受理费",@"执行费"];
        _titleLab.frame = CGRectMake(15, 12, 160, 20);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = titleArr[row];
        _textField.placeholder = @"";
        _textField.enabled = NO;
        _textField.hidden = NO;
        _segButton.hidden = YES;
        _segButtonTwo.hidden = YES;
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
                
                _lineView.hidden = NO;
                _textField.textAlignment = NSTextAlignmentRight;
                _textField.frame = CGRectMake(kMainScreenWidth - 215, 7, 200, 30);

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
    if (Seg.tag == 4004) {
        if ([self.delegate respondsToSelector:@selector(fullORHalf:withCell:)]) {
            [self.delegate fullORHalf:Seg.selectedSegmentIndex withCell:self];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(isInvolvedInTheAmount:withCell:)]) {
            [self.delegate isInvolvedInTheAmount:Seg.selectedSegmentIndex withCell:self];
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
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 165, 7, 150, 30)];
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
        _segButton.tag = 4005;

        [_segButton addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segButton;
}
- (UISegmentedControl *)segButtonTwo
{
    if (!_segButtonTwo) {
        _segButtonTwo = [[UISegmentedControl alloc]initWithItems:@[@"全额",@"减半"]];
        _segButtonTwo.frame = CGRectMake(kMainScreenWidth - 102, 9, 87, 27);
        _segButtonTwo.selectedSegmentIndex = 0;
        _segButtonTwo.tintColor = hexColor(00c8aa);
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
        [_segButtonTwo setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                   NSForegroundColorAttributeName: hexColor(666666)};
        [_segButtonTwo setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        _segButtonTwo.tag = 4004;
        [_segButtonTwo addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segButtonTwo;
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
