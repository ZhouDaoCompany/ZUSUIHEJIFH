//
//  GovermentVC.h
//  ZhouDao
//
//  Created by cqz on 16/4/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, GoverMentType)
{
    GovFromHome = 0,//从我的界面
    GovFromAdd =1,//加号按钮
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GovermentVC : BaseViewController

@property (nonatomic, assign) GoverMentType Govtype;

@end
