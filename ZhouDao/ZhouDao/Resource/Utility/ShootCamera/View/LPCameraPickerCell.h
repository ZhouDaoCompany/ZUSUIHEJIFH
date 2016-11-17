//
//  LPCameraPickerCell.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPCameraPickerCell : UICollectionViewCell


@property(strong,nonatomic) UIImageView *pics;
@property(strong,nonatomic) UIButton *removeBtn;

@property(copy  ,nonatomic) void(^deleteBlock)();

-(void)loadPhotoDatas:(UIImage *)image;

@end
