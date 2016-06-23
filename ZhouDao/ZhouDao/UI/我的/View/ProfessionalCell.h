//
//  ProfessionalCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionalCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic,strong) NSMutableArray *domainArrays;//擅长领域
@property (nonatomic, assign) CGFloat cellHeight;//cell高度
@end
