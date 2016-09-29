//
//  LawyerFeesCell.h
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTextField.h"
@protocol  LawyerFeesCellPro;

@interface LawyerFeesCell : UITableViewCell

@property (weak, nonatomic)   id<LawyerFeesCellPro>delegate;
@property (strong, nonatomic) CaseTextField *textField;
@property (strong, nonatomic) UILabel *titleLab;

//@property (strong, nonatomic) NSMutableArray *titleArrays;//标题数组

- (void)settingUIWithSection:(NSInteger)section withRow:(NSInteger)row withNSMutableArray:(NSMutableArray *)arrays;
@end
@protocol  LawyerFeesCellPro <NSObject>

- (void)aboutProperty:(NSInteger)index;

@end
