//
//  CalculateManager.m
//  ZhouDao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CalculateManager.h"
#import "SSZipArchive.h"
#import "PlistFileModel.h"
#import "FileDataModel.h"

@implementation CalculateManager


#pragma mark - 房贷等额本息计算公式
+ (double)loanPrincipal:(double)P withAnInterest:(double)R withRepaymentPeriods:(NSUInteger)N {
    double money = 0.0f;
    money = P*(R*pow(1 + R, N))/(pow(1 + R, N) - 1);
    return money;
}

#pragma mark -  等额本息计算月供本金
+ (NSMutableArray *)getAllMonthsWithPrincipal:(double)principal withMonthsMoney:(double)monthsMoneys withRate:(double)rate withMonthsCounts:(double)monthsCounts {
    
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
+ (double)getRateCalculateWithRateArrays:(NSArray *)rateArrays withDays:(double)differTimeDay {
    
    NSString *rateString = @"";
    if(differTimeDay <= 180) {
        
        rateString = rateArrays[0];
    }else if(differTimeDay <= 365) {
        
        rateString = rateArrays[1];
    }else if(differTimeDay <= 1095) {
        
        rateString = rateArrays[2];
    }else if(differTimeDay <= 1825) {
        
        rateString = rateArrays[3];
    }else {
        
        rateString = rateArrays[4];
    }
    return [rateString doubleValue];
}

//MARK: 社保
/*
 工资计算公式：
 税后工资 =
 税前工资
 - 个人社保（gr_ratio*工资）
 - 个人公积金（gr_ratio*工资）
 - 个人所得税
 
 社保计算公式：
 个人（工资  * 城市对应 gr_ratio）
 企业（工资  * 城市对应 gs_ratio）
 如果工资小于 down ，则 down 值替换工资计算
 如果工资大于 up， 则 up 值替换工资计算
 
 公积金计算公式：
 个人（工资  * 城市对应 gr_ratio）
 企业（工资  * 城市对应 gs_ratio）
 如果工资小于 down ，则 down 值替换工资计算
 如果工资大于 up， 则 up 值替换工资计算
 
 个人所得税计算：
 计算金额 = 工资 - 社保 - 公积金 - [假期] - 3500
 计算金额小于0按照0计算
 
 <=1500  【计算金额 * 0.03】
 <=4500  【计算金额 * 0.1 - 105】
 <=9000  【计算金额 * 0.2 - 555】
 <=35000【计算金额 * 0.25 - 1005】
 <=55000【计算金额 * 0.3 - 2755】
 <=80000【计算金额 * 0.35 - 5505】
 >80000【计算金额 * 0.45 - 13505】
*/
+ (void)getPersonalSocialSecurity:(NSDictionary *)dictionary withWage:(CGFloat)wage Success:(void (^)(CGFloat grmoney, CGFloat gsmoney, CGFloat grGJJmoney, CGFloat gsGJJmoney, CGFloat taxMoney))success{
    
    __block CGFloat grmoney = 0.f;//个人社保
    __block CGFloat gsmoney = 0.f;//公司社保
    __block CGFloat grGJJmoney = 0.f;//个人公积金
    __block CGFloat gsGJJmoney = 0.f;//公司公积金
    CGFloat taxmoney = 0.0f;

    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *objDictionary, BOOL * _Nonnull stop) {
        
        PlistFileModel *model = [[PlistFileModel alloc] initWithDictionary:objDictionary];
        CGFloat tempWage = wage;
        if (wage > [model.up floatValue]) {
            tempWage = [model.up floatValue];
        } else if (wage < [model.down floatValue]) {
            tempWage = [model.down floatValue];
        }

        if ([key isEqualToString:@"gongjijin"]) {
            
            grGJJmoney += tempWage * [model.gr_ratio floatValue]/100.f;
            gsGJJmoney += tempWage * [model.gs_ratio floatValue]/100.f;
        } else {
            grmoney += tempWage * [model.gr_ratio floatValue]/100.f;
            gsmoney += tempWage * [model.gs_ratio floatValue]/100.f;
        }
    }];
    
    taxmoney = [[self class] TheIndividualIncomeTaxIsCalculatedWithWage:wage withGRSB:grmoney
                                                              withGRGJJ:grGJJmoney];
    success(grmoney , gsmoney, grGJJmoney, gsGJJmoney, taxmoney);
}
//MARK: 社保结果页计算
+ (void)socialSecurityCalculationResultsPageWithDataSource:(NSMutableArray *)dataSource withWage:(CGFloat)wage Success:(void (^)(CGFloat grmoney, CGFloat gsmoney, CGFloat grGJJmoney, CGFloat gsGJJmoney, CGFloat taxMoney))success {

    __block CGFloat grmoney = 0.f;//个人社保
    __block CGFloat gsmoney = 0.f;//公司社保
    __block CGFloat grGJJmoney = 0.f;//个人公积金
    __block CGFloat gsGJJmoney = 0.f;//公司公积金
    CGFloat taxmoney = 0.0f;
    
    [dataSource  enumerateObjectsUsingBlock:^(PlistFileModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat tempWage = wage;
        if (wage > [model.up floatValue]) {
            tempWage = [model.up floatValue];
        } else if (wage < [model.down floatValue]) {
            tempWage = [model.down floatValue];
        }
        if (idx == [dataSource count] - 1) {
            
            grGJJmoney += tempWage * [model.gr_ratio floatValue]/100.f;
            gsGJJmoney += tempWage * [model.gs_ratio floatValue]/100.f;
        } else {
            grmoney += tempWage * [model.gr_ratio floatValue]/100.f;
            gsmoney += tempWage * [model.gs_ratio floatValue]/100.f;
        }
    }];
    
    taxmoney = [[self class] TheIndividualIncomeTaxIsCalculatedWithWage:wage withGRSB:grmoney
                                                              withGRGJJ:grGJJmoney];
    success(grmoney , gsmoney, grGJJmoney, gsGJJmoney, taxmoney);
}
+ (CGFloat)TheIndividualIncomeTaxIsCalculatedWithWage:(CGFloat)wage withGRSB:(CGFloat)grMoney
                                            withGRGJJ:(CGFloat)grgjjMoney{
    
    CGFloat taxmoney = 0.0f;
    CGFloat tempMoney = wage - grMoney - grgjjMoney - 3500;
    if (tempMoney < 0) {
        tempMoney = 0;
    }
    
    if (tempMoney <= 1500) {
        
        taxmoney = tempMoney * 0.03;
    }else if (tempMoney <= 4500) {
        
        taxmoney = tempMoney * 0.1 - 105;
    }else if (tempMoney <= 9000) {
        
        taxmoney = tempMoney * 0.2 - 555;
    }else if (tempMoney <= 35000) {
        
        taxmoney = tempMoney * 0.25 - 1005;
    }else if (tempMoney <= 55000) {
        
        taxmoney = tempMoney * 0.3 - 2755;
    }else if (tempMoney <= 80000) {
        
        taxmoney = tempMoney * 0.35 - 5505;
    }else {
        taxmoney = tempMoney * 0.45 - 13505;
    }
    
    return taxmoney;
}

