//
//  MBProgressHUD+Tools.m
//  ZhouDao
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MBProgressHUD+Tools.h"

@implementation MBProgressHUD (Tools)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [QZManager getWindow]; //[[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:kGetImage(icon)];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.f];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    kDISPATCH_MAIN_THREAD((^{
        
        [self show:error icon:@"error" view:view];
  
    }));
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    kDISPATCH_MAIN_THREAD((^{
        
        [self show:success icon:@"Checkmark" view:view];
    }));
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view =[QZManager getWindow]; //[[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    kDISPATCH_MAIN_THREAD((^{
        [self hideHUDForView:nil];

        [self showSuccess:success toView:nil];
    }));
}

+ (void)showError:(NSString *)error
{
    kDISPATCH_MAIN_THREAD((^{
        
        [self hideHUDForView:nil];

        [self showError:error toView:nil];
    }));
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [QZManager getWindow];//[[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    kDISPATCH_MAIN_THREAD((^{
        
        [self hideHUDForView:nil];
    }));
}
+ (void)showMBLoadingWithText:(NSString *)textString
{
    kDISPATCH_MAIN_THREAD((^{
        
        [self hideHUDForView:nil];

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[QZManager getWindow] animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
        hud.contentColor = [UIColor whiteColor];
        hud.label.text = textString;// (textString.length == 0)?@"正在加载":textString;
    }));
}
@end
