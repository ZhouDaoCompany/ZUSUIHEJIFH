//
//  AccusingTheTabVC.h
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, AccEditType)
{
    AccFromManager = 0,//从案件详情
    AccFromAddCase = 1,//从添加案件
    
};

#import <UIKit/UIKit.h>
/*
 非讼业务
 */

@interface AccusingTheTabVC : UITableViewController

@property (nonatomic, assign) AccEditType accType;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, copy) ZDMutableArrayBlock editSuccess;

@end
