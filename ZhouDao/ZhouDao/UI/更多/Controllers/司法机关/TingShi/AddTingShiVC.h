//
//  AddTingShiVC.h
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Courtroom_base.h"

typedef NS_ENUM(NSInteger, AddTingShiType)
{
    EditTingShi = 0,//编辑庭室
    AddTingShi =1,//添加庭室
};

@interface AddTingShiVC : BaseViewController


- (instancetype)initWithJidString:(NSString *)jidString withType:(AddTingShiType)type withCourtroom_base:(Courtroom_base *)baseModel;
@end
