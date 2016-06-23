//
//  ToolsWedViewVC.m
//  ZhouDao
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//
//图片缩放比例
#define kMinZoomScale 0.6f
#define kMaxZoomScale 2.0f

//是否支持横屏
#define shouldSupportLandscape YES
#define kIsFullWidthForLandScape YES //是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES

#import "ToolsWedViewVC.h"
#import "UIWebView+Load.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "ToolsIntroduceVC.h"
#import "WebViewJavascriptBridge.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface ToolsWedViewVC ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;
@property WebViewJavascriptBridge* bridge;

@end

@implementation ToolsWedViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [_webView clearCookies];
    _webView = nil;

}
- (void)initUI
{
    
    [self setupNaviBarWithTitle:_navTitle];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    

    if ([_format isEqualToString:@"jpg"]) {

        _imageview = [[UIImageView alloc] init];
        [_imageview sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:[UIImage imageNamed:@"gov_tupian"]];
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64.f);
        [self.view addSubview:_scrollview];
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
        
        [self adjustFrames];

    }else{
        
        if ([_format isEqualToString:@"Noti"]) {
            
            [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"Count_close_normal_"];
        }
        
        _webView.backgroundColor = [UIColor clearColor];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;//禁止用户缩放页面
        [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
        
        if (_tType == FromHotType || _tType == FromEveryType || _tType == FromRecHDType) {
            
            [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_Share"];
            [_webView loadURL:_url];

            WEAKSELF;
            if (_bridge) { return; }
            [WebViewJavascriptBridge enableLogging];
            _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        
            [_bridge registerHandler:@"imgAll" handler:^(id data, WVJBResponseCallback responseCallback) {
                
                DLog(@" called: %@", data);
                responseCallback(@"Response from imgAll");
                NSDictionary *dataDic = (NSDictionary *)data;
                NSMutableArray *arr = dataDic[@"all"];
                NSString *curr = dataDic[@"curr"];
                [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([curr isEqualToString:obj]) {
                        [weakSelf testImg:arr withInte:idx];
                    }
                }];
            }];

        }else if (_tType == FromToolsType){
            
            [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"tools_introduce"];
            _webView.scrollView.bounces = NO;
            if (_bridge) { return; }
            [_webView loadURL:_url];
            [WebViewJavascriptBridge enableLogging];
            _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
            
            WEAKSELF;
            [_bridge registerHandler:@"shareZhoudao" handler:^(id data, WVJBResponseCallback responseCallback) {
                DLog(@"testObjcCallback called: %@", data);
                NSDictionary *dataDic = (NSDictionary *)data;
                [weakSelf testObjcCallback:dataDic];
                responseCallback(@"Response from shareZhoudao");
            }];
            
        }else if (_tType == FromCaseType){
            
            [_webView loadTxtFileUrl:_url];
        }

    }
    
}
- (void)testImg:(NSMutableArray *)arr withInte:(NSUInteger)index{
    DLog(@"diaoqi");
    
//    NSUInteger count = tap.imgsArray.count;
//    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 替换为中等尺寸图片
        NSString *url = [obj stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; // 图片路径
//        photo.srcImageView = tap.iiiView.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.urlPhotos = arr;
    [browser show];

}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    NSString *title = @"周道慧法";
    NSString *contentString = GET(_shareContent);

    if (_tType == FromHotType) {
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_hotspot.php?%@",kProjectBaseUrl,[array lastObject]];
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];

    }else if (_tType == FromEveryType){
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_daily.php?%@",kProjectBaseUrl,[array lastObject]];
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];

    }else if (_tType == FromRecHDType){
        NSArray *array = [_url componentsSeparatedByString:@"&"];
        NSString *url = [NSString stringWithFormat:@"%@share_slide.php?%@",kProjectBaseUrl,[array lastObject]];
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
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
    [JKPromptView showWithImageName:nil message:@"加载失败"];
}
- (void)adjustFrames
{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        
        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;
        
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
}

// 处理缩放手势
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}
#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
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
        NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs
                                contentArrays:arrays
                      withPresentedController:self
                       SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        }];

    }];
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
