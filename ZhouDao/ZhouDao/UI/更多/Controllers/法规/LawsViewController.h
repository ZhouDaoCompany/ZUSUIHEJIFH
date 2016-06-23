//
//  LawsViewController.h
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, LawsType)
{
    LawFromHome = 0,//从我的界面
    LawFromAdd =1,//加号按钮
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LawsViewController : BaseViewController

@property (nonatomic, assign) LawsType lawType;

@end
