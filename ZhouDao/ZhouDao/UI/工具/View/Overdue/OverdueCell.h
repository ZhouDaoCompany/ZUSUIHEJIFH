//
//  OverdueCell.h
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"

@interface OverdueCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;

- (void)settingOverdueCellUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;

@end
