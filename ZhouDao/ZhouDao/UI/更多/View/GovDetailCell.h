//
//  GovDetailCell.h
//  ZhouDao
//
//  Created by cqz on 16/5/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GovDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, assign) float rowHeight;
- (void)setDetailIntroductionText:(NSString *)text;
@end

