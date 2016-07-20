//
//  HomeTableViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicModel.h"
#import "HistoryModel.h"

@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *headImgView;
@property (strong, nonatomic)  UILabel *titlab;
@property (strong, nonatomic)  UILabel *contentLab;

@property (strong, nonatomic) BasicModel *mdoel;
@property (strong, nonatomic) HistoryModel *historyModel;

@end
