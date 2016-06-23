//
//  CustomButton.h
//  ZhouDao
//
//  Created by cqz on 16/5/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuLabel;
@interface CustomButton : UIButton
@property (nonatomic, retain)MenuLabel *MenuData;

-(void)SelectdAnimation;
-(void)CancelAnimation;

@end
