//
//  ImmediatelyVC.h
//  ZhouDao
//
//  Created by cqz on 16/3/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef  NS_ENUM(NSUInteger,CertificationType){
    FromRegister = 0,//注册界面
    FrommMineSetting = 1,//个人设置界面
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ImmediatelyVC : BaseViewController

@property (nonatomic, assign) CertificationType cerType;
@end
