//
//  DreiveMapVC.h
//  ZhouDao
//
//  Created by cqz on 16/6/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "BaseViewController.h"

@interface DeriveMapVC : BaseViewController


@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) AMapNaviPoint *startPoint;

@end
