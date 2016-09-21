//
//  CalculateManager.m
//  ZhouDao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager


#pragma mark - 房贷等额本息计算公式
+ (double)loanPrincipal:(double)P withAnInterest:(double)R withRepaymentPeriods:(NSUInteger)N
{
    double money = 0.0f;
    money = P*(R*pow(1 + R, N))/(pow(1 + R, N) - 1);
    return money;
}

#pragma mark -  等额本息计算月供本金
+ (NSMutableArray *)getAllMonthsWithPrincipal:(double)principal withMonthsMoney:(double)monthsMoneys withRate:(double)rate withMonthsCounts:(double)monthsCounts
{
    NSMutableArray *arrays = [NSMutableArray array];
    
    
    for (NSUInteger i = 0; i< monthsCounts; i++) {

        NSMutableArray *smallArrays = [NSMutableArray array]; //小数组内结构 月供本金，月供利息，剩余本金
        
        static double lastBj  = 0.0f;//已经还的本金
        if (i == 0) {
            lastBj = 0.0f;//第一次为0，防止记录
        }
        
        double remainMoney = principal - lastBj;//剩余本金
        double lixi =remainMoney* rate;         //月供利息
        double bj   = monthsMoneys - lixi;      //月供本金
        
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",bj *10000]];
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",lixi *10000]];
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",(remainMoney - bj) *10000]];

        [arrays addObject:smallArrays];
        lastBj += bj;
    }
    
    return arrays;
}


@end











