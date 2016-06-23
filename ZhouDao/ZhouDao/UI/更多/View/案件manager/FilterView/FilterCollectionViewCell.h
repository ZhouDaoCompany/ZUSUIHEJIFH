//
//  FilterCollectionViewCell.h
//  UItext
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCollectionViewCell : UICollectionViewCell{
    
    UILabel *titleLab;
}

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic, assign) BOOL isSelected;

@end
