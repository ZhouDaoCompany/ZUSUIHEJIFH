//
//  MoveTopTabViewCell.m
//  MoveTop
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MoveTopTabViewCell.h"

@implementation MoveTopTabViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}
#pragma mark - private methods
- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.lawNameLab];
    [self.contentView addSubview:self.unitLab];
    [self.contentView addSubview:self.dateLab];
    [self.contentView addSubview:self.zdImgView];

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
#pragma mark - setter and getter
- (UILabel *)lawNameLab
{
    if (!_lawNameLab) {
        
        _lawNameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 60, 20)];
        _lawNameLab.textColor = hexColor(333333);
        _lawNameLab.font = Font_15;
        _lawNameLab.numberOfLines = 1;
    }
    return _lawNameLab;
}
- (UILabel *)unitLab
{
    if (!_unitLab) {
        
        _unitLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kMainScreenWidth - 148, 20)];
        _unitLab.textColor = hexColor(666666);
        _unitLab.font = Font_12;
        _unitLab.numberOfLines = 1;
    }
    return _unitLab;
}
- (UILabel *)dateLab
{
    if (!_dateLab) {
        
        _dateLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_y(_unitLab) +15, 40, kMainScreenWidth - Orgin_y(_unitLab) - 30, 20)];
        _dateLab.textColor = hexColor(666666);
        _dateLab.font = Font_12;
        _dateLab.textAlignment = NSTextAlignmentRight;
        _dateLab.numberOfLines = 1;
    }
    return _dateLab;
}
- (UIImageView *)zdImgView
{
    if (!_zdImgView) {
        
        _zdImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _zdImgView.backgroundColor = [UIColor clearColor];
    }
    return _zdImgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
