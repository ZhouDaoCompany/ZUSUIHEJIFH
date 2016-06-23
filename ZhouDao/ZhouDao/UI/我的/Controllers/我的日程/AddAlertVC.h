//
//  AddAlertVC.h
//  ZhouDao
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger, AlertType)
{
    FromAddBtn = 0,//从加号按钮
    FromEditBtn = 1,//从编辑按钮
};
typedef void(^AlertBlock)(NSDate *,NSString *);
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RemindData.h"

@interface AddAlertVC : BaseViewController

@property (nonatomic, assign) AlertType alertType;
@property (nonatomic, strong) RemindData *dataModel;
@property (nonatomic, strong) AlertBlock successBlock;
@end
