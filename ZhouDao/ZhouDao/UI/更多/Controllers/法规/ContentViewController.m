//
//  ContentViewController.m
//  ZhouDao
//
//  Created by cqz on 16/3/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ContentViewController.h"
#import "DWBubbleMenuButton.h"
#import "UIWebView+Load.h"
#import "UIWebView+HTML5.h"
#import "ZD_SettingBottomBar.h"
#import "ZD_ListView.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "AboutReadView.h"
#import "UIWebView_SearchWebView.h"
#import "LawDetailModel.h"
/*菜单*/
#import "DLWMMenu.h"
#import "DLWMMenuAnimator.h"
#import "DLWMSpringMenuAnimator.h"
#import "DLWMSelectionMenuAnimator.h"
#import "DLWMLinearLayout.h"
#import "LoginViewController.h"
#define NoCollected [NSMutableArray arrayWithObjects:@"law_xiangguan",@"law_jiegou",@"law_share",@"law_shoucang", nil];
#define Collected [NSMutableArray arrayWithObjects:@"law_xiangguan",@"law_jiegou",@"law_share",@"law_selectedSC", nil];

#define xSpace 40
@interface ContentViewController ()<UIWebViewDelegate,ZD_SettingBottomBarPro,UITextFieldDelegate,DLWMMenuDataSource, DLWMMenuItemSource, DLWMMenuDelegate, DLWMMenuItemDelegate,AboutReadViewPro>
{
    NSString *_navTitle;
}
@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic , strong) DWBubbleMenuButton *dingdingAnimationMenu;
@property (nonatomic, strong)UITextField *searchField;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) UIImageView *setImgView;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (readwrite, strong, nonatomic) DLWMMenu *menu;
@property (nonatomic, strong) NSMutableArray *imgNameArrays;
@property (nonatomic, strong) NSMutableArray *aboutArrays;//相关阅读
@end

@implementation ContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initUI];
}
- (void)initUI
{
    _navTitle = @"";
    if (_dType == lawsType) {
        _navTitle = @"法规详情";
    }else if (_dType == IndemnityType){
        _navTitle = @"赔偿标准详情";
    }else {
        _navTitle = @"案例详情";
    }
    [self setupNaviBarWithTitle:_navTitle];

    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    self.view.backgroundColor = ViewBackColor;
    _webView.backgroundColor = [UIColor clearColor];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [_webView loadHTMLString:_model.content baseURL:nil];
    _webView.scalesPageToFit = NO;//禁止用户缩放页面
    [_webView setOpaque:NO]; //不设置这个值 页面背景始终是白色
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:_webView];
    
    NSString *backViewColor = [USER_D objectForKey:@"WebViewColor"];
    if (backViewColor.length>0) {
        self.view.backgroundColor = [UIColor colorWithHexString:backViewColor];
    }
    if ([_model.is_collection isEqualToString:@"0"]) {
        _imgNameArrays = NoCollected;
    }else{
        _imgNameArrays = Collected;
    }

    [self dingdingAnimation];

    [self addButtonTarget];
}
- (void)OnclikeWeb
{
    [self showBotomView];
}
#pragma mark -添加按钮
- (void)addButtonTarget
{
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"law_fanhuidingbu"] forState:0];
    topBtn.frame = CGRectMake(kMainScreenWidth -55.f, kMainScreenHeight-60.f, 40.f, 40.f);
    topBtn.layer.cornerRadius = topBtn.frame.size.height / 2.f;
    topBtn.backgroundColor = [UIColor clearColor];
    [topBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
    //topBtn.alpha = .3f;
    topBtn.tag = 3001;
    topBtn.clipsToBounds = YES;
    [self.view addSubview:topBtn];
    
    UIImageView *setImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -40.f,32.f, 20, 20)];
    setImgView.image = [UIImage imageNamed:@"law_shezhi"];
    setImgView.userInteractionEnabled = YES;
    setImgView.backgroundColor = [UIColor clearColor];
    _setImgView = setImgView;
    [self.view addSubview:_setImgView];

    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(kMainScreenWidth -45.f,27.f, 30.f, 30.f);
    setBtn.backgroundColor = [UIColor clearColor];
    [setBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
    setBtn.tag = 3002;
    _setBtn = setBtn;
    [self.view addSubview:_setBtn];
    
    UIImageView *searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -85.f,32.f, 20, 20)];
    searchImgView.image = [UIImage imageNamed:@"law_contentSearch"];
    searchImgView.userInteractionEnabled = YES;
    searchImgView.backgroundColor = [UIColor clearColor];
    _searchImgView = searchImgView;
    [self.view addSubview:_searchImgView];

    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(kMainScreenWidth -90.f,27.f, 30.f, 30.f);
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(backWebTopEvent:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.tag = 3003;
    _searchBtn = searchBtn;
    [self.view addSubview:_searchBtn];
    
}

