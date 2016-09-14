//
//  TheCaseCollectionCell.h
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerData.h"
@interface TheCaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) ManagerData *dataModel;
@end
