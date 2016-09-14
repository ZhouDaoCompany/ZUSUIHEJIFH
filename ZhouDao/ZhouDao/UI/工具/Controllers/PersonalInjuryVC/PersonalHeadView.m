//
//  PersonalHeadView.m
//  ZhouDao
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PersonalHeadView.h"

@interface PersonalHeadView()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *hkLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (strong, nonatomic) UILabel *oneLabel;
@property (strong, nonatomic) UILabel *twoLabel;

@end

@implementation PersonalHeadView

+ (PersonalHeadView *)instancePersonalHeadViewWithTotalMoney:(NSString *)totalMoney withArea:(NSString *)area withHK:(NSString *)hk withItem:(NSString *)item withGrade:(NSString *)grade
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PersonalHeadView" owner:self options:nil];
    PersonalHeadView *headView = [nibView objectAtIndex:0];
    [headView initUIWithTotalMoney:totalMoney withArea:area withHK:hk withItem:item withGrade:grade];
    return headView;

}
- (void)initUIWithTotalMoney:(NSString *)totalMoney withArea:(NSString *)area withHK:(NSString *)hk withItem:(NSString *)item withGrade:(NSString *)grade
{
    _totalLabel.text = totalMoney;

    if (item.length == 0) {
        
        _lineView1.hidden = YES;
        _lineView3.hidden = YES;
        _areaLabel.hidden = YES;
        _hkLabel.hidden = YES;
        _itemLabel.hidden = YES;
        _gradeLabel.hidden = YES;
        
        [self.bottomView addSubview:self.oneLabel];
        [self.bottomView addSubview:self.twoLabel];
        
        _oneLabel.text = area;
        _twoLabel.text = hk;


    }else{
       
        _areaLabel.text = area;
        _hkLabel.text = hk;
        _itemLabel.text = item;
        _gradeLabel.text = grade;

    }
    
}
- (UILabel *)oneLabel
{
    if (!_oneLabel) {
        
        _oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kMainScreenWidth/2.f, 30)];
        _oneLabel.font = Font_12;
        _oneLabel.backgroundColor = [UIColor clearColor];
        _oneLabel.textColor = hexColor(FFFFFF);
        _oneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _oneLabel;
}
- (UILabel *)twoLabel
{
    if (!_twoLabel) {
        
        _twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.f, 8, kMainScreenWidth/2.f, 30)];
        _twoLabel.font = Font_12;
        _twoLabel.backgroundColor = [UIColor clearColor];
        _twoLabel.textColor = hexColor(FFFFFF);
        _twoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _twoLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
