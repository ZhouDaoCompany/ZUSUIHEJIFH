//
//  CommonViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *alertLab;
@property (nonatomic, assign) NSUInteger section;
@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, assign) BOOL isCer;//是否需要显示认证
@end
