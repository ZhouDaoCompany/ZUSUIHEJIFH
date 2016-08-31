//
//  GovernmentDetailVC.h
//  ZhouDao
//
//  Created by cqz on 16/5/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GovListmodel.h"

@interface GovernmentDetailVC : BaseViewController

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, strong) GovListmodel *model;
@property (nonatomic, strong) NSString *detailAddress;//详细地址用于编码
@end
