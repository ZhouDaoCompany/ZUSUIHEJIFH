//
//  PrivacyTableViewCell.h
//  GovermentTest
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (assign, nonatomic) BOOL isSelected;

@property (assign, nonatomic) NSUInteger indexRow;

@property (strong, nonatomic) NSArray *msgArrays;

@end
