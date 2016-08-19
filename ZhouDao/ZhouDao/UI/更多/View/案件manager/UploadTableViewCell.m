//
//  UploadTableViewCell.m
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "UploadTableViewCell.h"
#import "JX_GCDTimerManager.h"
#import "ProgressBarView.h"

@interface UploadTableViewCell()

@property (nonatomic, strong) ProgressBarView *progressBarView;
@property (nonatomic, strong) UILabel *processLabel;

@end

@implementation UploadTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initUI];
    }
    return self;
}
#pragma mark - private methods
- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.progressBarView];
    [self.progressBarView addSubview:self.processLabel];

    _processLabel.hidden = YES;
    _progressBarView.hidden = YES;
}
- (void)setUploadImage
{WEAKSELF;
    _processLabel.hidden = NO;
    _progressBarView.hidden = NO;

    // 处理 请求上传私有token 上传逻辑 和上传完成后的回调方法
    _subTitleLabel.text = @"文件大小";
//    if ([weakSelf.delegate respondsToSelector:@selector(uploadCompletedRefreshesTheList)]) {
//        [weakSelf.delegate uploadCompletedRefreshesTheList];
//    }

}
- (void)settingUIWithFull:(UIImage *)fullScreenImage withSection:(NSInteger)section
{
    
    //    _titleLabel.text = @"2016-06-04 133131.jpg";
    _subTitleLabel.text = @"正在等待...";
    ALAsset *asset = dict[@"asset"];
    
    _titleLabel.text = asset.defaultRepresentation.filename;//[NSString stringWithFormat:@"%@",[asset valueForProperty: ALAssetPropertyDate]];

    if (section == 0) {
        _subTitleLabel.text = @"正在等待...";
    }else {
        _subTitleLabel.text = @"";
    }
    
}
#pragma mark - setters and getters
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10,160, 20)];
        _titleLabel.font  = Font_15;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = hexColor(333333);
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35,160, 20)];
        _subTitleLabel.font  = Font_13;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.textColor = hexColor(999999);
    }
    return _subTitleLabel;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        _iconImageView.image = [UIImage imageNamed:@"home_palcehold"];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.userInteractionEnabled = YES;

    }
    return _iconImageView;
}
- (ProgressBarView *)progressBarView
{
    if (!_progressBarView){
       
       _progressBarView = [[ProgressBarView alloc]initWithFrame:CGRectMake(kMainScreenWidth - 65, 5, 50, 50)];
        [_progressBarView setBackgroundColor:[UIColor clearColor]];
        _progressBarView.delegate = self;
        _progressBarView.progressBarColor = hexColor(00c8aa);
        _progressBarView.progressBarShadowOpacity = .1f;
        _progressBarView.progressBarArcWidth = 2.0f;
        _progressBarView.wrapperColor = [UIColor colorWithRed: 240.0 / 255.0 green:240.0 / 255.0 blue: 240.0 / 255.0 alpha: .5];
        _progressBarView.duration = 1.0f;
        [_progressBarView run: 0.0f];
    }
    return _progressBarView;
}
- (UILabel *)processLabel
{
    if (!_processLabel) {
       _processLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 40, 20)];
        _processLabel.text = @"0%";
        _processLabel.numberOfLines = 1;
        _processLabel.textAlignment = NSTextAlignmentCenter;
        _processLabel.font = Font_14;
       _processLabel.textColor = hexColor(666666);
    }
    return _processLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
