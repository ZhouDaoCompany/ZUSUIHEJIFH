//
//  SetCollectionViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,assign) NSUInteger section;
@property (nonatomic,assign) NSUInteger row;

@end
