//
//  ToolsWedViewVC.h
//  ZhouDao
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, ToolsType)
{
    FromCaseType  =   0,     //案件管理
    FromToolsType =   1,     //工具
    FromHotType   =   2,     //实事热点
    FromEveryType =   3,     //每日轮播
    FromRecHDType =   4,     //推荐页幻灯
};

@interface ToolsWedViewVC : BaseViewController

@property (nonatomic ,assign) ToolsType tType ;//全部
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *format;//格式
@property (nonatomic, copy) NSString *introContent;
@property (nonatomic, copy) NSString *shareContent;

@end
