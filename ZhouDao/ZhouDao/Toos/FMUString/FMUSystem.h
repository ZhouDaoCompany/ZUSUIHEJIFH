//
//  FMUSystem.h
//  FMLibrary
//
//  Created by leks on 13-4-24.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//判断是否是iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface FMUSystem : NSObject

+(NSString*)systemVersion;
+(CGFloat)versionFloatValue:(NSString*)versionString;
+(CGFloat)systemVersionFloat;
+ (NSString *)macAddress;
+ (CGFloat)getOSVersion;
+ (BOOL)isIpad;
+ (BOOL)isIphone;

//+(NSString*)fmDeviceId;
@end
