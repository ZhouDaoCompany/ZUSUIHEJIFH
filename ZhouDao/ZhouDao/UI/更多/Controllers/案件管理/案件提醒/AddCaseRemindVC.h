//
//  AddCaseRemindVC.h
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RemindData.h"

typedef NS_ENUM(NSInteger, CaseRemindType)
{
    EditRemind = 0,//编辑案件
    AddRemind  = 1,//添加案件
    DetailRemind = 2,//看详情
};

@interface AddCaseRemindVC : BaseViewController

@property (nonatomic, assign) CaseRemindType remindType;
@property (nonatomic, copy) NSString *caseId;//案件ID
@property (nonatomic, copy) ZDBlock addSuccess;
@property (nonatomic, strong) RemindData *dataModel;

@end
