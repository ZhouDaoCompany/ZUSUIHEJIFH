//
//  TingShiTabViewCell.m
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiTabViewCell.h"

@interface TingShiTabViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TingShiTabViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

#pragma mark - methods

- (void)settingUI {
    
    
}

//编辑
- (void)settingUIWithMutableArrays:(NSMutableArray *)arrays
                       withSection:(NSUInteger)section
                      withIndexRow:(NSUInteger)row
                       withEnadled:(BOOL)isEnabled {
    
    NSMutableArray *oneArrays = arrays[section];

    _textField.text = oneArrays[row];
    _textField.section = section;
    _textField.row = row;
    _textField.enabled = isEnabled;

    if (section == 0) {
        
        NSArray *titArr = @[@"庭室名",@"庭室地址"];
        self.accessoryType = UITableViewCellAccessoryNone;
        _titleLabel.text = titArr[row];
        _textField.placeholder = [NSString stringWithFormat:@"请输入%@",titArr[row]];

    } else {
        NSArray *arr = @[@"联系人类别",@"联系人信息",@"联系方式"];
        
        _titleLabel.text = arr[row];
        if (row == 0) {
            _textField.enabled = NO;
            _textField.placeholder = @"选择联系人类别";
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
            _textField.placeholder = [NSString stringWithFormat:@"请输入%@",arr[row]];
        }
    }
    
}

#pragma mark - setter and getter
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 160, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_titleLabel setTextColor:hexColor(333333)];
    }
    return _titleLabel;
}

- (CaseTextField *)textField {
    
    if (!_textField) {
        
        _textField = [[CaseTextField alloc] initWithFrame:CGRectMake(kMainScreenWidth - 175, 7, 145, 30)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.textColor = hexColor(333333);
        [_textField setValue:hexColor(ADADAD) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.font = Font_14;
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
