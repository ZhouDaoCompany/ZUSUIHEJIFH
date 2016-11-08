//
//  GovernmentListVC.h
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProvinceModel.h"
typedef void(^LocalStringBlock)(ProvinceModel *proModel, NSString *showName);

@interface GovernmentListVC : BaseViewController


@property (nonatomic, copy) LocalStringBlock localBlock;

- (id)initWithCTName:(NSString *)ctname
        withShowName:(NSString *)showName
   withProvinceModel:(ProvinceModel *)proModel;
@end
