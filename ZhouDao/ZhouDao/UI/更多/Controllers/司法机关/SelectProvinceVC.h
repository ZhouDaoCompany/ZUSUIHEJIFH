//
//  SelectProvinceVC.h
//  ZhouDao
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^StringBlock)(NSString *string,NSString *str);

#import "BaseViewController.h"

@interface SelectProvinceVC : BaseViewController

@property (nonatomic, copy) StringBlock selectBlock;
@end
