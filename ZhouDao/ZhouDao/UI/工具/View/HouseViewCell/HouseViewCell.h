//
//  HouseViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"
@protocol  HouseViewDelegate;

@interface HouseViewCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;
@property (weak, nonatomic)   id<HouseViewDelegate>delegate;

- (void)settingHouseCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end
@protocol  HouseViewDelegate <NSObject>

- (void)optionEvent:(NSInteger)section withCell:(HouseViewCell *)cell;
@end