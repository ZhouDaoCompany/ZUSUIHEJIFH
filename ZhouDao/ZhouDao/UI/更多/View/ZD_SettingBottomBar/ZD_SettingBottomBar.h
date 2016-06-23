//
//  ZD_SettingBottomBar.h
//  ZhouDao
//
//  Created by cqz on 16/3/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ZD_SettingBottomBarPro <NSObject>

- (void)getbackgroundColor:(NSString *)viewColor WithBackViewColor:(NSString *)backViewColor WithSection:(NSUInteger)section WithRow:(NSUInteger)row;

- (void)getFontSize:(NSString *)fontSize WithSection:(NSUInteger)section WithRow:(NSUInteger)row;

@end


@interface ZD_SettingBottomBar : UIView

@property (nonatomic, weak) id<ZD_SettingBottomBarPro>delegate;

@end
