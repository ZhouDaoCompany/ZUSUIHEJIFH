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


/**
 根据时间取出银行同期利率

 @param rateArrays    银行同期公布利率数组
 @param differTimeDay 相差天数

 @return 银行利率
 */
+ (double)getRateCalculateWithRateArrays:(NSArray *)rateArrays withDays:(double)differTimeDay;

/**
 社保计算

 @param dictionary 各地区字典
 @param wage 工资
 @param success 成功回调
 */
+ (void)getPersonalSocialSecurity:(NSDictionary *)dictionary withWage:(CGFloat)wage Success:(void (^)(CGFloat grmoney, CGFloat gsmoney, CGFloat grGJJmoney, CGFloat gsGJJmoney, CGFloat taxMoney))success;

/**
 个人所得税计算

 @param wage 工资
 @param grMoney 个人社保
 @param grgjjMoney 个人公积金
 @return 个人所得税
 */
+ (CGFloat)TheIndividualIncomeTaxIsCalculatedWithWage:(CGFloat)wage withGRSB:(CGFloat)grMoney
                                            withGRGJJ:(CGFloat)grgjjMoney;

/**
 检测更新plist文件
 */
+ (void)detectionOfUpdatePlistFile;

/**
 解压打包文件到 Document里
 */
+ (void)unCompressZipDocuments;

/**
 解压文件到 Document里

 @param zipName zip文件的名字  是plistName 和 plist文件版本号
 */
+ (void)unCompressZipDocumentsWithPlistName:(NSString *)zipName;
@end
