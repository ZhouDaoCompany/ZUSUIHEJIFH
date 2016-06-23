//
//  PlanTableViewCell.h
//  ZhouDao
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindData.h"
#import "SWTableViewCell.h"

@interface PlanTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *alertLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
//@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) RemindData *model;

@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, copy) NSString *noDayString;
@end
