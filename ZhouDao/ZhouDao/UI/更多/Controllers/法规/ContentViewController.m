//
//  ContentViewController.m
//  ZhouDao
//
//  Created by cqz on 16/3/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ContentViewController.h"
#import "UIWebView+Load.h"
#import "UIWebView+HTML5.h"
#import "ZD_SettingBottomBar.h"
#import "ZD_ListView.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "AboutReadView.h"
#import "UIWebView_SearchWebView.h"
#import "LawDetailModel.h"
#import "LoginViewController.h"
#import "VerticalMenuButton.h"

#define NoCollected [NSMutableArray arrayWithObjects:@"law_xiangguan",@"law_jiegou",@"law_share",@"law_shoucang", nil];
#define Collected [NSMutableArray arrayWithObjects:@"law_xiangguan",@"law_jiegou",@"law_share",@"law_selectedSC", nil];

#define xSpace 40
@interface ContentViewController ()<UIWebViewDelegate,ZD_SettingBottomBarPro,UITextFieldDelegate,AboutReadViewPro>
{
    NSString *_navTitle;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) UIImageView *setImgView;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) NSMutableArray *imgNameArrays;
@property (nonatomic, strong) NSMutableArray *aboutArrays;//相关阅读
@end

@implementation ContentViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initUI];
}
#pragma mark - methods
- (void)initUI
{
    NSArray *navArrays = @[@"法规详情",@"赔偿标准详情",@"案例详情"];
    _navTitle = navArrays[_dType];

    [self setupNaviBarWithTitle:_navTitle];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    self.view.backgroundColor = ViewBackColor;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.topBtn];
    [self.view addSubview:self.setImgView];
    [self.view addSubview:self.setBtn];
    [self.view addSubview:self.searchImgView];
    [self.view addSubview:self.searchBtn];

    NSString *backViewColor = [USER_D objectForKey:@"WebViewColor"];
    if (backViewColor.length>0) {
        self.view.backgroundColor = [UIColor colorWithHexString:backViewColor];
    }
    if ([_model.is_collection isEqualToString:@"0"]) {
        _imgNameArrays = NoCollected;
    }else{
        _imgNameArrays = Collected;
    }
}
- (void)OnclikeWeb
{
    [self showBotomView];
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMBLoadingWithText:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
    
    NSString *readColor = [USER_D objectForKey:ReadColor];
    NSString *readFontColor = [USER_D objectForKey:ReadFontColor];
    NSString *readFont = [USER_D objectForKey:ReadFont];
    if (readFont.length >0) {
        [_webView stringByEvaluatingJavaScriptFromString:readFont];
    }
    if (readFontColor.length >0) {
        [_webView stringByEvaluatingJavaScriptFromString:readFontColor];
    }
    if (readColor.length >0) {
        [_webView stringByEvaluatingJavaScriptFromString:readColor];
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"加载失败"];
}
#pragma mark - UIButtonEvent
- (void)backWebTopEvent:(UIButton *)button
{
    NSUInteger index = button.tag;
    
    if (index == 3001) {
        [_webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (index == 3002) {
        //设置
        [self showBotomView];
    }else if (index == 3003) {
        //搜索
        [self isSearchState];
    }
}
#pragma mark -设置
- (void)showBotomView
{
    ZD_SettingBottomBar *setView = [[ZD_SettingBottomBar alloc] initWithFrame:kMainScreenFrameRect];
    setView.delegate = self;
    [self.view addSubview:setView];
}
#pragma mark -ZD_SettingBottomBarPro
- (void)getbackgroundColor:(NSString *)viewColor WithBackViewColor:(NSString *)backViewColor WithSection:(NSUInteger)section WithRow:(NSUInteger)row
{
    NSString *fontcolor = nil;
    if (row == 4) {
        fontcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#999999'";
    }else{
        fontcolor = @"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333'";
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:backViewColor];
    [_webView stringByEvaluatingJavaScriptFromString:viewColor];

    [_webView stringByEvaluatingJavaScriptFromString:fontcolor];

    [USER_D setObject:backViewColor forKey:@"WebViewColor"];
    [USER_D setObject:viewColor forKey:ReadColor];
    [USER_D setObject:fontcolor forKey:ReadFontColor];

    [USER_D synchronize];
}

- (void)getFontSize:(NSString *)fontSize WithSection:(NSUInteger)section WithRow:(NSUInteger)row
{
    [_webView stringByEvaluatingJavaScriptFromString:fontSize];
    [USER_D setObject:fontSize forKey:ReadFont];
    [USER_D synchronize];
}
#pragma mark -分享
- (void)shareThisArticle
{
    NSString *url = @"";
    if (_dType == lawsType) {
        url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,LawShareUrl,_model.idString];
    }else if (_dType == IndemnityType){
       url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,CompensationShareUrl,_model.idString];
    }else {
         url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,CaseShareUrl,_model.idString];
    }
    NSString *title = @"周道慧法分享";
    NSString *contentString = GET(_model.name);
    NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url,@"",nil];
    [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        
    }];
}
- (void)isSearchState
{WEAKSELF;
    [self setupNaviBarWithTitle:@""];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"取消" img:nil];
    self.rightBtn.titleLabel.font = Font_15;
    
    _searchBtn.hidden = YES;
    _setBtn.hidden = YES;
    _searchImgView.hidden = YES;
    _setImgView.hidden = YES;
    
    [self.view addSubview:self.searchView];
    [_searchView addSubview:self.searchField];

    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    search.userInteractionEnabled = YES;
    [search whenTapped:^{
        
        [weakSelf dismissKeyBoard];
        [weakSelf searchKeyText];
    }];
    search.image = [UIImage imageNamed:@"law_sousuo"];

    [_searchView addSubview:search];
}
- (void)rightBtnAction
{
    [self.webView removeAllHighlights];
    NSString *titleStr = self.rightBtn.titleLabel.text;
    if ([titleStr isEqualToString:@"取消"]) {
        
        TTVIEW_RELEASE_SAFELY(_searchView);
        TTVIEW_RELEASE_SAFELY(_searchField);
        _searchBtn.hidden = NO;
        _setBtn.hidden = NO;
        _searchImgView.hidden = NO;
        _setImgView.hidden = NO;
        [self setupNaviBarWithTitle:_navTitle];
    }
    [self.rightBtn setTitle:@"" forState:0];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    [self searchKeyText];
    return true;
}
- (void)searchKeyText
{
    [self.webView removeAllHighlights];

    NSString *keyText = _searchField.text;
    if (keyText.length>0) {
        NSInteger count = [self.webView highlightAllOccurencesOfString:keyText];
        
        if (count == 1) {
            [self.webView searchNext];
            [self.webView searchPrevious];
        }
        if (count >1) {
            [self.webView searchNext];
        }
    }
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
}
/*------------------------------萌萌的分割线----------------------------------*/
/**
 *  仿造钉钉菜单动画
 */
