//
//  SelectCityViewController.h
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, CityType)
{
    EconomicType = 0,//经济补偿
    InjuryType   =1,   //工伤
};

typedef  void(^CityBlock)(NSString *name,NSString *idString);

@interface SelectCityViewController : BaseViewController


@property (nonatomic, copy) CityBlock citySelectBlock;
@property (nonatomic ,assign) CityType type ;

@end
