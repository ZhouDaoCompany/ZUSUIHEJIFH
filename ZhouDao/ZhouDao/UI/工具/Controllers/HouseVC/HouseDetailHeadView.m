//
//  HouseDetailHeadView.m
//  ZhouDao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HouseDetailHeadView.h"

@interface HouseDetailHeadView()

@property (weak, nonatomic) IBOutlet UILabel *totalPaymentLabel;//总还款
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;//总利息
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;//总贷款
@property (weak, nonatomic) IBOutlet UILabel *monthCount;//总月数

@end

@implementation HouseDetailHeadView

+(HouseDetailHeadView *)instanceHouseDetailHeadView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HouseDetailHeadView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self){
//        
//        self.backgroundColor = hexColor(FFFFFF);
//        [self initUI];
//    }
//    return self;
//}
//#pragma mark -  methods
//- (void)initUI
//{
//    
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
