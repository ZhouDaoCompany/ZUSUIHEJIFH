//
//  LitigationTabVC.h
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, LitigationType)
{
    FromManager = 0,//从案件详情
    FromAddCase = 1,//从添加案件
};
#import <UIKit/UIKit.h>
/*
 诉讼业务
 */

@interface LitigationTabVC : UITableViewController

@property (nonatomic, assign) LitigationType litEditType;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, copy) ZDMutableArrayBlock editSuccess;
@end
