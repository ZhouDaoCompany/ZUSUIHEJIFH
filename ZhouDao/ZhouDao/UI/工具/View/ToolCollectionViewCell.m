//
//  TollCollectionViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolCollectionViewCell.h"

@implementation ToolCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        self.layer.masksToBounds = YES;
        //        self.layer.cornerRadius = 10.f;
        
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = self.frame.size.width;
//        CGFloat height = self.frame.size.height;
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 21.5, 25, 24)];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImgView];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(_iconImgView) +10.f, 24, width- Orgin_x(_iconImgView) - 10.f, 20)];
        _titleLab.textColor = thirdColor;
//        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_titleLab];
        
    }
    return self;
}
- (void)setModel:(TheContractData *)model
{
    _model = nil;
    _model = model;
    [self loadData];
}
- (void)setBasicModel:(BasicModel *)basicModel
{
    _basicModel = nil;
    _basicModel = basicModel;
    _iconImgView.hidden = NO;
    _titleLab.hidden = NO;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_basicModel.app_icon] placeholderImage:[UIImage imageNamed:@"law_placeHold"]];
    _titleLab.text = _basicModel.title;
    NSDictionary *attribute = @{NSFontAttributeName:Font_15};
    float width = self.bounds.size.width;
    CGSize size = [_titleLab.text boundingRectWithSize:CGSizeMake(width-60,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _titleLab.frame =CGRectMake(50.f, 24, size.width, size.height);
}
- (void)loadData
{
    _iconImgView.hidden = NO;
    _titleLab.hidden = NO;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.pic] placeholderImage:[UIImage imageNamed:@"law_placeHold"]];
    _titleLab.text = _model.ctname;
    NSDictionary *attribute = @{NSFontAttributeName:Font_15};
    float width = self.bounds.size.width;
    CGSize size = [_titleLab.text boundingRectWithSize:CGSizeMake(width-60,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    _titleLab.frame =CGRectMake(50.f, 24, size.width, size.height);
}

@end
