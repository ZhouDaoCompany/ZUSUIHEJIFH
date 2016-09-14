//
//  CompensationVC.h
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, CompensationType)
{
    CompensationFromHome = 0,//从我的界面
    CompensationFromAdd =1,//加号按钮
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CompensationVC : BaseViewController
@property (nonatomic, assign) CompensationType pType;
@end
