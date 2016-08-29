//
//  CourtViewCell.h
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"

@interface CourtViewCell : UITableViewCell

@property (strong, nonatomic) CaseTextField *textField;

- (void)settingUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;
@end
