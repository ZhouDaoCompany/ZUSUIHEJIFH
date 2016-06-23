//
//  GovDetailCell.m
//  ZhouDao
//
//  Created by cqz on 16/5/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovDetailCell.h"

@implementation GovDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _headImgView.contentMode = UIViewContentModeScaleAspectFit;
    _contentLab.textColor = sixColor;
    _rowHeight = 44.f;
    // Initialization code
}
- (void)setDetailIntroductionText:(NSString *)text;{
    _headImgView.hidden = YES;
    _contentLab.hidden = YES;
    
    NSDictionary *attribute = @{NSFontAttributeName:Font_13};
    CGSize size = [text boundingRectWithSize:CGSizeMake(kMainScreenWidth - 30,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _rowHeight = size.height;

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kMainScreenWidth - 30, size.height)];
    lab.font = Font_13;
    lab.textColor = sixColor;
    lab.numberOfLines = 0;
    lab.text = text;
    [self.contentView addSubview:lab];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
