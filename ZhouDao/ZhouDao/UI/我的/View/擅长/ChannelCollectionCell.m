//
//  ChannelCollectionCell.m
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import "ChannelCollectionCell.h"

@implementation ChannelCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:self.titleLab];
        
        [self.contentView addSubview:self.delImgView];
    }
    return self;
}

- (UIImageView *)delImgView
{
    if (!_delImgView) {
        _delImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width -10.f, -2.f, 12, 12)];
        _delImgView.userInteractionEnabled = YES;
        _delImgView.image = [UIImage imageNamed:@"mine_delete"];
    }
    return _delImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLab.textColor = [UIColor darkGrayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.numberOfLines = 1;
        _titleLab.font = [UIFont systemFontOfSize:12.f];
    }
    return _titleLab;
}

@end
