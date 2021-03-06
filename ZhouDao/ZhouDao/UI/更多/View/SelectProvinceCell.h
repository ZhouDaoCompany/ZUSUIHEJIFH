//
//  SelectProvinceCell.h
//  ZhouDao
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectProvinceCellPro;
@interface SelectProvinceCell : UITableViewCell


@property (weak, nonatomic) id<SelectProvinceCellPro>delegate;
@property (strong, nonatomic) UIView *lineView;
@property (nonatomic, assign) BOOL isCity;//是否是城市

- (void)setOtherCitySelect:(NSString *)name wihSection:(NSInteger)section;
@end

@protocol SelectProvinceCellPro <NSObject>

- (void)getSeletyCityName:(NSString *)provinceName;

@end
