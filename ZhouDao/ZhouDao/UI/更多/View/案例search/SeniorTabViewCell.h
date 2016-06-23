//
//  SeniorTabViewCell.h
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeniorTabViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UIImageView *imgview1;

@property (nonatomic, assign) NSInteger rowIndex;

@end
