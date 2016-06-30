//
//  AddFinanceVC.h
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, FinanceType)
{
    AddFinance = 0,//查看案件详情
    EditFinance = 1,//添加案件
};

@interface AddFinanceVC : BaseViewController

@property (nonatomic, assign) FinanceType financeType;
@property (nonatomic, strong) NSArray *oriArr;//原内容数组
@property (nonatomic, copy) NSString *caseId;//案件ID
@property (nonatomic, assign) NSInteger currentBtnTag;
@property (nonatomic, copy) NSString *cwid;//财务信息ID

@property (nonatomic, copy) ZDBlock successBlock;
@end
