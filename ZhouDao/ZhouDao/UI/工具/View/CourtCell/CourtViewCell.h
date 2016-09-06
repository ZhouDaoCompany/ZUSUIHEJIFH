//
//  CourtViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"
@protocol  CourtViewDelegate;

@interface CourtViewCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;
@property (weak, nonatomic)   id<CourtViewDelegate>delegate;

- (void)settingUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;
@end

@protocol  CourtViewDelegate <NSObject>

- (void)fullORHalf:(NSInteger)index withCell:(CourtViewCell *)cell;
- (void)isInvolvedInTheAmount:(NSInteger)index  withCell:(CourtViewCell *)cell;
@end