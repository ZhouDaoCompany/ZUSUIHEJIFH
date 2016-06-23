//
//  EditCaseVC.h
//  ZhouDao
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, EditCaseType)
{
    EditAccusing = 0,//非讼业务
    EditConsultant =1,//法律顾问
    EditLitigation =2,//诉讼业务
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EditCaseVC : BaseViewController

@property (nonatomic, strong) NSString *caseId;
@property (nonatomic ,assign) EditCaseType editType ;
@property (nonatomic, strong) NSMutableArray *msgArrays;
@property (nonatomic, copy) ZDMutableArrayBlock editSuccess;
@end
