//
//  GovListCell.m
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovListCell.h"

@implementation GovListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _nameLabel.font = Font_16;
    _telLabel.font  = Font_13;
    _addressLabel.font= Font_13;
    
    _nameLabel.textColor = thirdColor;
    _telLabel.textColor = sixColor;
    _addressLabel.textColor = sixColor;
    
    _addressLabel.numberOfLines = 1;
    _organImage.backgroundColor = [UIColor clearColor];

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
    [_organImage sd_setImageWithURL:[NSURL URLWithString:_listModel.photo] placeholderImage:[UIImage imageNamed:@"gov_tupian"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
