//
//  TheCaseCollectionCell.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#define cellWidth ([UIScreen mainScreen].bounds.size.width- 90.f)/3.f

#import "TheCaseCollectionCell.h"

#define PictureName  [UIScreen mainScreen].bounds.size.height>667?@"case_juanzong6p":([UIScreen mainScreen].bounds.size.height >568?@"case_juanzong":@"case_juanzong4s")
@implementation TheCaseCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        _picView = [[UIImageView alloc] init];
        _picView.contentMode =UIViewContentModeScaleAspectFill;
        _picView.clipsToBounds = YES;
        _picView.image = [UIImage imageNamed:PictureName];
        [self.contentView addSubview:_picView];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = thirdColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.numberOfLines = 0;
        _titleLab.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_titleLab];
//        _titleLab.text = @"中南集团劳动纠纷案件";
    }
    return self;
}
- (void)setDataModel:(ManagerData *)dataModel
{
    _dataModel = nil;
    _dataModel = dataModel;
    
    _titleLab.text = _dataModel.name;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    float y =self.contentView.bounds.size.height-60.f;
    
    _picView.frame = CGRectMake(0,20.f ,self.contentView.bounds.size.width, y);
    _titleLab.frame = CGRectMake(0.f,Orgin_y(_picView)+3.5f , self.contentView.bounds.size.width, 40.f);
}
@end
