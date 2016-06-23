//
//  TheCaseManageV.h
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, ManageType)
{
    FromMineType = 0,//从我的界面
    FromAddType =1,//加号按钮
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TheCaseManageVC : BaseViewController

@property (nonatomic, assign) ManageType type;
@end
