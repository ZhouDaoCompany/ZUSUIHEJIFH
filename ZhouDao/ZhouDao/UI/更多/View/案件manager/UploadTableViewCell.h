//
//  UploadTableViewCell.h
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UploadTableViewPro;

@interface UploadTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, weak) id<UploadTableViewPro>delegate;
- (void)setUploadImage;//开始上传
- (void)settingUIWithFull:(UIImage *)fullScreenImage withSection:(NSInteger)section;
@end

@protocol UploadTableViewPro <NSObject>

- (void)uploadCompletedRefreshesTheList;

@end