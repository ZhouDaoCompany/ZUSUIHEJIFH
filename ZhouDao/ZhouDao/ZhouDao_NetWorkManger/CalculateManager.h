//
//  CalculateManager.h
//  ZhouDao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateManager : NSObject



/**
 房贷等额本息计算公式
 P:贷款本金  R:月利率    N:还款期数    还款期数=贷款年限×12
 @param P 贷款本金
 @param R 月利率
 @param N 还款期数
 
 @return 月供本息
 */
+ (double)loanPrincipal:(double)P withAnInterest:(double)R withRepaymentPeriods:(NSUInteger)N;

/**
 等额本息计算月供本金

 @param principal    总贷款
 @param monthsMoneys 月供
 @param rate         利率
 @param monthsCounts 总期数

 @return 等额本息信息数组
 */
+ (NSMutableArray *)getAllMonthsWithPrincipal:(double)principal withMonthsMoney:(double)monthsMoneys withRate:(double)rate withMonthsCounts:(double)monthsCounts;

@end
