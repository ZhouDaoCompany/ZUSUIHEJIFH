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

@property (weak, nonatomic) IBOutlet UILabel *lawNameLab;
@property (weak, nonatomic) IBOutlet UILabel *unitLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (nonatomic,assign) NSUInteger moveSection;
@property (nonatomic,strong) UIImageView *zdImgView;
@property (nonatomic,strong) CollectionData *dataModel;

@end
