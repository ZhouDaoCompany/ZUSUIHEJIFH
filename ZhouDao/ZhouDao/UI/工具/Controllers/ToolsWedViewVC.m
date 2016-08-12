//
//  ToolsWedViewVC.m
//  ZhouDao
//
//  Created by apple on 16/7/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsWedViewVC.h"
#import "UIWebView+Load.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "ToolsIntroduceVC.h"
#import "WebViewJavascriptBridge.h"
#import "MoreViewController.h"
#import "SDPhotoBrowser.h"

@interface ToolsWedViewVC ()<UIWebViewDelegate,SDPhotoBrowserDelegate,UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer* _singleTap;//失败重新加载
}
@property (nonatomic, strong) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;

@property (nonatomic, strong) UIButton *historyBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) NSMutableArray *imgArrays;
@end

@implementation ToolsWedViewVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:_navTitle];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([_format isEqualToString:@"Noti"]) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"Count_close_normal_"];
        self.fd_interactivePopDisabled = YES;
    }
    
    _imgArrays = [NSMutableArray array];
    [self.view addSubview:self.webView];
    
    [self loadCommonMethod];
    
}
- (void)loadCommonMethod{
    
    if (_tType == FromToolsType){
        [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"tools_introduce"];
        if (_bridge) { return; }
        [WebViewJavascriptBridge enableLogging];
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        [self.bridge setWebViewDelegate:self];

        WEAKSELF;
        [_bridge registerHandler:@"shareZhoudao" handler:^(id data, WVJBResponseCallback responseCallback) {
            
            DLog(@"testObjcCallback called: %@", data);
            NSDictionary *dataDic = (NSDictionary *)data;
            [weakSelf testObjcCallback:dataDic];
            responseCallback(@"Response from shareZhoudao");
        }];
        [_webView loadHtml:_url];
        
    }else {

        if (_tType == FromHotType || _tType == FromRecHDType) {
            [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_Share"];
        }else if (_tType == FromEveryType){
            [self.view addSubview:self.shareBtn];
            [self.view addSubview:self.historyBtn];
        }

        WEAKSELF;
        if (!_bridge){
            [WebViewJavascriptBridge enableLogging];
            self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
            [self.bridge setWebViewDelegate:self];
            
            [_bridge registerHandler:@"imgAll" handler:^(id data, WVJBResponseCallback responseCallback) {
                
                DLog(@" called: %@", data);
                responseCallback(@"Response from imgAll");
                NSDictionary *dataDic = (NSDictionary *)data;
                NSMutableArray *arr = dataDic[@"all"];
                NSString *curr = dataDic[@"curr"];
                [weakSelf.imgArrays addObjectsFromArray:arr];
                [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([curr isEqualToString:obj]) {
                        [weakSelf testImg:arr withInte:idx];
                    }
                }];
            }];
        }
        
        [_webView loadURL:_url];
    }
    
    if (_singleTap) {
        [_webView removeGestureRecognizer:_singleTap];
    }
}
- (void)testImg:(NSMutableArray *)arr withInte:(NSUInteger)index{
    DLog(@"diaoqi");
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.imageCount = arr.count; // 图片总数
    browser.currentImageIndex = index;
    browser.delegate = self;
    browser.sourceImagesContainerView = self.webView; // 原图的父控件
    [browser show];
}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return kGetImage(@"home_Shuff");
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (_imgArrays.count >0) {
        NSString *urlStr = [_imgArrays[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        return [NSURL URLWithString:urlStr];
    }
    return nil;
}

#pragma mark -分享按钮
- (void)testObjcCallback:(NSDictionary *)dict
{WEAKSELF;
    [NetWorkMangerTools toolsSharewithParaDic:dict RequestSuccess:^(NSString *shareUrl) {
        
        NSString *contentString;
        if (_tType == FromHotType) {
            contentString = GET(weakSelf.shareContent);
        }else{
            contentString = GET(weakSelf.navTitle);
        }
        NSString *title = @"周道慧法";
        NSString *url = GET(shareUrl);
        NSString *imgUrlString = _imgUrlString;
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,imgUrlString, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs
                                contentArrays:arrays
                      withPresentedController:self
                       SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                           
                       }];
    }];
}

#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    NSString *title = @"周道慧法";
    NSString *contentString = GET(_shareContent);
    
    if (_tType == FromHotType) {
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_hotspot.php?%@",kProjectBaseUrl,[array lastObject]];
        
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,_imgUrlString, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];
        
    }else if (_tType == FromEveryType){
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_daily.php?%@",kProjectBaseUrl,[array lastObject]];
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,_imgUrlString, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];
        
    }else if (_tType == FromRecHDType){
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_slide.php?%@",kProjectBaseUrl,[array lastObject]];
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,_imgUrlString,nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];
    }
    
    if (_tType == FromToolsType){
        
        if (_introContent.length >0) {
            ToolsIntroduceVC *vc = [ToolsIntroduceVC new];
            vc.introContent = _introContent;
            [self presentViewController:vc animated:YES completion:^{
            }];
        }else{
            [JKPromptView showWithImageName:nil message:@"暂无说明"];
        }
    }
}
- (void)chenckHistoryEvent
{
    MoreViewController *moreVC = [MoreViewController new];
    moreVC.moreType = ToolsWebType;
    [self.navigationController  pushViewController:moreVC animated:YES];
}
- (void)leftBtnAction
{
    if ([_format isEqualToString:@"Noti"]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
    DLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    DLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [SVProgressHUD dismiss];
    
    [_webView loadHtml:@"error"];
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againLoad)];
    _singleTap.cancelsTouchesInView = NO;
    _singleTap.delegate = self;
    [_webView addGestureRecognizer:_singleTap];
    DLog(@"加载失败");
}
- (void)againLoad{
    DLog(@"重新加载");
    [self loadCommonMethod];
}
#pragma mark - getters and setters
- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(kMainScreenWidth -45.f,27.f, 30, 30);
        [_shareBtn setImage:kGetImage(@"template_Share") forState:0];
        [_shareBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UIButton *)historyBtn
{
    if (!_historyBtn) {
        _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyBtn.frame = CGRectMake(kMainScreenWidth - 90.f,27.f, 30, 30);
        [_historyBtn setImage:kGetImage(@"everyDay_history") forState:0];
        [_historyBtn addTarget:self action:@selector(chenckHistoryEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyBtn;
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView.backgroundColor = [UIColor clearColor];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;//禁止用户缩放页面
        [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
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
