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
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 10.f;
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor darkGrayColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.numberOfLines = 1;
        _titleLab.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_titleLab];
        
        _delImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width -8.f, -4, 12, 12)];
        _delImgView.userInteractionEnabled = YES;
        _delImgView.image = [UIImage imageNamed:@"mine_delete"];
        [self.contentView addSubview:_delImgView];
    }
    return self;
}
- (void)layoutSubviews{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    _titleLab.frame = CGRectMake(0, 0,width , height);
}

@end
