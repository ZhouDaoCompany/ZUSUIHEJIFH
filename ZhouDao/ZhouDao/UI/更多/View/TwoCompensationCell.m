//
//  TwoCompensationCell.m
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TwoCompensationCell.h"

@implementation TwoCompensationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _titLab.textColor = thirdColor;
    _provinceLab.textColor = [UIColor colorWithHexString:@"#999999"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69.4f, kMainScreenWidth, .6f)];
    lineView.backgroundColor = lineColor;
    [self.contentView addSubview:lineView];
}
- (void)setDataModel:(CompensationData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    
    [self loadData];
}
- (void)loadData
{
    _titLab.text = _dataModel.title;
    _provinceLab.text =_dataModel.city;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
