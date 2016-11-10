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

+ (PersonalHeadView *)instancePersonalHeadViewWithTotalMoney:(NSString *)totalMoney withDictionary:(NSDictionary *)dict withDelegate:(id<PersonalHeadViewDelegate>)delegate
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PersonalHeadView" owner:self options:nil];
    PersonalHeadView *headView = [nibView objectAtIndex:0];
    [headView initUIWithTotalMoney:totalMoney withDictionary:dict withDelegate:delegate];
    return headView;

}
- (void)initUIWithTotalMoney:(NSString *)totalMoney withDictionary:(NSDictionary *)dict withDelegate:(id<PersonalHeadViewDelegate>)delegate
{
    _totalLabel.text = CancelPoint2([totalMoney floatValue]);
    _delegate = delegate;
    if (dict.count == 2) {
        
        _lineView1.hidden = YES;
        _lineView3.hidden = YES;
        _areaLabel.hidden = YES;
        _hkLabel.hidden = YES;
        _itemLabel.hidden = YES;
        _gradeLabel.hidden = YES;
        
        [self.bottomView addSubview:self.oneLabel];
        [self.bottomView addSubview:self.twoLabel];
        
        NSString *area = dict[@"area"];
        NSString *hk   = dict[@"hk"];
        _oneLabel.text = [NSString stringWithFormat:@"地区\n%@",area];
        _twoLabel.text = [NSString stringWithFormat:@"户口\n%@",hk];
// [NSString stringWithFormat:@"%@",[ stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ]];
    }else{
       
        NSString *area = dict[@"area"];
        NSString *hk   = dict[@"hk"];
        NSString *item = dict[@"item"];
        NSString *sss = [NSString stringWithFormat:@"地区\n%@",area];
        _areaLabel.text = sss;
        _hkLabel.text = [NSString stringWithFormat:@"户口\n%@",hk];
        _itemLabel.text = [NSString stringWithFormat:@"伤残项\n%@",item];
        
        if ([item isEqualToString:@"单级"]) {
            NSString *grade = dict[@"grade"];
            _gradeLabel.text =  [NSString stringWithFormat:@"伤残等级\n%@",grade];
        }else {
            
            NSArray *levelArr = dict[@"grade"];
            NSDictionary *dict = levelArr[0];
            if (levelArr.count >1) {
                
                _gradeLabel.text = [NSString stringWithFormat:@"伤残等级\n%@:%@处···",dict[@"level"],dict[@"several"]];
            }else {
                
                _gradeLabel.text = [NSString stringWithFormat:@"伤残等级\n%@  %@处",dict[@"level"],dict[@"several"]];
            }
            
            
            WEAKSELF;
            [_gradeLabel whenCancelTapped:^{
                
                if ([weakSelf.delegate respondsToSelector:@selector(clickGradeEvent)])
                {
                    [weakSelf.delegate clickGradeEvent];
                }

            }];
            
        }
    }
    
}
- (UILabel *)oneLabel
{
    if (!_oneLabel) {
        
        _oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kMainScreenWidth/2.f, 30)];
        _oneLabel.font = Font_12;
        _oneLabel.backgroundColor = [UIColor clearColor];
        _oneLabel.textColor = hexColor(FFFFFF);
        _oneLabel.numberOfLines = 0;
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
        _twoLabel.numberOfLines = 0;
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
