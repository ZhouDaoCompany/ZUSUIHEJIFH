//
//  UploadTableViewCell.m
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "UploadTableViewCell.h"
#import "ProgressBarView.h"
//上传
#import "QiniuUploader.h"

@interface UploadTableViewCell()
{
    
}
@property (nonatomic, strong) ProgressBarView *progressBarView;
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) UIImage *fullScreenImage;
@property (nonatomic, strong) QiniuUploader *uploader;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy)   NSString *fileName;//文件名
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
{
    _processLabel.hidden = NO;
    _progressBarView.hidden = NO;

    // 处理 请求上传私有token 上传逻辑 和上传完成后的回调方法

    if ([PublicFunction ShareInstance].picToken.length == 0) {
        [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
            
            [SVProgressHUD dismiss];
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                [self uploadFileMethods];
            });

        }];
    }else {
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [self uploadFileMethods];
        });
    }

}
- (void)uploadFileMethods
{WEAKSELF;
    QiniuFile *file = [[QiniuFile alloc] initWithFileData:UIImageJPEGRepresentation(_fullScreenImage, 1.f)];
    QiniuUploader *uploader = [[QiniuUploader alloc] init];

    [uploader addFile:file];
    [uploader startUploadWithAccessToken:[PublicFunction ShareInstance].picToken];
    [uploader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
        
        DLog(@"失败原因－－－－%@",error);
        //上传失败重新获取token
        [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
            
            [SVProgressHUD dismiss];
            [weakSelf.uploader startUpload];
        }];
    }];
    
    __block NSString *successString = @"";
    [uploader setUploadOneFileProgress:^(AFHTTPRequestOperation *operation, NSInteger index, double percent){
        DLog(@"进度是----%f",percent);
        if (![successString isEqualToString:@"上传成功"]) {
            [weakSelf.progressBarView run: percent];
            int processShow = percent*100;
            if (processShow >=98) {
                weakSelf.processLabel.text = [NSString stringWithFormat:@"%d％",98];
            }else {
                weakSelf.processLabel.text = [NSString stringWithFormat:@"%d％",processShow];
            }
        }
    }];
    
    [uploader setUploadAllFilesComplete:^(void){
        
        DLog(@"上传完成");
    }];
    __block int indexCount = 0;
    [uploader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
        DLog(@"index:%ld key:%@",(long)index,key);
        if (indexCount == 0) {
            
            successString = @"上传成功";
            [NetWorkMangerTools arrangeFileAddwithPid:@"" withName:weakSelf.fileName withFileType:@"1" withtformat:@"4" withqiniuName:key withCid:_caseId RequestSuccess:^(id obj) {
                
                weakSelf.processLabel.text = [NSString stringWithFormat:@"%d％",100];
                
                if ([weakSelf.uploadDelegate respondsToSelector:@selector(uploadCompletedRefreshesTheListwithRow:)]) {
                    [weakSelf.uploadDelegate uploadCompletedRefreshesTheListwithRow:weakSelf.row];
                }
                
            }];

        }
        indexCount ++;
        
    }];

    [uploader startUpload];
    
}
- (void)setIsStart:(BOOL)isStart
{
    _isStart = isStart;
    
    if (_isStart == NO) {
        _processLabel.hidden = YES;
        _progressBarView.hidden = YES;

        [self.uploader.operationQueue cancelAllOperations];
    }
}
- (void)settingUIWithDictionary:(NSDictionary *)assetDictionary withSection:(NSInteger)section withRow:(NSInteger)row
{
    _row = row;
    _titleLabel.text = assetDictionary[@"filename"];
    _iconImageView.image = assetDictionary[@"thumbnail"];
    _fullScreenImage = assetDictionary[@"fullScreenImage"];
    _fileName = assetDictionary[@"filename"];
    
    if (section == 1) {
        _processLabel.hidden = YES;
        _progressBarView.hidden = YES;
    }
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSData * imageData = UIImageJPEGRepresentation(_fullScreenImage,1);
        float length = [imageData length]/(1024.0*1024.0);
        
        kDISPATCH_MAIN_THREAD((^{
            
            _subTitleLabel.text = [NSString stringWithFormat:@"%.2fM",length];

            if (section == 0 && row != 0 && _isStart == YES)
            {
                _subTitleLabel.text = @"正在等待...";
            }
        }));
    });

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
- (QiniuUploader *)uploader
{
    if (!_uploader) {
        _uploader = [[QiniuUploader alloc] init];
    }
    return _uploader;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
