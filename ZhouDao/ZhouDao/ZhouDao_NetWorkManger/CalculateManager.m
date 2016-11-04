//
//  CalculateManager.m
//  ZhouDao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CalculateManager.h"
#import "SSZipArchive.h"

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
#pragma mark -根据时间取出银行同期利率
+ (double)getRateCalculateWithRateArrays:(NSArray *)rateArrays withDays:(double)differTimeDay
{
    NSString *rateString = @"";
    if(differTimeDay <= 180){
        
        rateString = rateArrays[0];
    }else if(differTimeDay <= 365){
        
        rateString = rateArrays[1];
    }else if(differTimeDay <= 1095){
        
        rateString = rateArrays[2];
    }else if(differTimeDay <= 1825){
        
        rateString = rateArrays[3];
    }else {
        
        rateString = rateArrays[4];
    }
    return [rateString doubleValue];
}

#pragma mark - 解压打包文件到 Document里
+ (void)unCompressZipDocuments {
    
    if ([FILE_M fileExistsAtPath:PLISTCachePath]) {
        
        [FILE_M removeItemAtPath:PLISTCachePath error:nil];
    }
    NSString *CalculateFileZip = [[NSBundle mainBundle] pathForResource:@"CalculatePlistFile" ofType:@"zip"];
    NSString *unZipPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    [SSZipArchive unzipFileAtPath:CalculateFileZip toDestination:unZipPath];
}

+ (void)unCompressZipDocumentsWithPlistName:(NSString *)zipName {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSString *zipPath = [PLISTCachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",zipName]];
        [SSZipArchive unzipFileAtPath:zipPath toDestination:PLISTCachePath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            //删除文件
            [FILE_M removeItemAtPath:zipPath error:nil];
        });
    });
}
#pragma mark - 检测更新plist文件
+ (void)detectionOfUpdatePlistFile {
    
    if ([PublicFunction ShareInstance].isFirstLaunch) {
        
        [[self class] unCompressZipDocuments];
    } else {
        //根据文件版本号请求判断更新
         
    }
}

@end











