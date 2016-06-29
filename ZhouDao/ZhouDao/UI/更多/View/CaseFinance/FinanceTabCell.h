//
//  FinanceTabCell.h
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceTabCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *deviceLabel;
@property (nonatomic, strong) UIImageView *imgview1;

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger currentBtnTag;

@end
