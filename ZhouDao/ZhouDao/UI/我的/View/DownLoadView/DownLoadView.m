//
//  DownLoadView.m
//  ZhouDao
//
//  Created by cqz on 16/3/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DownLoadView.h"

@interface DownLoadView()

@property (nonatomic, strong) UIImageView *fileImgView;
@property (nonatomic, strong) UILabel *speedlab;//速度
@end

@implementation DownLoadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initUI];
    }
    
    return self;
}
- (void)setFormat:(NSString *)format
{
    _format = format;
    if ([_format isEqualToString:@"1"]) {
        _fileImgView.image = [UIImage imageNamed:@"case_word"];
    }else if ([_format isEqualToString:@"2"]){
        _fileImgView.image = [UIImage imageNamed:@"case_pdf"];
    }else if ([_format isEqualToString:@"3"]){
        _fileImgView.image = [UIImage imageNamed:@"case_txt"];
    }else if ([_format isEqualToString:@"4"]){
        _fileImgView.image = [UIImage imageNamed:@"case_photo"];
    }else{
        _fileImgView.image = [UIImage imageNamed:@"template_Word"];
    }
}
 - (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha  = .4f;
    [self addSubview:maskView];
    
    float width = self.frame.size.width;
    
    UIView *botomView = [[UIView alloc] init];
    botomView.backgroundColor = [UIColor clearColor];
    botomView.center = self.center;
    botomView.bounds = CGRectMake(0, 0, 144, 144);
    [self addSubview:botomView];
    
    

    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.frame = CGRectMake(27, 27, 90, 90);
    imageview.image = [UIImage imageNamed:@"template_Word"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    _fileImgView = imageview;
    [botomView addSubview:_fileImgView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, Orgin_y(botomView)+10.f, width- 60, 20)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    lab.font = Font_14;
    lab.textAlignment = NSTextAlignmentCenter;
    _speedlab = lab;
    [self addSubview:_speedlab];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];

    progressView.frame = CGRectMake(30, Orgin_y(_speedlab)+10.f, width- 60, 1);
    progressView.progressTintColor = [UIColor blackColor];
    [progressView setProgress:0.f];
    _progressView = progressView;
    [self addSubview:_progressView];
}

- (void)setModel:(TaskModel *)model
{
    _model = nil;
    _model = model;
    
    [self loadData];
}
- (void)loadData
{
    float width = self.frame.size.width;
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(30, Orgin_y(_fileImgView) - _fileImgView.frame.size.height -30, width- 60, 20.f)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = thirdColor;
    titLab.font = Font_18;
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.text = _model.name;
    [self addSubview:titLab];


    WEAKSELF;
    //检查之前是否已经下载，若已经下载，获取下载进度。
    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:_model.destinationPath];
    if(exist)
    {
        //获取原来的下载进度
        _progressView.progress=[[FGGDownloadManager shredManager] lastProgress:_model.url];
        //获取原来的文件已下载部分大小及文件总大小
//        _sizeLabel.text=[[FGGDownloadManager shredManager] filesSize:_model.url];
        //原来的进度
//        _progressLabel.text=[NSString stringWithFormat:@"%.2f%%",_progressView.progress*100];
    }
    if(_progressView.progress==1.0)
    {
        if ([self.delegate respondsToSelector:@selector(getDownloadState:readPath:)])
        {
            [self.delegate getDownloadState:@"完成" readPath:_model.destinationPath];
        }
    }else{
        //添加下载任务
        [[FGGDownloadManager shredManager] downloadWithUrlString:_model.url toPath:_model.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
            //更新进度条的进度值
            weakSelf.progressView.progress=progress;
            weakSelf.speedlab.text = [[FGGDownloadManager shredManager] filesSize:_model.url];
//            DLog(@"网速是－－－－%@",speedString);
//            DLog(@"大小－－－%@",[[FGGDownloadManager shredManager] filesSize:_model.url]);
//            DLog(@"已有－－－－%@",[NSString stringWithFormat:@"%.2f%%",weakSelf.progressView.progress*100]);
            
        } completion:^{
            if ([weakSelf.delegate respondsToSelector:@selector(getDownloadState:readPath:)])
            {
                [weakSelf.delegate getDownloadState:@"完成" readPath:_model.destinationPath];
            }
        } failure:^(NSError *error) {
            [[FGGDownloadManager shredManager] cancelDownloadTask:weakSelf.model.url];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"下载失败" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alert show];
        }];
    }

}
#pragma mark -重试下载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        WEAKSELF;
        //添加下载任务
        [[FGGDownloadManager shredManager] downloadWithUrlString:_model.url toPath:_model.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
            //更新进度条的进度值
            weakSelf.progressView.progress=progress;
            
        } completion:^{
            if ([weakSelf.delegate respondsToSelector:@selector(getDownloadState:readPath:)])
            {
                [weakSelf.delegate getDownloadState:@"完成" readPath:_model.destinationPath];
            }

        } failure:^(NSError *error) {
            [[FGGDownloadManager shredManager] cancelDownloadTask:weakSelf.model.url];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"下载失败" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            [alert show];
        }];
        
    }else{
        [self removeFromSuperview];
    }
}

/*
 设置进度条风格样式
 
 
 @property(nonatomic) UIProgressViewStyle progressViewStyle;
 
 设置进度条进度(0.0-1.0之间，默认为0.0)
 
 @property(nonatomic) float progress;
 
 设置已走过进度的进度条颜色
 
 @property(nonatomic, retain) UIColor* progressTintColor;
 
 设置未走过进度的进度条颜色
 
 @property(nonatomic, retain) UIColor* trackTintColor;
 
 设置进度条已走过进度的背景图案和为走过进度的背景图案(IOS7后好像没有效果了)
 
 @property(nonatomic, retain) UIImage* progressImage;
 
 @property(nonatomic, retain) UIImage* trackImage;
 
 设置进度条进度和是否动画显示(动画显示会平滑过渡)
 
 - (void)setProgress:(float)progress animated:(BOOL)animated;
 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
