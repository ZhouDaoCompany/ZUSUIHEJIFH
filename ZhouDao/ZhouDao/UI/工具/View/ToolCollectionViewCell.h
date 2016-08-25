//
//  TollCollectionViewCell.h
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheContractData.h"
#import "BasicModel.h"
@interface ToolCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) TheContractData *model;
@property (nonatomic, strong) BasicModel *basicModel;

- (void)theNewCalculatorWithName:(NSString *)name;
@end
