//
//  ToolsIntroduceVC.m
//  ZhouDao
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsIntroduceVC.h"
#import "UIWebView+HTML5.h"

@interface ToolsIntroduceVC ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ToolsIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}
#pragma mark - 
- (void)initUI{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupNaviBarWithTitle:@"计算说明"];
    self.titleLabel.font = Font_17;
    self.titleLabel.textColor = [UIColor blackColor];

    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];
    self.statusBarView.backgroundColor = ViewBackColor;//[UIColor colorWithHexString:@"#"];
    self.naviBarView.backgroundColor = ViewBackColor;

    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    webView.backgroundColor = ViewBackColor;
    [webView setOpaque:NO];
    _webView = webView;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_webView];
    [_webView loadHTMLString:_introContent baseURL:nil];
}
- (void)rightBtnAction{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
