//
//  CompensationTabCell.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CompensationTabCell.h"

@implementation CompensationTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titleLab.textColor = THIRDCOLOR;
    _DetailImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 67.4f, kMainScreenWidth, .6f)];
    lineView.backgroundColor = LINECOLOR;
    [self.contentView addSubview:lineView];

}
//- (void)setDetailImgView:(UIImageView *)DetailImgView
//{
//    _DetailImgView = nil;
//    _DetailImgView = DetailImgView;
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
