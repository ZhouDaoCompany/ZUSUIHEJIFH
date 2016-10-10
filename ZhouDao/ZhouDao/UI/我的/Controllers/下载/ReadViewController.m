//
//  ReadViewController.m
//  ZhouDao
//
//  Created by cqz on 16/3/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ReadViewController.h"
#import "FGGDownloadManager.h"
#import "TaskModel.h"
#import "DownLoadView.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "UIWebView+Load.h"

#define kCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])

@interface ReadViewController ()<UIGestureRecognizerDelegate,DownLoadViewPro,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) DownLoadView *downView;
@property (nonatomic, strong) UIImageView *wordImgView;
@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy)   NSString *fileURLPath;//文件地址

@end

@implementation ReadViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    self.view.backgroundColor = ViewBackColor;
    [self setupNaviBarWithTitle:_navTitle];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    if (_rType == FileExist) {
        _fileURLPath = _model.destinationPath;
        DLog(@"本地文件路径==%@",_model.destinationPath);
        [self.view addSubview:self.titLabel];
        [self.view addSubview:self.wordImgView];
        [self.view addSubview:self.openBtn];

    }else{
        [self.view addSubview:self.downView];
    }
}
#pragma mark -DownLoadViewPro
- (void)getDownloadState:(NSString *)downStr readPath:(NSString *)path
{
    if ([downStr isEqualToString:@"完成"])
    {
        [_downView removeFromSuperview];
        if (_readBlock) {
            _readBlock(@"阅读此模版");
        }
        _fileURLPath = path;
        
        [self.view addSubview:self.titLabel];
        [self.view addSubview:self.wordImgView];
        [self.view addSubview:self.openBtn];
    }
}
#pragma mark - UIButtonEvent
- (void)openFileBtnEvent:(UIButton *)btn
{
    NSURL *docURL = [NSURL fileURLWithPath:_fileURLPath];
    [self otherApplicationsToOpenwithURLString:docURL];
}
- (void)otherApplicationsToOpenwithURLString:(NSURL *)urlString{
    
    _documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:urlString];
    _documentInteractionController.delegate = self;
    [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64.f) inView:self.view animated:YES];
}
#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64.f);
}

#pragma mark - setters  and getters
- (DownLoadView *)downView
{
    if (!_downView) {
        _downView = [[DownLoadView alloc] initWithFrame:kMainScreenFrameRect];
        _downView.delegate = self;
        _downView.model = _model;
    }
    return _downView;
}
- (UILabel *)titLabel
{
    if (!_titLabel) {
        _titLabel = [[UILabel alloc] initWithFrame:CGRectMake(30,94 , kMainScreenWidth - 60, 20)];
        _titLabel.text = _model.name;
        _titLabel.font = Font_16;
        _titLabel.textAlignment = NSTextAlignmentCenter;
        _titLabel.textColor= hexColor(333333);
    }
    return _titLabel;
}
- (UIImageView *)wordImgView
{
    if (!_wordImgView) {
        
        _wordImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 153.f)/2.f, 139, 153.f, 145.f)];
        _wordImgView.image = kGetImage(@"template_Word");
        _wordImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _wordImgView;
}
- (UIButton *)openBtn
{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_openBtn setTitle:@"其他应用打开" forState:0];
        _openBtn.frame = CGRectMake(60, Orgin_y(_wordImgView) + 25, kMainScreenWidth - 120, 45);
        _openBtn.backgroundColor = KNavigationBarColor;
        _openBtn.layer.masksToBounds = YES;
        _openBtn.layer.cornerRadius = 5.f;
        [_openBtn addTarget:self action:@selector(openFileBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
