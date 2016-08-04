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

@interface ReadViewController ()<UIGestureRecognizerDelegate,DownLoadViewPro,UIWebViewDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) DownLoadView *downView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"合同模版"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_Share"];

    self.view.backgroundColor = ViewBackColor;
    
    [self.view addSubview:self.webView];

    
//    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClik:)];
//    longtapGesture.delegate = self;
//    longtapGesture.minimumPressDuration = 0.2;
//    [_webView addGestureRecognizer:longtapGesture];

    
    if (_rType == FileExist) {
        NSURL *lastUrl = [NSURL fileURLWithPath:_model.destinationPath];
//        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"二期需求规格说明书" ofType:@"docx"]];
//        NSString *urlStr = [url absoluteString];

        NSString *htmlString = [lastUrl absoluteString];
        DLog(@"本地文件路径==%@",_model.destinationPath);
//        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:lastUrl];
//        self.documentInteractionController.delegate = self;
//        self.documentInteractionController.UTI = @"public.plain-text";
//        self.documentInteractionController.name = @"详细设计说明书";
//        [self.documentInteractionController presentOptionsMenuFromRect:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64.f) inView:self.view animated:YES];
        
        _documentInteractionController = [UIDocumentInteractionController
                                          interactionControllerWithURL:lastUrl];
 
        self.documentInteractionController.delegate = self;
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64.f) inView:self.view animated:YES];


//        [_webView loadURL:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        _downView = [[DownLoadView alloc] initWithFrame:kMainScreenFrameRect];
        _downView.delegate = self;
        _downView.model = _model;
        [self.view addSubview:_downView];
    }
}
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
#pragma mark -DownLoadViewPro
- (void)getDownloadState:(NSString *)downStr readPath:(NSString *)path
{
    if ([downStr isEqualToString:@"完成"])
    {
        [_downView removeFromSuperview];
        _readBlock(@"阅读此模版");
        NSURL *lastUrl = [NSURL fileURLWithPath:path];
        NSString *htmlString = [lastUrl absoluteString];

        [_webView loadURL:[htmlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    NSString *title = @"周道慧法";
    NSString *contentString = GET(_model.content);
    NSString *shareUrl =  [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TheContractShareUrl,_idStr];
    NSString *imgUrlString = _imageUrl;
    NSArray *arrays = [NSArray arrayWithObjects:title,contentString,shareUrl,imgUrlString,nil];
    [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
    }];
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [SVProgressHUD dismiss];
}
//废除放大效果
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    return NO;
}

//长按调用的手势
- (void)longClik:(UILongPressGestureRecognizer *)longPressGesture{
    
    // 如果是手势开始的状态才执行
    if (longPressGesture.state==UIGestureRecognizerStateBegan) {
        
        CGPoint p = [(UILongPressGestureRecognizer *)longPressGesture locationInView:_webView.scrollView];
        
        DLog(@"当前点击位置x%f y%f",p.x,p.y);
    }
}

#pragma mark - setters  and getters
- (UIWebView *)webView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.delegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //支持缩放
        _webView.scalesPageToFit = YES;
        //添加长按手势
    }
    return _webView;
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
