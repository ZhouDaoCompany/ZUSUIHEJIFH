//
//  ConsultantTabVC.h
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, ConsultantType)
{
    ConFromManager = 0,//从案件详情
    ConFromAddCase = 1,//从添加案件
    
};

#import <UIKit/UIKit.h>
/*
 法律顾问
 */

@interface ConsultantTabVC : UITableViewController

@property (nonatomic, assign) ConsultantType ConType;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, copy) ZDMutableArrayBlock editSuccess;

@end
