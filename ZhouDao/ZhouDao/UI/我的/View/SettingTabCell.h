//
//  SettingTabCell.h
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTabCell : UITableViewCell

@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic) UILabel *addresslab;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger section;
@property (nonatomic, strong) UIImageView *headImg;
@property (strong, nonatomic) UISwitch *switchButton;

- (void)settingUI;
@end