#pragma mark - 解压打包文件到 Document里
+ (void)unCompressZipDocuments {
    
    if ([FILE_M fileExistsAtPath:PLISTCachePath]) {
        
        [FILE_M removeItemAtPath:PLISTCachePath error:nil];
    }
    NSString *CalculateFileZip = [[NSBundle mainBundle] pathForResource:@"CalculatePlistFile" ofType:@"zip"];
    NSString *unZipPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    [SSZipArchive unzipFileAtPath:CalculateFileZip toDestination:unZipPath];
    NSDictionary *fileDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"lawyerfees",@"1",@"bankinterestrates",@"1",@"holiday",@"1",@"gongshang",@"1",@"theaveragesalary",@"1",@"cityruralincome",@"1",@"provincescity", nil];
    [USER_D setObject:fileDictionary forKey:CALCULATEPLISTVERSION];
    [USER_D synchronize];
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
        NSString *urlString = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,NEWVERSIONTXTURL];
        NSDictionary *fileDictionary = [USER_D objectForKey:CALCULATEPLISTVERSION];
        NSMutableString *fileString = [[NSMutableString alloc] init];
        NSArray *nameArrays = [fileDictionary allKeys];
        for (NSUInteger i = 0; i < [nameArrays count]; i++) {
            
            NSString *nameString = nameArrays[i];
            NSString *versionString = fileDictionary[nameString];

            NSString *append = (i == [nameArrays count] -1) ? [NSString stringWithFormat:@"%@-%@",nameString,versionString] : [NSString stringWithFormat:@"%@-%@,",nameString,versionString];
            [fileString appendString:append];
        }
        
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:fileString,@"txt", nil];
        [ZhouDao_NetWorkManger postWithUrl:urlString params:paraDict success:^(id response) {
            
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            if (errorcode !=1) {
                return ;
            }
            NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CalculatePlistFile/TempFile"];

            //删除重建 防止碎片文件
            if ([FILE_M fileExistsAtPath:tempPath]) {
                
                [FILE_M removeItemAtPath:tempPath error:nil];
            }
            [FILE_M createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];

            NSDictionary *dataDictionary = jsonDic[@"data"];
            FileDataModel *dataModel = [[FileDataModel alloc] initWithDictionary:dataDictionary];
            [[self class] startDownloadPlistFileWithFileDataModel:dataModel];
            DLog(@"%@",[NSString stringWithFormat:@"%@",jsonDic]);
            
        } fail:^(NSError *error) {
        }];
    }
}
+ (void)startDownloadPlistFileWithFileDataModel:(FileDataModel *)dataModel {
    
    [MBProgressHUD showMBLoadingWithText:dataModel.txt];
    NSDictionary *fileDictionary = [USER_D objectForKey:CALCULATEPLISTVERSION];
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    [resultDictionary addEntriesFromDictionary:fileDictionary];
    
    // 1. 调度组
    dispatch_group_t group = dispatch_group_create();
    // 2. 队列
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);

    for (NSUInteger i = 0; i < [dataModel.file count]; i++) {
        
        PlistFileModel *fileModel = dataModel.file[i];
        dispatch_group_enter(group);
        dispatch_group_async(group, q, ^{
            
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/CalculatePlistFile/%@.plist",fileModel.name]];
            NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/CalculatePlistFile/TempFile%@.plist",fileModel.name]];

            [ZhouDao_NetWorkManger downloadWithUrl:fileModel.address saveToPath:tempPath progress:^(int64_t bytesRead, int64_t totalBytesRead) {
            } success:^(id response) {
                
                //删除文件
                [FILE_M removeItemAtPath:filePath error:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [FILE_M moveItemAtPath:tempPath toPath:filePath error:nil];
                    [resultDictionary setObject:fileModel.version forKey:fileModel.name];
                    dispatch_group_leave(group);
                });
                
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
            }];
        });
    }

    // 4. 监听所有任务完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        DLog(@"打印出来字典－－－－   %@",resultDictionary);
        [USER_D setObject:resultDictionary forKey:CALCULATEPLISTVERSION];
        [USER_D synchronize];
        [MBProgressHUD hideHUD];
        DLog(@"所有任务完成");
    });
}

@end
