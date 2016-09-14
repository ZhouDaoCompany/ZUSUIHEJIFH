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
#import "MoreModel.h"
#import "BasicModel.h"

/*
 法律顾问
 */

@interface ConsultantTabVC : UITableViewController

@property (nonatomic, assign) ConsultantType ConType;
@property (nonatomic, strong) NSMutableArray *moreArr;
@property (nonatomic, strong) BasicModel *basicModel;

@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, copy) ZDStringBlock editSuccess;
@property (nonatomic, copy) ZDBlock addSuccess;//添加成功

@property (nonatomic, assign) BOOL isEdit;//是否可编辑

@end
