//
//  HeadTableViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

//- (void)awakeFromNib {
//    // Initialization code
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initUI];
    }
    return self;
}
- (void)initUI
{
//    float width = self.contentView.frame.size.width;
//    float height = self.contentView.frame.size.height;
    
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 56, 56)];
//    _headImgView.image = [UIImage imageNamed:@"mine_head"];
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 28.f;
    //_headImgView.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:_headImgView];
    
    //VIP
    _VIPimgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 57, 15, 15)];
   // _VIPimgView.backgroundColor = [UIColor redColor];
    _VIPimgView.image = [UIImage imageNamed:@"mine_scer"];
    [self.contentView addSubview:_VIPimgView];
    
    //name
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_headImgView) +15, 20, 160, 20)];
    _nameLab.font = Font_16;
    
    [self.contentView addSubview:_nameLab];
    
    //phone
    _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_headImgView)+15, 45, 160, 20)];
    _phoneLab.font = Font_14;
    _phoneLab.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_phoneLab];
}
- (void)reloadNameWithPhone
{
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[PublicFunction ShareInstance].m_user.data.photo] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    
    if ([[PublicFunction ShareInstance].m_user.data.is_certification isEqualToString:@"1"])
    {
//        _VIPimgView.hidden = YES;
        _VIPimgView.image = [UIImage imageNamed:@"mine_noScer"];
    }else{
//        _VIPimgView.hidden = NO;
        _VIPimgView.image = [UIImage imageNamed:@"mine_scer"];
    }

    if ([PublicFunction ShareInstance].m_user.data.name.length == 0) {
        _nameLab.text = @"慧法用户";
    }else{
        _nameLab.text = [PublicFunction ShareInstance].m_user.data.name;
    }
    
    if ([PublicFunction ShareInstance].m_bLogin == YES)
    {
        _phoneLab.text = [QZManager getTheHiddenMobile:[PublicFunction ShareInstance].m_user.data.mobile];
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
