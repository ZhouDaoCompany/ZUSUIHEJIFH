//
//  MoveTopTabViewCell.h
//  MoveTop
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CollectionData.h"
@interface MoveTopTabViewCell : SWTableViewCell

@property (nonatomic,strong)  UILabel *lawNameLab;
@property (nonatomic,strong)  UILabel *unitLab;
@property (nonatomic,strong)  UILabel *dateLab;
@property (nonatomic,assign) NSUInteger moveSection;
@property (nonatomic,strong) UIImageView *zdImgView;
@property (nonatomic,strong) CollectionData *dataModel;

@end
