//
//  TwoCompensationCell.h
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompensationData.h"
@interface TwoCompensationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *provinceLab;

@property (nonatomic, strong) CompensationData *dataModel;
@end
