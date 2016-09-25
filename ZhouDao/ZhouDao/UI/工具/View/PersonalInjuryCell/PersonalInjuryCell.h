//
//  PersonalInjuryCell.h
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"
@protocol  PersonalInjuryDelegate;

@interface PersonalInjuryCell : UITableViewCell

@property (weak, nonatomic)   id<PersonalInjuryDelegate>delegate;
@property (strong, nonatomic) CaseTextField *textField;

//结果页
- (void)settingPersonalCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays withDelegate:(id<PersonalInjuryDelegate>)delegate;

//详情页
- (void)settingDetailViewUIWithSection:(NSInteger)section withRow:(NSInteger)row WithMutableArrays:(NSMutableArray *)arrays;
@end
@protocol  PersonalInjuryDelegate <NSObject>

- (void)optionEventWithCell:(PersonalInjuryCell *)cell withSelecIndex:(NSInteger)index;
@end
