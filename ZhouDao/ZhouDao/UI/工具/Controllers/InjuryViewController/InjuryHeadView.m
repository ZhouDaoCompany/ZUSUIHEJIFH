//
//  InjuryHeadView.m
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "InjuryHeadView.h"
@interface InjuryHeadView()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *gzLabel;

@end
@implementation InjuryHeadView

+ (InjuryHeadView *)instancePersonalHeadViewWithDictionary:(NSDictionary *)dict
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"InjuryHeadView" owner:self options:nil];
    InjuryHeadView *headView = [nibView objectAtIndex:0];
    [headView initUIWithDictionary:dict];
    return headView;
}
- (void)initUIWithDictionary:(NSDictionary *)dict
{
    _moneyLabel.text = dict[@"money"];
    NSString *city = dict[@"city"];
    NSString *level   = dict[@"level"];
    NSString *gz = dict[@"gongzi"];

    _cityLabel.text = [NSString stringWithFormat:@"地区\n%@",city];
    _levelLabel.text = [NSString stringWithFormat:@"伤残等级\n%@",level];
    _gzLabel.text = [NSString stringWithFormat:@"薪资(元/月)\n%@",gz];

}
@end
