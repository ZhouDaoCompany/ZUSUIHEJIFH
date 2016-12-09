//
//  GovDetailCell.h
//  ZhouDao
//
//  Created by cqz on 16/5/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GovListmodel.h"
@interface GovDetailCell : UITableViewCell

@property (nonatomic, assign) float rowHeight;

//简介
- (void)setDetailIntroductionText:(NSString *)text;

//司法机关图片
- (void)setGovermentPictureUI:(GovListmodel *)model;

//地址电话
- (void)SetPhoneNumberAndAddress:(GovListmodel *)model withIndexRow:(NSUInteger)indexRow;

@end

