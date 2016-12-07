//
//  LPCameraController.m
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LPCameraController.h"
#import "LPCameraPickerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LPCameraController()

@property (strong,nonatomic) LPCameraPickerViewController *cameraPickerController;

@end

@implementation LPCameraController

-(LPCameraPickerViewController *)cameraPickerController
{
    if (!_cameraPickerController) {
        _cameraPickerController = [[LPCameraPickerViewController alloc]init];
    }
    return _cameraPickerController;
}

-(void)showIn:(UIViewController *)controller result:(LPCameraResult)result {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        //相机进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showController:controller result:result];
                });
            }
        }];
    }else if (status == AVAuthorizationStatusAuthorized){
        [self showController:controller result:result];
    }else if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        [self showAlertViewToController:controller];
    }
}

-(void)showController:(UIViewController *)controller result:(LPCameraResult)result {
    
    self.cameraPickerController.CameraResult    = result;
    //设置连拍最大张数
    self.cameraPickerController.takePhotoOfMax  = self.takePhotoOfMax;
    //设置返回图片类型
    self.cameraPickerController.isSavelocal     = self.isSaveLocal;
    self.cameraPickerController.themeColor      = self.themeColor;
    [controller presentViewController:self.cameraPickerController animated:YES completion:nil];
}

-(void)showAlertViewToController:(UIViewController *)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    if (CurrentSystemVersion >= 8.0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请在iPhone的“设置->隐私->照片”开启%@访问你的相机",app_Name] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去设置》" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];

        [alert addAction:action1];
        [alert addAction:action2];
        [controller presentViewController:alert animated:YES completion:nil];

    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在iPhone的“设置->隐私->照片”开启%@访问你的相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置》", nil];
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
