//
//  NewlyCreatedVC.h
//  ZhouDao
//
//  Created by cqz on 16/5/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewlyCreatedVC : BaseViewController

@property (nonatomic, copy) NSString *caseId;//案件ID
@property (nonatomic, copy) NSString *pid;//父级ID
@property (nonatomic, copy) ZDBlock creatSuccess;//创建成功后的回调
@end
