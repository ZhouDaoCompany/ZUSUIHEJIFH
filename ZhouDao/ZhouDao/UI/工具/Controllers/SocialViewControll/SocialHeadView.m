//
//  SocialHeadView.m
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialHeadView.h"

#define TEXTWIDTH   [UIScreen mainScreen].bounds.size.width/3.f

@interface SocialHeadView()

@property (weak, nonatomic) IBOutlet UILabel *shgzLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqgzLabel;
@property (weak, nonatomic) IBOutlet UILabel *grjnLabel;
@property (weak, nonatomic) IBOutlet UILabel *gsjnLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@end

@implementation SocialHeadView

+ (SocialHeadView *)instanceSocialHeadViewWithDictionary:(NSDictionary *)dict
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SocialHeadView" owner:self options:nil];
    SocialHeadView *headView = [nibView objectAtIndex:0];
    
    [headView initUIWithDictionary:dict];
    return headView;
}
- (void)initUIWithDictionary:(NSDictionary *)dict {
    

    NSString *allMoney = dict[@"shuihou"];
    NSString *cityName = dict[@"cityName"];
    NSString *shuiq = dict[@"wage"];
    NSString *grjn   = dict[@"grjn"];
    NSString *gsjn = dict[@"gsjn"];
    
    _shgzLabel.text = [NSString stringWithFormat:@"%@",allMoney];
    _sqgzLabel.text = [NSString stringWithFormat:@"税前工资:\n¥%@",shuiq];
    _grjnLabel.text = [NSString stringWithFormat:@"个人缴纳:\n¥%@",grjn];
    _gsjnLabel.text = [NSString stringWithFormat:@"公司缴纳:\n¥%@",gsjn];
    _cityLabel.text = [NSString stringWithFormat:@"%@",cityName];
}

@end
