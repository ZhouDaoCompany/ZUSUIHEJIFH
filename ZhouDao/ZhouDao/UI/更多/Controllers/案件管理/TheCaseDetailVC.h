//
//  TheCaseDetailVC.h
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, DetailType)
{
    AccusingThetype = 0,//非讼业务
    ConsultantType =1,//法律顾问
    LitigationType =2,//诉讼业务
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface TheCaseDetailVC : BaseViewController

@property (nonatomic, strong) NSString *caseId;//案件唯一id  cid
@property (nonatomic ,assign) DetailType type ;//全部
@property (nonatomic, strong) NSMutableArray *msgArrays;//信息数组
@end
