//
//  LitigationTabVC.h
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LitigationType)
{
    LitiDetails = 0,//查看案件详情
    LitiAddCase = 1,//添加案件
    LitiEdit    = 2,//编辑案件
};

@interface LitigationTabVC : UITableViewController

@property (nonatomic, assign) LitigationType litEditType;

/*
 诉讼业务
 */

@end
