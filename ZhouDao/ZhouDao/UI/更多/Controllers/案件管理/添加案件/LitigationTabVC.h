//
//  LitigationTabVC.h
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreModel.h"
#import "BasicModel.h"

typedef NS_ENUM(NSInteger, LitigationType)
{
    LitiDetails = 0,//查看案件详情
    LitiAddCase = 1,//添加案件
};

@interface LitigationTabVC : UITableViewController

@property (nonatomic, assign) LitigationType litEditType;
@property (nonatomic, strong) NSMutableArray *moreArr;
@property (nonatomic, strong) BasicModel *basicModel;
@property (nonatomic, copy) NSString *caseId;//案件id
@property (nonatomic, copy) ZDStringBlock editSuccess;//编辑成功
@property (nonatomic, copy) ZDBlock addSuccess;//添加成功

@property (nonatomic, assign) BOOL isEdit;//是否可编辑
/*
 诉讼业务
 */

@end
