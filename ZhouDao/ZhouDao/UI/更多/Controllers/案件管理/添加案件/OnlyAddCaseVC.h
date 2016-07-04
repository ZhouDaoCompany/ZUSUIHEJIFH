//
//  OnlyAddCaseVC.h
//  ZhouDao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, AddCaseType)
{
    AddAccusing = 0,//非讼业务
    AddConsultant =1,//法律顾问
    AddLitigation =2,//诉讼业务
};

@interface OnlyAddCaseVC : BaseViewController

@property (nonatomic ,assign) AddCaseType addType ;

@property (nonatomic, copy) ZDBlock addSuccessBlock;//添加成功
@end
