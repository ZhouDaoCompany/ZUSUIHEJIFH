//
//  BreachDetailCell.m
//  ZhouDao
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BreachDetailCell.h"

@interface BreachDetailCell()

@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;

@end

@implementation BreachDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.label1];
        [self.contentView addSubview:self.label2];
        [self.contentView addSubview:self.label3];
        [self.contentView addSubview:self.label4];

    }
    
    return self;
}
#pragma mark - Methods
- (void)settUIWithArrays:(NSArray *)arrays
{
    NSString *startTime = arrays[0];
    NSString *endTime = arrays[1];
    _label1.text = [NSString stringWithFormat:@"%@-%@",[QZManager changeTimeMethods:[startTime doubleValue] withType:@"yy/MM/dd"],[QZManager changeTimeMethods:[endTime doubleValue] withType:@"yy/MM/dd"]];
    
    NSUInteger tttt = ([endTime integerValue] - [startTime integerValue])/86400.f;
//    NSUInteger year = tttt/(12*30);
//    NSUInteger mounth = (tttt%(12*30))/30;
//    NSUInteger day = tttt%(12*30);
//    NSUInteger hour = (tttt%(24*60*60))/(60*60);
//    NSUInteger minute = ((tttt%(24*60*60))%(60*60))/60;
//    NSUInteger second = ((tttt%(24*60*60))%(60*60))%60;
    _label2.text = [NSString stringWithFormat:@"%ld",(unsigned long)tttt];
    _label3.text = arrays[2];
    _label4.text = [arrays lastObject];

}
#pragma setter and getter
- (UILabel *)label1
{
    if (!_label1) {
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 12.5f, 110, 20)];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.font = [UIFont systemFontOfSize:11.f];
        _label1.textColor = hexColor(666666);
    }
    return _label1;
}
- (UILabel *)label2
{
    if (!_label2) {
        float width = (kMainScreenWidth - 145.f)/3.f;
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_label1) + 5, 12.5f, width, 20)];
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.font = [UIFont systemFontOfSize:11.f];
        _label2.textColor = hexColor(666666);
    }
    return _label2;
}
- (UILabel *)label3
{
    if (!_label3) {
        float width = (kMainScreenWidth - 145.f)/3.f;
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_label2) + 5, 12.5f, width+10, 20)];
        _label3.textAlignment = NSTextAlignmentCenter;
        _label3.font = [UIFont systemFontOfSize:11.f];
        _label3.textColor = hexColor(666666);
    }
    return _label3;
}
- (UILabel *)label4
{
    if (!_label4) {
        float width = (kMainScreenWidth - 145.f)/3.f;
        _label4 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_label3) + 5, 0, width, 45.f)];
        _label4.textAlignment = NSTextAlignmentCenter;
        _label4.font = [UIFont systemFontOfSize:11.f];
        _label4.numberOfLines = 0;
        _label4.textColor = hexColor(666666);
    }
    return _label4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
