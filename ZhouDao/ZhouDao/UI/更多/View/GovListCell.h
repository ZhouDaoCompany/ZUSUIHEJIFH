//
//  GovListCell.h
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovListmodel.h"

@interface GovListCell : UITableViewCell

@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *telLabel;
@property (strong, nonatomic)  UIImageView *organImage;
@property (strong, nonatomic)  UILabel *addressLabel;

@property (nonatomic, strong) GovListmodel *listModel;

@end
