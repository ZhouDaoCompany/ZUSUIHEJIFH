//
//  GovCollectionViewCell.m
//  ZhouDao
//
//  Created by cqz on 16/4/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#define govWidth     [UIScreen mainScreen].bounds.size.width/4.f -11.f

#import "GovCollectionViewCell.h"

@implementation GovCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((govWidth-13)/2.f, 21.5, 23, 26)];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImgView];

        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = THIRDCOLOR;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_titleLab];
    }
    return self;
}
- (void)setDataModel:(GovData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    _titleLab.text = _dataModel.ctname;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] placeholderImage:[UIImage imageNamed:@"law_placeHold"]];
    NSDictionary *attribute = @{NSFontAttributeName:Font_13};
    CGSize size = [_dataModel.ctname boundingRectWithSize:CGSizeMake(govWidth,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect dateFrame = CGRectMake(5, Orgin_y(_iconImgView) +7.f, govWidth, size.height);
    _titleLab.frame = dateFrame;
}
- (void)setExampleModel:(ExampleData *)exampleModel
{
    _exampleModel = nil;
    _exampleModel = exampleModel;
    _titleLab.text = _exampleModel.name;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_exampleModel.pic] placeholderImage:nil];

    NSDictionary *attribute = @{NSFontAttributeName:Font_14};
    CGSize size = [_exampleModel.name boundingRectWithSize:CGSizeMake(govWidth,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect dateFrame = CGRectMake(5, Orgin_y(_iconImgView) +7.f, govWidth, size.height);
    _titleLab.frame = dateFrame;
}
@end
