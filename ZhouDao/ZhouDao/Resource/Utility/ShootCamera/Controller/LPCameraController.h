//
//  LPCameraController.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^LPCameraResult)(id responseObject);

@interface LPCameraController : NSObject

/*
 *   设置是否将拍完过后的照片直接保存到相册
 */
@property (assign, nonatomic) BOOL isSaveLocal;

/*
 *   设置最多连拍张数
 */
@property (assign, nonatomic) NSInteger takePhotoOfMax;


/*
 *   设置相机页面主题颜色，默认为黑色
 */
@property (strong, nonatomic) UIColor *themeColor;

-(void)showIn:(UIViewController *)controller result:(LPCameraResult)result;

@end
