//
//  OrdinaryVC.h
//  ZhouDao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, OrdinarySearchType) {
    
    CaseSearchType = 0, //案例
    ContractSearchType = 1, //合同搜索
};

@interface OrdinaryVC : BaseViewController

- (instancetype)initWithOrdinarySearchType:(OrdinarySearchType)type;
@end
