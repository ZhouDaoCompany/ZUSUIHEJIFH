//
//  SelectCityViewController.h
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef  void(^CityBlock)(NSString *name,NSString *idString);

@interface SelectCityViewController : BaseViewController


@property (nonatomic, copy) CityBlock citySelectBlock;
@end
