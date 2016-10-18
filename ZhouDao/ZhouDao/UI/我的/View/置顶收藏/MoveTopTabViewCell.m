//
//  MoveTopTabViewCell.m
//  MoveTop
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MoveTopTabViewCell.h"

@implementation MoveTopTabViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _zdImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _zdImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_zdImgView];
    
}
- (void)setDataModel:(CollectionData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    [self loadData];
}
- (void)loadData{
    _lawNameLab.text = _dataModel.article_title;
    _unitLab.text = _dataModel.article_subtitle;
    _dateLab.text = [QZManager changeTimeMethods:[_dataModel.article_time doubleValue] withType:@"yyyy-MM-dd"];
}
- (void)setMoveSection:(NSUInteger)moveSection
{
    _moveSection = moveSection;
    
    if (_moveSection == 1)
    {
        _zdImgView.image = nil;//[UIImage imageNamed:@""];
//        [_zdImgView removeFromSuperview];
//        _zdImgView = nil;
    }else {
        _zdImgView.image = [UIImage imageNamed:@"mine_moveTop"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
