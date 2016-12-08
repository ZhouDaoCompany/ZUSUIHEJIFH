//
//  GovCollectionViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/4/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovData.h"
#import "ExampleData.h"
@interface GovCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic, strong) GovData *dataModel;
@property (nonatomic, strong) ExampleData *exampleModel;

@end
