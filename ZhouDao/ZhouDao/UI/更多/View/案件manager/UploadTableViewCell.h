//
//  UploadTableViewCell.h
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UploadTableViewPro;

#import "SWTableViewCell.h"


@interface UploadTableViewCell : SWTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, copy) NSString *caseId;//案件唯一id  cid

@property (nonatomic, weak) id<UploadTableViewPro> uploadDelegate;

- (void)setUploadImage;//开始上传
- (void)settingUIWithDictionary:(NSDictionary *)assetDictionary withSection:(NSInteger)section withRow:(NSInteger)row;
@end

@protocol UploadTableViewPro <NSObject>

- (void)uploadCompletedRefreshesTheListwithRow:(NSInteger)row;

@end