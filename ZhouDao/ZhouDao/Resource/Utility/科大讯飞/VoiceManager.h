//
//  VoiceManager.h
//  BusPlatform
//
//  Created by 黄维筱 on 15/3/23.
//  Copyright (c) 2015年 Teamo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import <iflyMSC/IFlySpeechError.h>

@class IFlyRecognizerView;
@class PopupView;

@protocol VoiceDelegate <NSObject>

/** 识别结果回调方法
 @param resultArray 结果列表
 @param isLast YES 表示最后一个，NO表示后面还有结果
 */
-(void)sucessReturn:(NSArray *)resultArray isLast:(BOOL)isLast;

/** 识别结束回调方法
 @param error 识别错误
 */
-(void)errorReturn:(IFlySpeechError *)error;

@end


/**
 有UI语音识别demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@interface VoiceManager : NSObject<IFlyRecognizerViewDelegate>

//带界面的听写识别对象
@property (nonatomic,strong) IFlyRecognizerView * iflyRecognizerView;

@property (nonatomic,strong) PopupView          * popView;

@property (nonatomic,strong) id<VoiceDelegate>   delegate;

@property (nonatomic,strong) UIView             *subView;

+(VoiceManager *)shareInstance;

-(void)setPropertysWithView:(UIView *)view;

-(void)startListenning;

-(void)cancel;

-(void)clearSelf;
@end
