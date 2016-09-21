//
//  HouseDetailVC.h
//  ZhouDao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HouseDetailVC : BaseViewController

@property (strong, nonatomic) NSMutableDictionary *bigDictionary;
@property (assign, nonatomic) BOOL isZH;//组合贷款;

@end
/*
 allMoney         总还款
 allLiXiMoney     总利息
 money            总贷款
 months           期数
 MutableArray     数组
 MutableArray2    数组  组合贷款用到
 */
