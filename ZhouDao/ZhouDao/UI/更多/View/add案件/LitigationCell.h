//
//  LitigationCell.h
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"

@interface LitigationCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) CaseTextField *textField;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UIImageView *imgview1;
@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) BOOL isEdit;

- (void)settingFrame;

@end
