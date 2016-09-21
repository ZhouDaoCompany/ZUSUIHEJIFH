//
//  PaymentTabViewCell.m
//  ZhouDao
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PaymentTabViewCell.h"

#define LABELWIDTH           [UIScreen mainScreen].bounds.size.width/4.f
@interface PaymentTabViewCell()

@property (strong, nonatomic) UILabel *monthLabel;//月份
@property (strong, nonatomic) UILabel *principalLabel;//月供本金
@property (strong, nonatomic) UILabel *interesLabel;//月供利息
@property (strong, nonatomic) UILabel *remainLabel;//剩余

@end

@implementation PaymentTabViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.principalLabel];
        [self.contentView addSubview:self.interesLabel];
        [self.contentView addSubview:self.remainLabel];

    }
    return self;
}
#pragma mark - methods
- (void)settingUIWithRow:(NSInteger)row withArrays:(NSArray *)arrays
{
    _monthLabel.text = [NSString stringWithFormat:@"%ld月",row+1];
    _principalLabel.text = arrays[0];
    _interesLabel.text = arrays[1];
    _remainLabel.text = [arrays lastObject];
}
- (void)settingUIWithRow:(NSInteger)row withArrays1:(NSArray *)arrays1 withArrays2:(NSArray *)arrays2
{
    _monthLabel.text = [NSString stringWithFormat:@"%ld月",row+1];
    _principalLabel.text = [NSString stringWithFormat:@"%.2f",[arrays1[0] doubleValue] + [arrays2[0] doubleValue]];
    _interesLabel.text = [NSString stringWithFormat:@"%.2f",[arrays1[1] doubleValue] + [arrays2[1] doubleValue]];
    _remainLabel.text = [NSString stringWithFormat:@"%.2f",[[arrays1 lastObject] doubleValue] + [[arrays2 lastObject] doubleValue]];
}

#pragma mark - setter and getter
- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, LABELWIDTH, 20)];
        _monthLabel.font = Font_14;
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.backgroundColor = [UIColor clearColor];
        _monthLabel.textColor = hexColor(666666);
    }
    return _monthLabel;
}
- (UILabel *)principalLabel
{
    if (!_principalLabel) {
        _principalLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABELWIDTH, 5, LABELWIDTH, 20)];
        _principalLabel.font = Font_14;
        _principalLabel.textAlignment = NSTextAlignmentCenter;
        _principalLabel.backgroundColor = [UIColor clearColor];
        _principalLabel.textColor = hexColor(666666);
    }
    return _principalLabel;
}
- (UILabel *)interesLabel
{
    if (!_interesLabel) {
        _interesLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABELWIDTH *2, 5, LABELWIDTH, 20)];
        _interesLabel.font = Font_14;
        _interesLabel.textAlignment = NSTextAlignmentCenter;
        _interesLabel.backgroundColor = [UIColor clearColor];
        _interesLabel.textColor = hexColor(666666);
    }
    return _interesLabel;
}
- (UILabel *)remainLabel
{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABELWIDTH *3, 5, LABELWIDTH, 20)];
        _remainLabel.font = Font_14;
        _remainLabel.textAlignment = NSTextAlignmentCenter;
        _remainLabel.backgroundColor = [UIColor clearColor];
        _remainLabel.textColor = hexColor(666666);
    }
    return _remainLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
