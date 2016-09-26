//
//  PersonalComputingResultsVC.h
//  ZhouDao
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PersonalComputingResultsVC : BaseViewController

@property (nonatomic, copy) NSString *moneyString;
@property (nonatomic, strong) NSMutableDictionary *detailDictionary;
//地区，户口，伤残项，伤残等级
@end
