//
//  CaseRemindListCell.h
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindData.h"
#import "SWTableViewCell.h"

@interface CaseRemindListCell : SWTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *remindImg;

@property (strong, nonatomic) RemindData *dataModel;
@end
