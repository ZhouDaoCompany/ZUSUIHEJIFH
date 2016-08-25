//
//  CommonViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CommonViewCell.h"

@interface CommonViewCell()

@property (nonatomic, strong) UIView *lineView;
@end

@implementation CommonViewCell

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
    float width = kMainScreenWidth;//self.contentView.frame.size.width;

    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5f, 17, 17)];
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImgView];
    
    //name
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +15, 12, 120, 20)];
    _nameLab.font = Font_16;
    [self.contentView addSubview:_nameLab];
    
    //alert
    _alertLab = [[UILabel alloc] initWithFrame:CGRectMake(width - 105, 12, 70, 20)];
    _alertLab.font = Font_12;
    _alertLab.textColor = [UIColor lightGrayColor];
    _alertLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_alertLab];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LINECOLOR;
    [self.contentView addSubview:_lineView];
    
}
- (void)setSection:(NSUInteger)section
{
    _section = section;
}
- (void)setRow:(NSUInteger)row
{
    _row = row;
    
    if (_isCer == YES)
    {
        [self loadData];
    }else {
        [self loadDataCer];
    }
    
    
}
- (void)loadData{
    if (_section == 1) {
        
        if ([[PublicFunction ShareInstance].m_user.data.is_certification isEqualToString:@"1"])
        {
            _alertLab.text = @"未认证";
            
        }else{
            _alertLab.text = @"已认证";
        }
        
        _nameLab.text = @"我的认证";
        _iconImgView.image = [UIImage imageNamed:@"mine_cer"];
        
    }else if (_section == 3){
        _row ==0?[_nameLab setText:@"我的收藏"]:[_nameLab setText:@"我的日程"];
        _row ==0 ?[_iconImgView setImage:[UIImage imageNamed:@"mine_collection"]]:[_iconImgView setImage:[UIImage imageNamed:@"mine_calendar"]];
        _row ==0?[_lineView setFrame:CGRectMake(0, 43.5, kMainScreenWidth, .5f)]:[_lineView setFrame:CGRectMake(0, 0, 0, 0)];
    }else if (_section == 5){
        _row ==0?[_nameLab setText:@"意见反馈"]:[_nameLab setText:@"关于周道"];
        _row ==0 ?[_iconImgView setImage:[UIImage imageNamed:@"mine_recommend"]]:[_iconImgView setImage:[UIImage imageNamed:@"mine_about"]];
        _row ==0?[_lineView setFrame:CGRectMake(0, 43.5, kMainScreenWidth, .5f)]:[_lineView setFrame:CGRectMake(0, 0, 0, 0)];
        
    }else{
        _nameLab.text = @"案件整理";
        _iconImgView.image = [UIImage imageNamed:@"mine_manager"];
        
    }
}
- (void)loadDataCer{
    if (_section == 2){
        _row ==0?[_nameLab setText:@"我的收藏"]:[_nameLab setText:@"我的日程"];
        _row ==0 ?[_iconImgView setImage:[UIImage imageNamed:@"mine_collection"]]:[_iconImgView setImage:[UIImage imageNamed:@"mine_calendar"]];
        _row ==0?[_lineView setFrame:CGRectMake(0, 43.5, kMainScreenWidth, .5f)]:[_lineView setFrame:CGRectMake(0, 0, 0, 0)];
    }else if (_section == 4){
        _row ==0?[_nameLab setText:@"意见反馈"]:[_nameLab setText:@"关于周道"];
        _row ==0 ?[_iconImgView setImage:[UIImage imageNamed:@"mine_recommend"]]:[_iconImgView setImage:[UIImage imageNamed:@"mine_about"]];
        _row ==0?[_lineView setFrame:CGRectMake(0, 43.5, kMainScreenWidth, .5f)]:[_lineView setFrame:CGRectMake(0, 0, 0, 0)];
        
    }else{
        _nameLab.text = @"案件整理";
        _iconImgView.image = [UIImage imageNamed:@"mine_manager"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
