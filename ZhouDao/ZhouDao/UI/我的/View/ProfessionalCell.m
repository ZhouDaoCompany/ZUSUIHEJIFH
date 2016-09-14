//
//  ProfessionalCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ProfessionalCell.h"
#import "AdvantagesModel.h"

@implementation ProfessionalCell

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
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13.5f, 17, 17)];
//    _iconImgView.backgroundColor = [UIColor redColor];
//    _iconImgView.layer.masksToBounds = YES;
//    _iconImgView.layer.cornerRadius = 12;
    _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImgView.image = [UIImage imageNamed:@"mine_good"];
    [self.contentView addSubview:_iconImgView];
    
    //name
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +15, 12, 120, 20)];
    _nameLab.font = Font_16;
    _nameLab.text = @"我的擅长";
    [self.contentView addSubview:_nameLab];
    
    UIImageView *jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 24, 10, 9, 15)];
    jiantouimg.userInteractionEnabled = YES;
    jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
    [self.contentView addSubview:jiantouimg];
    
}

- (void)setDomainArrays:(NSMutableArray *)domainArrays
{
    _domainArrays = [NSMutableArray array];
    _domainArrays = domainArrays;
    
    
    for (NSUInteger j =6000; j<6012; j++)
    {
        UILabel *lab = (UILabel *)[self.contentView viewWithTag:j];
        [lab removeFromSuperview];
    }
    float width = (kMainScreenWidth -75.f)/4.f;
    //擅长  40
    for (NSUInteger i = 0 ; i < _domainArrays.count;  i ++)
    {
        AdvantagesModel *model = _domainArrays[i];
        UILabel *goodLab = [[UILabel alloc] init];
        goodLab.frame = CGRectMake( 15*(i%4 + 1) + width * (i%4), 25 +15*(i/4 + 1) + 30 *(i/4) , width, 30);
        goodLab.backgroundColor = [UIColor whiteColor];
        goodLab.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
        goodLab.layer.borderWidth = .5f;
        goodLab.font = Font_13;
        goodLab.tag = 6000+i;
        goodLab.textAlignment = NSTextAlignmentCenter;
        goodLab.text = model.sname;
        [self.contentView addSubview:goodLab];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
