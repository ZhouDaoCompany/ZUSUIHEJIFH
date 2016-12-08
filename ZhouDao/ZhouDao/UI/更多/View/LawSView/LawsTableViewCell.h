//
//  LawsTableViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LawsDataModel.h"
@interface LawsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;

@property (strong, nonatomic)  UILabel *dateLab;
@property (strong ,nonatomic) LawsDataModel *dataModel;
@end
