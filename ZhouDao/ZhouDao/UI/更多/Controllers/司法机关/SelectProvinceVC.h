//
//  SelectProvinceVC.h
//  ZhouDao
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ProvinceModel.h"

typedef NS_ENUM(NSInteger, SelectType) {
    
    FromGoverment = 0,//来自司法机关
    FromOther = 1,//来自其他页面
};

typedef void(^StringBlock)(NSString *fullName);
typedef void(^ProvinceModelBlock) (NSString *showName, ProvinceModel *proModel);

@interface SelectProvinceVC : BaseViewController

@property (nonatomic, copy) StringBlock selectBlock;
@property (nonatomic, copy) ProvinceModelBlock provinceBlock;

- (id)initWithSelectType:(SelectType)selectType
         withIsHaveNoGAT:(BOOL)isHaveNoGAT;
@end
