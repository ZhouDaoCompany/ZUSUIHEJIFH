
//
//  VoiceManager.m
//  BusPlatform
//
//  Created by 黄维筱 on 15/3/23.
//  Copyright (c) 2015年 Teamo. All rights reserved.
//

#import "VoiceManager.h"
#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "PopupView.h"

@implementation VoiceManager

static VoiceManager *instance = nil;

+(VoiceManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       instance = [[VoiceManager alloc]init];
    });
    return instance;
}

-(void)setPropertysWithView:(UIView *)view
{
    _popView = [[PopupView alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popView.ParentView = view;
    _subView  =view;
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:CGPointMake(kMainScreenWidth/2, kMainScreenHeight/2)];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;

}

-(void)startListenning
{
    UIWindow *mainWindow = [UIApplication sharedApplication].windows[0];
    DLog(@"%@",mainWindow.rootViewController);
    [mainWindow makeKeyAndVisible];

    
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
}

//成功的回调方法
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    [_delegate sucessReturn:resultArray isLast:isLast];
        [_iflyRecognizerView cancel];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    //    [self.view addSubview:_popView];
    
    //    [_popView setText:@"识别结束"];
    [_delegate errorReturn:error];
    
    DLog(@"errorCode:%d",[error errorCode]);
    if ([error errorCode] !=0) {
        [_subView addSubview:_popView];
        [_popView  setText:@"未识别"];
    }
}


-(void)cancel
{
    [_iflyRecognizerView cancel];
}

-(void)clearSelf
{
    [_iflyRecognizerView cancel];
    [_iflyRecognizerView setDelegate:nil];
    [self.iflyRecognizerView removeFromSuperview];
    [_popView.ParentView removeFromSuperview];
    [_popView removeFromSuperview];
    [_subView removeFromSuperview];
    self.iflyRecognizerView  = nil;
    _subView  =nil;
    _popView.ParentView = nil;
     _popView = nil;
}

@end
