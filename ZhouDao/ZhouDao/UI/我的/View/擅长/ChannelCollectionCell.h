//
//  ChannelCollectionCell.h
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//


#import <UIKit/UIKit.h>
//@protocol ChannelCollectionPro;


@interface ChannelCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *delImgView;
//@property (nonatomic, weak)   id<ChannelCollectionPro>delegate;
@end

//@protocol ChannelCollectionPro <NSObject>
//
//- (void)getChannelCellPath:(ChannelCollectionCell *)cell;
//
//@end