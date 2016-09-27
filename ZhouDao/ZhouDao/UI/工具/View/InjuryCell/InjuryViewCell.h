//
//  InjuryViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"

@interface InjuryViewCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;

- (void)settingInjuryViewCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;
- (void)settingUIDetailWithDictionary:(NSDictionary *)dictionary;

@end
