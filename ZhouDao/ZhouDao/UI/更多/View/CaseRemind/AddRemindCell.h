//
//  AddRemindCell.h
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRemindCell : UITableViewCell


@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel     *contentLab;

@property (nonatomic, assign) NSInteger rowIndex;
- (void)settingFrame;

@end
