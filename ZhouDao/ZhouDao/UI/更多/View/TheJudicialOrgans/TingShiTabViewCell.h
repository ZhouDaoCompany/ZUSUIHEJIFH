//
//  TingShiTabViewCell.h
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"

@interface TingShiTabViewCell : UITableViewCell

@property (nonatomic, strong) CaseTextField *textField;

- (void)settingUIWithMutableArrays:(NSMutableArray *)arrays
                       withSection:(NSUInteger)section
                      withIndexRow:(NSUInteger)row;
@end
