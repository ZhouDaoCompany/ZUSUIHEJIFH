//
//  RiQiViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"
@protocol  RiQiViewCellDelegate;

@interface RiQiViewCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;
@property (weak, nonatomic)   id<RiQiViewCellDelegate>delegate;

- (void)settingRiQiCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end
@protocol  RiQiViewCellDelegate <NSObject>

- (void)optionRiQiEventWithCell:(RiQiViewCell *)cell withSelecIndex:(NSInteger)index;
@end
