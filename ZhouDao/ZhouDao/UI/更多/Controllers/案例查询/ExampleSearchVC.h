//
//  ExampleSearchVC.h
//  ZhouDao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, SearchType)
{
    SearchFromHome = 0,//从我的界面
    SearchFromAdd =1,//加号按钮
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ExampleSearchVC : BaseViewController

@property (nonatomic, assign) SearchType sType;

@end
