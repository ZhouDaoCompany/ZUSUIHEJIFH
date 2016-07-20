//
//  GovListCell.m
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovListCell.h"

@implementation GovListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.telLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.organImage];

    }
    return self;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 21, 210, 15)];
        _nameLabel.font = Font_16;
        _nameLabel.textColor = thirdColor;
    }
    return _nameLabel;
}
- (UILabel *)telLabel
{
    if (!_telLabel) {
        _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 41, 210, 15)];
        _telLabel.font  = Font_13;
        _telLabel.textColor = sixColor;
    }
    return _telLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 58, kMainScreenWidth - 100, 15)];
        _addressLabel.font  = Font_13;
        _addressLabel.textColor = sixColor;
        _addressLabel.numberOfLines = 1;
    }
    return _addressLabel;
}
- (UIImageView *)organImage
{
    if (!_organImage) {
        _organImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 73, 60)];
        _organImage.image = [UIImage imageNamed:@"gov_tupian"];
        _organImage.userInteractionEnabled = YES;
    }
    return _organImage;
}
-(void)setListModel:(GovListmodel *)listModel
{
    _listModel = nil;
    _listModel = listModel;
    
    [self loadData];
}
- (void)loadData{
    _nameLabel.text = _listModel.name;
    _telLabel.text  =[NSString stringWithFormat:@"电话:%@",_listModel.phone];
    _addressLabel.text =[NSString stringWithFormat:@"地址:%@",_listModel.address];
//    [_organImage sd_setImageWithURL:[NSURL URLWithString:_listModel.photo] placeholderImage:[UIImage imageNamed:@"gov_tupian"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