-(void)dingdingAnimation{ WEAKSELF;
    //CGPointMake(_addButton.center.x, _addButton.center.y - 30)
    [VerticalMenuButton showWithImageNameArray:_imgNameArrays clickBlock:^(NSInteger index) {
        
        DLog(@"clicked %ld",(long)index);
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.addButton.transform = CGAffineTransformIdentity;
        }];
        if (index != 4237) {
            [weakSelf receivedSingleTap:index];
        }
    } bottomPosition:_addButton.center];
    [UIView animateWithDuration:.35f animations:^{
        weakSelf.addButton.transform =  CGAffineTransformRotate(weakSelf.addButton.transform, REES_TO_RADIANS(45));
    }];

}
- (void)receivedSingleTap:(NSInteger)index {
    
    switch (index) {
        case 3:
        {//收藏
            [self JudgeCollectionMethod];
            break;
        }
        case 2:
        {//分享
            [self shareThisArticle];
            break;
        }
        case 1:
        {//目录
            [JKPromptView showWithImageName:nil message:@"此功能正在开发中..."];
            //            ZD_ListView *listviews = [[ZD_ListView alloc] initWithFrame:kMainScreenFrameRect];
            //            [self.view addSubview:listviews];
            break;
        }
        case 0:
        {//相关
            if ([_navTitle isEqualToString:@"案例详情"]) {
                [JKPromptView showWithImageName:nil message:LOCABOUTCASE];
            }else {
                [self aboutLawMethod];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma amrk -相关阅读
- (void)aboutLawMethod
{WEAKSELF;
    if (!_aboutArrays) {
        [NetWorkMangerTools aboutLawsReading:_model.idString RequestSuccess:^(NSArray *arr) {
            
            weakSelf.aboutArrays = [NSMutableArray array];
            [weakSelf.aboutArrays addObjectsFromArray:arr];
            AboutReadView *aboutView = [[AboutReadView alloc] initWithFrame:kMainScreenFrameRect];
            [aboutView setAboutArrays:weakSelf.aboutArrays];
            aboutView.delegate = self;
            [weakSelf.view addSubview:aboutView];
        } fail:^{
            weakSelf.aboutArrays = [NSMutableArray array];
        }];
    }else{
        if (_aboutArrays.count == 0) {
            [JKPromptView showWithImageName:nil message:LOCABOUTREAD];
            return;
        }
        AboutReadView *aboutView = [[AboutReadView alloc] initWithFrame:kMainScreenFrameRect];
        [aboutView setAboutArrays:weakSelf.aboutArrays];
        aboutView.delegate = self;
        [weakSelf.view addSubview:aboutView];
    }
}
#pragma mark -AboutReadViewPro
- (void)lookAboutLawsWith:(NSString *)idStr
{
    TaskModel *tmodel = [TaskModel new];
    [NetWorkMangerTools lawsDetailData:idStr RequestSuccess:^(id obj) {
        
        LawDetailModel *tempModel = (LawDetailModel *)obj;
        tmodel.idString =tempModel.id;
        tmodel.name = @"法规详情";
        tmodel.content = tempModel.content;
        tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
        ContentViewController *vc = [ContentViewController new];
        vc.dType = lawsType;
        vc.model = tmodel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark -判断收藏
- (void)JudgeCollectionMethod
{WEAKSELF;
    if ([PublicFunction ShareInstance].m_bLogin == NO) {
        [JKPromptView showWithImageName:nil message:LOCLOGINCOLLECT];
        LoginViewController *loginVc = [LoginViewController new];
        loginVc.closeBlock = ^{
            if ([PublicFunction ShareInstance].m_bLogin == YES) {
                
                [NetWorkMangerTools lawsDetailData:_model.idString RequestSuccess:^(id obj) {
                    
                    LawDetailModel *tempModel = (LawDetailModel *)obj;
                    weakSelf.model.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
                    if ([weakSelf.model.is_collection isEqualToString:@"0"]) {
                        weakSelf.imgNameArrays = NoCollected;
                        [weakSelf govCollectionMethod];
                    }else{
                        weakSelf.imgNameArrays = Collected;
//                        [weakSelf dingdingAnimation];
                    }
                }];
            }
        };
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVc] animated:YES completion:nil];
        return;
    }
    
    
    if ([_model.is_collection isEqualToString:@"0"]) {
        [self govCollectionMethod];
    }else{
        NSString *scType = nil;
        if (_dType == lawsType) {
            scType = lawCollect;
        }else if (_dType == IndemnityType){
            scType = standardCollect;
        }else {
            scType = aboutCollect;
        }
        [NetWorkMangerTools collectionDelMine:_model.idString withType:scType RequestSuccess:^{
            
            weakSelf.model.is_collection = @"0";
            weakSelf.imgNameArrays = NoCollected;
//            [weakSelf dingdingAnimation];
        }];
    }

}
- (void)govCollectionMethod{
    
    NSString *scType = nil;
    if (_dType == lawsType) {
        scType = lawCollect;
    }else if (_dType == IndemnityType){
        scType = standardCollect;
    }else {
        scType = aboutCollect;
    }
    
    WEAKSELF;
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:scType,@"type",_model.idString,@"article_id",_model.name,@"article_title",@"",@"article_subtitle",timeSJC,@"article_time",UID,@"uid", nil];
    [NetWorkMangerTools collectionAddMine:dictionary RequestSuccess:^{
       
        weakSelf.model.is_collection = @"1";
        weakSelf.imgNameArrays = Collected;
//        [weakSelf dingdingAnimation];
    }];
}

#pragma mark - setter and getter
- (UIWebView *)webView {
    
    if (!_webView) {
        _webView.backgroundColor = [UIColor clearColor];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
        _webView.delegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        [_webView loadHTMLString:_model.content baseURL:nil];
        _webView.scalesPageToFit = NO;//禁止用户缩放页面
        [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
        _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    }
    return _webView;
}
- (UIButton *)addButton {
    
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(kMainScreenWidth - 55.f,kMainScreenHeight - 110.f,40,40);
        _addButton.backgroundColor = [UIColor clearColor];
        [_addButton addTarget:self action:@selector(dingdingAnimation) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setImage:kGetImage(@"law_contenAdd") forState:0];
    }
    return _addButton;
}
- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn setBackgroundImage:[UIImage imageNamed:@"law_fanhuidingbu"] forState:0];
        _topBtn.frame = CGRectMake(kMainScreenWidth -55.f, kMainScreenHeight-60.f, 40.f, 40.f);
        _topBtn.layer.cornerRadius = _topBtn.frame.size.height / 2.f;
        _topBtn.backgroundColor = [UIColor clearColor];
        [_topBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.tag = 3001;
        _topBtn.clipsToBounds = YES;
    }
    return _topBtn;
}
- (UIImageView *)setImgView {
    
    if (!_setImgView) {
        _setImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -40.f,32.f, 20, 20)];
        _setImgView.image = [UIImage imageNamed:@"law_shezhi"];
        _setImgView.userInteractionEnabled = YES;
        _setImgView.backgroundColor = [UIColor clearColor];
    }
    return _setImgView;
}
- (UIImageView *)searchImgView {
    
    if (!_searchImgView) {
        _searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -85.f,32.f, 20, 20)];
        _searchImgView.image = [UIImage imageNamed:@"law_contentSearch"];
        _searchImgView.userInteractionEnabled = YES;
        _searchImgView.backgroundColor = [UIColor clearColor];
    }
    return _searchImgView;
}
- (UIButton *)setBtn {
    
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setBtn.frame = CGRectMake(kMainScreenWidth -45.f,27.f, 30.f, 30.f);
        _setBtn.backgroundColor = [UIColor clearColor];
        [_setBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
        _setBtn.tag = 3002;
    }
    return _setBtn;
}
- (UIButton *)searchBtn {
    
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kMainScreenWidth -90.f,27.f, 30.f, 30.f);
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.tag = 3003;
    }
    return _searchBtn;
}
- (UIView *)searchView {
    
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(xSpace, 30, kMainScreenWidth-xSpace-50, 30)];
        _searchView.layer.cornerRadius = 2.5f;
        _searchView.backgroundColor=[UIColor whiteColor];
        _searchView.layer.masksToBounds = YES;
    }
    return _searchView;
}
- (UITextField *)searchField {
    
    if (!_searchField) {
        _searchField =[[UITextField alloc] initWithFrame:CGRectMake(42.5f, 0, _searchView.frame.size.width-42.5f, 30)];
        _searchField.placeholder = @"搜索本文内容";
        _searchField.delegate = self;
        _searchField.borderStyle = UITextBorderStyleNone;
        _searchField.returnKeyType = UIReturnKeySearch; //设置按键类型
        [_searchField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_searchField];
    }
    return _searchField;
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 //字体大小
 [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'"];
 //字体颜色
 [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
 //页面背景色
 [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'"];
 **/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
