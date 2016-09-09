//
//  BreachDetailVC.h
//  ZhouDao
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, RATEDETAILTYPE)
{
    BreachType = 0,//违约金
    LiXiType   = 1,//利息
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BreachDetailVC : BaseViewController

@property (strong, nonatomic) NSMutableDictionary *detailDictionary;//详情字典
@property (assign, nonatomic) RATEDETAILTYPE detailType;
@end
