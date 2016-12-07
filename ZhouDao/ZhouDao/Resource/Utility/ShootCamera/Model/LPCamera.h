//
//  LPCamera.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LPCamera : NSObject

/**
 照片
 */
@property (nonatomic, strong) UIImage *image;

/**
 照片保存到相册中的时间
 */
@property (nonatomic, copy)   NSDate *createDate;

@end
