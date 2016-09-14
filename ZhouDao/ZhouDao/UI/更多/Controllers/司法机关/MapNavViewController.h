//
//  MapNavViewController.h
//  ZhouDao
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "BaseViewController.h"
@interface MapNavViewController : BaseViewController

@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) AMapNaviPoint *startPoint;

@end
