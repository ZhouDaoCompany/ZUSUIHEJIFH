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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIImageView *organImage;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) GovListmodel *listModel;

@end
