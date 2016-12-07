//
//  LPCameraBrowerCell.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LPCameraBrowerCellDelegate <NSObject>

- (void)clickSingleFingerAtScreen;

@end

@interface LPCameraBrowerCell : UICollectionViewCell


@property (nonatomic,   weak) id<LPCameraBrowerCellDelegate>delegate;

-(void)loadPicData:(UIImage *) image;

-(void)recoverSubview;

@end