#pragma mark -UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    
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
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

#pragma mark - UIButtonEvent
- (void)backWebTopEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    
    switch (index) {
        case 3001:
        {
            [_webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 3002:
        {//设置
            [self showBotomView];
        }
            break;
        case 3003:
        {//搜索
            [self isSearchState];
        }
            break;
            
        default:
            break;
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
    NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
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
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(xSpace, 30, kMainScreenWidth-xSpace-50, 30)];
    searchView.layer.cornerRadius = 2.5f;
    searchView.backgroundColor=[UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    _searchView = searchView;
    [self.view addSubview:_searchView];
    
    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    [_searchView addSubview:search];
    search.userInteractionEnabled = YES;
    [search whenTapped:^{
        
        [weakSelf dismissKeyBoard];
        [weakSelf searchKeyText];
    }];
    search.image = [UIImage imageNamed:@"law_sousuo"];
    
    _searchField =[[UITextField alloc] initWithFrame:CGRectMake(42.5f, 0, searchView.frame.size.width-42.5f, 30)];
    _searchField.placeholder = @"搜索本文内容";
    _searchField.delegate = self;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.returnKeyType = UIReturnKeySearch; //设置按键类型
    [_searchView addSubview:_searchField];
    [_searchField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_searchField];
}
- (void)rightBtnAction
{
    [self.webView removeAllHighlights];
    NSString *titleStr = self.rightBtn.titleLabel.text;
    if ([titleStr isEqualToString:@"取消"]) {
        [_searchView removeFromSuperview];
        _searchView = nil;
        _searchField = nil;
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
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}
/*------------------------------萌萌的分割线----------------------------------*/
/**
 *  仿造钉钉菜单动画
 */
-(void)dingdingAnimation{
    
    [_menu removeFromSuperview];
    id<DLWMMenuLayout> layout = [[self class] layout];
    _menu = [[DLWMMenu alloc] initWithMainItemView:[self viewForMainItemInMenu:nil]
                                                 dataSource:self
                                                 itemSource:self
                                                   delegate:self
                                               itemDelegate:self
                                                     layout:layout
                                          representedObject:self];
    _menu.openAnimationDelayBetweenItems = 0.1;
    _menu.closeAnimationDelayBetweenItems = 0.01;
    _menu.frame = CGRectMake(kMainScreenWidth - 55.f,kMainScreenHeight - 110.f,40,40);
//    self.menu = _menu;
    [self.view addSubview:self.menu];
}
#pragma mark - DLWMMenuLayout

+ (id<DLWMMenuLayout>)layout {
    return [[DLWMLinearLayout alloc] initWithAngle:M_PI_2 * 3 itemSpacing:45.0 centerSpacing:50.0];
}

#pragma mark - DLWMMenuDataSource Protocol

- (NSUInteger)numberOfObjectsInMenu:(DLWMMenu *)menu {
    return 4;
}

- (id)objectAtIndex:(NSUInteger)index inMenu:(DLWMMenu *)menu {
    
    return @(index);
}

#pragma mark - DLWMMenuItemSource Protocol

+ (UIImageView *)menuItemView {
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    return view;
}

- (UIImageView *)viewForMainItemInMenu:(DLWMMenu *)menu {
    UIImageView *view = [[self class] menuItemView];
    view.bounds = CGRectMake(0.0, 0.0, 40.0, 40.0);
    view.layer.cornerRadius = 20.0;
    view.image = [UIImage imageNamed:@"law_contenAdd"];
    return view;
}
- (UIImageView *)viewForObject:(id)object atIndex:(NSUInteger)index inMenu:(DLWMMenu *)menu {
    UIImageView *view = [[self class] menuItemView];
    view.bounds = CGRectMake(0.0, 0.0, 40.0, 40.0);
    view.layer.cornerRadius = 20.0;
    view.image = [UIImage imageNamed:_imgNameArrays[index]];
    view.tag = 9000+index;
    return view;
}
#pragma mark -
#pragma mark - DLWMMenuDelegate Protocol
- (void)receivedSingleTap:(UITapGestureRecognizer *)recognizer onItem:(DLWMMenuItem *)item inMenu:(DLWMMenu *)menu {
    NSUInteger index = item.contentView.tag;
    if ([menu isClosedOrClosing]) {
        [menu open];
    } else if ([menu isOpenedOrOpening]) {
        if (item == menu.mainItem) {
            [menu close];
        } else {
            [menu closeWithSpecialAnimator:[[DLWMSelectionMenuAnimator alloc] init] forItem:item];
        }
    }

    switch (index) {
        case 9003:
        {//收藏
            [self JudgeCollectionMethod];
        }
            break;
        case 9002:
        {//分享
            [self shareThisArticle];
        }
            break;
        case 9001:
        {//目录
            [JKPromptView showWithImageName:nil message:@"开发中..."];
//            ZD_ListView *listviews = [[ZD_ListView alloc] initWithFrame:kMainScreenFrameRect];
//            [self.view addSubview:listviews];
        }
            break;
        case 9000:
        {//相关
            [self aboutLawMethod];
        }
            break;
        default:
            break;
    }
    
}
- (void)receivedSingleTap:(UITapGestureRecognizer *)recognizer outsideOfMenu:(DLWMMenu *)menu {
    [menu close];
}
- (void)receivedPan:(UIPanGestureRecognizer *)recognizer onItem:(DLWMMenuItem *)item inMenu:(DLWMMenu *)menu {
    if (item == menu.mainItem)
    {
        [menu moveTo:[recognizer locationInView:menu.superview] animated:NO];
    }
}

- (void)willOpenMenu:(DLWMMenu *)menu withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:.1f animations:^{
        menu.mainItem.transform =  CGAffineTransformRotate(menu.mainItem.transform, REES_TO_RADIANS(45));
    }];
    
}
- (void)didCloseMenu:(DLWMMenu *)menu {
    [UIView animateWithDuration:.1f animations:^{
        menu.mainItem.transform =  CGAffineTransformIdentity;
    }];
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
            [JKPromptView showWithImageName:nil message:@"暂无相关阅读"];
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
        [JKPromptView showWithImageName:nil message:@"登录后才能收藏"];
        LoginViewController *loginVc = [LoginViewController new];
        loginVc.closeBlock = ^{
            if ([PublicFunction ShareInstance].m_bLogin == YES)
            {
                [NetWorkMangerTools lawsDetailData:_model.idString RequestSuccess:^(id obj) {
                    
                    LawDetailModel *tempModel = (LawDetailModel *)obj;
                    weakSelf.model.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
                    if ([weakSelf.model.is_collection isEqualToString:@"0"]) {
                        weakSelf.imgNameArrays = NoCollected;
                        [weakSelf govCollectionMethod];
                    }else{
                        weakSelf.imgNameArrays = Collected;
                        [weakSelf dingdingAnimation];
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
            [weakSelf dingdingAnimation];
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
        [weakSelf dingdingAnimation];
    }];
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
