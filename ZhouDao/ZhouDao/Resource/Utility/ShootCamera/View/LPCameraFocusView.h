//
//  LPCameraFocusView.h
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  LPCameraFocusDelegate;

@interface LPCameraFocusView : UIView

@property(strong,nonatomic) id <LPCameraFocusDelegate> delegate;
@end

@protocol LPCameraFocusDelegate <NSObject>

@optional
-(void) cameraFocusOptionsWithPoint:(CGPoint)point;

@end
