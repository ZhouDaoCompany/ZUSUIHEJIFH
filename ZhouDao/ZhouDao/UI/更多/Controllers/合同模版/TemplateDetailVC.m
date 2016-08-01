//
//  TemplateDetailVC.m
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TemplateDetailVC.h"
#import "UIWebView+Load.h"
#import "TaskModel.h"
#import "ReadViewController.h"
#import "TemplateData.h"
#import "LoginViewController.h"

#define kCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])

@interface TemplateDetailVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL _exist;
    UITapGestureRecognizer* _singleTap;//失败重新加载
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) TaskModel *model;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) TemplateData *dataModel;

@end

@implementation TemplateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
}
- (void)loadData
{WEAKSELF;
    if (_singleTap) {
        [_webView removeGestureRecognizer:_singleTap];
    }
    [NetWorkMangerTools theContractContent:_idString RequestSuccess:^(TemplateData *model) {
        
        _dataModel = model;
        [self setupNaviBarWithTitle:_dataModel.title];
        if ([weakSelf.dataModel.is_collection  integerValue] == 0) {
            [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_shoucang"];
        }else{
            [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_SC"];
        }
        [_webView loadHTMLString:_dataModel.content baseURL:nil];
        [self downLoadTemplate];
    } fail:^{
        [self addGestureReloadData];
    }];
}
- (void)addGestureReloadData{
    [_webView loadHtml:@"error"];
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againLoad)];
    _singleTap.cancelsTouchesInView = NO;
    _singleTap.delegate = self;
    [_webView addGestureRecognizer:_singleTap];
}
- (void)initUI
{
    _webView.backgroundColor = [UIColor clearColor];
    [self setupNaviBarWithTitle:@"合同模版"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_shoucang"];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    
    _webView.delegate = self;
    //_webView.scrollView.bounces = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    //    [_webView loadURL:_url];
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.scalesPageToFit = NO;//禁止用户缩放页面
    [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
    [self.view addSubview:_webView];
}
- (void)downLoadTemplate
{
    UIButton *downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadBtn.backgroundColor = KNavigationBarColor;
    //    [downLoadBtn setTitle:@"下载本合同" forState:0];
    [downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
    [downLoadBtn addTarget:self action:@selector(downloadThisTemplate:) forControlEvents:UIControlEventTouchUpInside];
    downLoadBtn.frame = CGRectMake(0, kMainScreenHeight-45.f, kMainScreenWidth, 45.f);
    downLoadBtn.alpha = 0.7f;
    [self.view addSubview:downLoadBtn];

    _model = [TaskModel model];
    _model.name=[NSString stringWithFormat:@"%@.docx",_dataModel.id];
    _model.url= _url;
    _model.content = _dataModel.title;
    _model.destinationPath=[kCachePath stringByAppendingPathComponent:_model.name];

    NSString *alertStr = @"下载本合同";
    _exist=[[NSFileManager defaultManager] fileExistsAtPath:_model.destinationPath];
    if(_exist)
    {
        alertStr= @"阅读此模版";
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-45.f, kMainScreenWidth, 45.f)];
    label.text = alertStr;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    _label = label;
    [self.view addSubview:_label];
}
#pragma mark - UIWebViewDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD show];
    DLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    DLog(@"加载完成");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{    DLog(@"加载失败");
    [SVProgressHUD dismiss];
}
- (void)againLoad{
    DLog(@"重新加载");
    [self loadData];
}
#pragma mark -UIButtonEvent
- (void)downloadThisTemplate:(id)sender
{WEAKSELF;
    if(_exist)
    {
        ReadViewController *readVC = [ReadViewController new];
        readVC.model = _model;
        readVC.rType = FileExist;
        readVC.idStr = _dataModel.id;
        [self.navigationController pushViewController:readVC animated:YES];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,contractDownload,_dataModel.id];
        [NetWorkMangerTools downLoadTheContract:url RequestSuccess:^(NSString *htmlString) {
            
            ReadViewController *readVC = [ReadViewController new];
            weakSelf.model.url = [[NSString stringWithFormat:@"%@%@",DownloadThePrefix,htmlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            readVC.model = _model;
            readVC.rType = FileNOExist;
            readVC.idStr = weakSelf.dataModel.id;
            readVC.readBlock  = ^(NSString *str){
                _label.text = str;
                _exist = !_exist;
            };
            [self.navigationController pushViewController:readVC animated:YES];
        }];
    }
}
- (void)rightBtnAction

{WEAKSELF;
    if ([PublicFunction ShareInstance].m_bLogin == NO) {
        [JKPromptView showWithImageName:nil message:@"登录后才能收藏"];
        LoginViewController *loginVc = [LoginViewController new];
        loginVc.closeBlock = ^{
            if ([PublicFunction ShareInstance].m_bLogin == YES)
            {
                [NetWorkMangerTools theContractContent:_idString RequestSuccess:^(TemplateData *model) {
                    
                    _dataModel = model;
                    if ([weakSelf.dataModel.is_collection  integerValue] == 0) {
                        [weakSelf setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_shoucang"];
                        [weakSelf collectionMethod];
                    }else{
                        [weakSelf setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_SC"];
                    }
                } fail:^{
                    [self addGestureReloadData];
                }];
            }
        };
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVc] animated:YES completion:nil];
        return;
    }
    
    if ([_dataModel.is_collection  integerValue] == 0) {
        [self collectionMethod];
    }else{
        [NetWorkMangerTools collectionDelMine:_dataModel.id withType:templateCollect RequestSuccess:^{
            _dataModel.is_collection = @0;
            [weakSelf setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_shoucang"];
        }];
    }
}
- (void)collectionMethod{
    WEAKSELF;
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:templateCollect,@"type",_dataModel.id,@"article_id",_dataModel.title,@"article_title",_dataModel.describe,@"article_subtitle",timeSJC,@"article_time",UID,@"uid", nil];
    [NetWorkMangerTools collectionAddMine:dictionary RequestSuccess:^{
        _dataModel.is_collection = @1;
        [weakSelf setupNaviBarWithBtn:NaviRightBtn title:nil img:@"template_SC"];
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
