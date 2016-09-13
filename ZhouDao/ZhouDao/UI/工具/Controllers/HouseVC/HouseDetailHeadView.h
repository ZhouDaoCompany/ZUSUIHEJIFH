//
//  HouseDetailHeadView.h
//  ZhouDao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailHeadView : UIView

+ (HouseDetailHeadView *)instanceHouseDetailHeadViewPaymentMoney:(NSString *)PaymentMoney withInterest:(NSString *)interestMoney withLoan:(NSString *)loanMoney withMonths:(NSString *)monthCount;
+ (HouseDetailHeadView *)setOtherSetionTitle:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end
