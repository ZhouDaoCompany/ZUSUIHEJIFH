//
//  TingShiListCell.h
//  ZhouDao
//
//  Created by apple on 16/12/9.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Courtroom_base.h"

@interface TingShiListCell : UITableViewCell

- (void)setAddressUIWithIndexRow:(NSUInteger)indexRow withCourtroom_base:(Courtroom_base *)baseModel;

- (void)setContactUIWithIndexRow:(NSUInteger)indexRow withCourtroom_base:(Courtroom_base *)baseModel;

@end
