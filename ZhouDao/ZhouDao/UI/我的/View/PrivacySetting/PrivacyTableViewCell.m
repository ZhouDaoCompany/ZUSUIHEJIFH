//
//  PrivacyTableViewCell.m
//  GovermentTest
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PrivacyTableViewCell.h"

@interface PrivacyTableViewCell()

@end

@implementation PrivacyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.textLabel.font = Font_12;
    self.textLabel.textColor = hexColor(333333);

}

- (void)setIndexRow:(NSUInteger)indexRow {
    
    _indexRow = indexRow;
    
    if (indexRow == 0) {
        
        _selectImgView.hidden = YES;
        _titleLabel.hidden = YES;
        _msgLabel.hidden = YES;
        self.textLabel.text = @"该页面设置您在法院信息共建过程中的隐私保护，具体设置如下:";
        
    } else {
        
        _selectImgView.hidden = NO;
        _titleLabel.hidden = NO;
        _msgLabel.hidden = NO;
        self.textLabel.text = @"";
        
        NSDictionary *dictionary = _msgArrays[indexRow];
        _titleLabel.text = dictionary[@"title"];
        _msgLabel.text = dictionary[@"message"];

    }
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    if (_isSelected) {
        
        _selectImgView.image = kGetImage(@"PrivacySelected");
    } else {
        _selectImgView.image = kGetImage(@"PrivacyUnSelected");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
