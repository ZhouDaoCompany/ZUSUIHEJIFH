//
//  LPCameraPickerViewController.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^codeBlock)();

@interface LPCameraPickerViewController : UIViewController

@property (nonatomic, assign) BOOL isSavelocal;

@property (nonatomic, assign) NSInteger takePhotoOfMax;

@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic,   copy) void (^CameraResult)(id responseObject);

@end
