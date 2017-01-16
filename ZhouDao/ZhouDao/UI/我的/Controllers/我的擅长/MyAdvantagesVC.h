//
//  MyAdvantagesVC.h
//  ZhouDao
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, SelectType) {
    
    SelectMine = 0,//从我的界面
    SelectCer=1,//从 认证界面
};

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyAdvantagesVC : BaseViewController

@property (nonatomic, assign) SelectType type ;
@property (nonatomic, strong) NSMutableArray *compareArr;//对比数组
@property (nonatomic, copy)   ZDMutableArrayBlock  domainBlock;

@end
