//
//  SelectCityViewController.h
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, CityType) {
    
    EconomicType = 0,  //经济补偿
    InjuryType   = 1,   //工伤
    SocialType   = 2,    //社保
};

typedef  void(^CityBlock)(NSString *name,NSString *idString);
typedef  void(^ProvinceCityBlock)(NSString *provinceName,NSString *cityName,NSString *idString);
typedef void(^SocialBlock)(NSString *name, NSDictionary *cityDictionary);

@interface SelectCityViewController : BaseViewController


@property (nonatomic, copy) CityBlock citySelectBlock;
@property (nonatomic, copy) ProvinceCityBlock provinceCitySelectBlock;
@property (nonatomic, copy) SocialBlock socialBlock;
@property (nonatomic ,assign) CityType type ;

@end
