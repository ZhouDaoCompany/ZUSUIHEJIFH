//
//  LPCameraBrowerViewController.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPCameraBrowerViewController;

@protocol LPCameraBrowerDataSource <NSObject>

@required
-(NSInteger)zzbrowserPickerPhotoNum:(LPCameraBrowerViewController *)controller;
-(NSArray *)zzbrowserPickerPhotoContent:(LPCameraBrowerViewController *)controller;

@end

@interface LPCameraBrowerViewController : UIViewController

@property (nonatomic,   weak) id <LPCameraBrowerDataSource> delegate;

//滚动到指定位置(滚动到那张图片，通过下面属性)
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)reloadData;

-(void)showIn:(UIViewController *)controller;

@end
