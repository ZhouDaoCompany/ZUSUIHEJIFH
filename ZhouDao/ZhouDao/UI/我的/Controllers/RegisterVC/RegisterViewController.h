//
//  RegisterViewController.h
//  ZhouDao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "JKCountDownButton.h"

typedef void(^RegisterBlock)(NSString *,NSString *);

@interface RegisterViewController : BaseViewController
@property (strong, nonatomic)  UIImageView *logoImgView;
@property (strong, nonatomic)  UIView *bottomView;
@property (strong, nonatomic)  UITextField *phoneText;
@property (strong, nonatomic)  UITextField *codeText;
@property (strong, nonatomic)  UITextField *keyText;
@property (strong,nonatomic) UILabel *professionalLab;
@property (strong,nonatomic) UILabel *placeLab;

@property (strong, nonatomic)  JKCountDownButton *getCodeBtn;
@property (strong, nonatomic)  UIImageView *eyeImgView;
@property (strong, nonatomic)  UIButton *registerBtn;
@property (strong, nonatomic)  UIButton *goLoginBtn;
@property (nonatomic, copy) ZDBlock regiestCloseBlock;
@property (nonatomic,copy) RegisterBlock successRegisterBlock;

@end
