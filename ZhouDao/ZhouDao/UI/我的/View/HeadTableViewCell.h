//
//  HeadTableViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *VIPimgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;

- (void)reloadNameWithPhone;
@end
