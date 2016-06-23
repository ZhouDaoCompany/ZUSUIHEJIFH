//
//  CaseDetailTabCell.h
//  ZhouDao
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DetaillistModel.h"
@protocol CaseDetailTabCellPro <NSObject>

- (void)ExpandOrCloseWithCell:(UITableViewCell *)aCell;
- (void)otherEvent:(NSUInteger)tag withCell:(UITableViewCell *)aCell;
@end

@interface CaseDetailTabCell : UITableViewCell

@property (nonatomic, weak) id<CaseDetailTabCellPro>delegate;
@property (strong, nonatomic)  UIImageView *headImgView;
@property (strong, nonatomic)  UILabel *titLab;
@property (strong, nonatomic) DetaillistModel *listModel;
@end
