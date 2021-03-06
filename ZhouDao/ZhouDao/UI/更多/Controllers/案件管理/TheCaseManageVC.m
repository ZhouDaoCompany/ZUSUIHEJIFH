//
//  TheCaseManageV.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TheCaseManageVC.h"
#import "TheCaseCollectionCell.h"
#import "TheCaseDetailVC.h"
//#import "FilterView.h"
#import "CollectEmptyView.h"

#import "KxMenu.h"
#import "OnlyAddCaseVC.h"

static float const kCollectionViewToLeftMargin                = 22.5f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 22.5f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 22.5f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 10.f;//每行之间的距离;

#define caseWidth ([UIScreen mainScreen].bounds.size.width- 90.f)/3.f
#define caseHeight [UIScreen mainScreen].bounds.size.height>667?210:([UIScreen mainScreen].bounds.size.height >568?190:165)

static NSString *const TheCaseIdentifer = @"TheCaseIdentifer";
@interface TheCaseManageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    NSUInteger _page;//分页

}
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIImageView *jtImgView;
@property (nonatomic, strong) UICollectionView *collectionView;//案件
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//数据源
@property (nonatomic, strong) NSMutableArray *searchDataArr;//搜索数据源
@property (nonatomic, assign) BOOL  isSearch;//判断是否是搜索状态
@property (nonatomic, strong) UIImageView *addImgView;
@property (nonatomic, strong) UIImageView *searchImgView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) CollectEmptyView *emptyView;   //案件为空时候

@end

@implementation TheCaseManageVC

#pragma mark - life cycle
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI{
    
    if (_type == FromMineType) {
        
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    }else{
        
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:self.falseImgView];
        [windows sendSubviewToBack:self.falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
        self.navigationController.navigationBarHidden = YES;
    }

    _page = 0;

    [self.view addSubview:self.collectionView];
    [self initSearchView];
    [self.collectionView.mj_header beginRefreshing];
    WEAKSELF;
    [self.collectionView whenCancelTapped:^{
        
        [weakSelf dismissKeyBoard];
    }];
}
#pragma mark - 增加刷新操作
- (void)addTabRefresh{
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{WEAKSELF;
    [weakSelf.collectionView.mj_header endRefreshing];
    _page = 0;
    weakSelf.searchField.text = @"";
    [MBProgressHUD showMBLoadingWithText:nil];
    [NetWorkMangerTools arrangeListWithPage:_page RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        _page ++;
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    [MBProgressHUD showMBLoadingWithText:nil];
    [NetWorkMangerTools arrangeListWithPage:_page RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        _page ++;
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];

}
#pragma mark - 创建搜索框
- (void)initSearchView
{WEAKSELF;
    
    if (_isSearch == YES) {
        _collectionView.mj_header = nil;
        _collectionView.mj_footer = nil;
        [self setupNaviBarWithBtn:NaviRightBtn title:@"取消" img:nil];
        self.rightBtn.titleLabel.font = Font_15;
        TTVIEW_RELEASE_SAFELY(_addImgView);
        TTVIEW_RELEASE_SAFELY(_searchImgView);

        [self.view addSubview:self.searchView];
        
        UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
        [_searchView addSubview:search];
        search.userInteractionEnabled = YES;
        [search whenTapped:^{
            
            [weakSelf dismissKeyBoard];
            [weakSelf serchEvent];
        }];
        search.image = [UIImage imageNamed:@"law_sousuo"];
        
        [_searchView addSubview:self.searchField];
        
    }else {
        TTVIEW_RELEASE_SAFELY(_searchView);
        
        [self addTabRefresh];
        [self.rightBtn setTitle:@"" forState:0];
        [self setupNaviBarWithBtn:NaviRightBtn title:nil img:nil];
        [self setupNaviBarWithTitle:@"案件管理"];
        [self.view addSubview:self.addImgView];
        [_addImgView whenTapped:^{
            
            [weakSelf rightBtnAction];
        }];
        
        [self.view addSubview:self.searchImgView];
        [_searchImgView whenTapped:^{
            
            weakSelf.isSearch = !weakSelf.isSearch;
            [weakSelf initSearchView];
            [weakSelf.collectionView reloadData];
        }];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_isSearch == YES) {
        (self.searchDataArr.count == 0)?[self.view addSubview:self.emptyView]:[self.emptyView removeFromSuperview];
        return [self.searchDataArr count];
    }
    (self.dataSourceArr.count == 0)?[self.view addSubview:self.emptyView]:[self.emptyView removeFromSuperview];
    return [self.dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TheCaseCollectionCell * cell = (TheCaseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TheCaseIdentifer forIndexPath:indexPath];
    if (_isSearch == YES) {
        if (self.searchDataArr.count >0) {
            [cell setDataModel:self.searchDataArr[indexPath.row]];
        }
    }else{
        if (self.dataSourceArr.count >0) {
            [cell setDataModel:self.dataSourceArr[indexPath.row]];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissKeyBoard];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

//    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    ManagerData *model =(_isSearch == YES)?_searchDataArr[row]:_dataSourceArr[row];
    
    NSUInteger count;
    if ([model.type integerValue] == 1) {
        count = 2;
    }else if ([model.type integerValue] == 2){
        count = 0;
    }else{
        count = 1;
    }
    
    TheCaseDetailVC *vc = [TheCaseDetailVC new];
    vc.caseId = model.id;
    vc.type = count;
    vc.caseName = model.name;
    [self.navigationController  pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(caseWidth, caseHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsHorizonMargin;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsSection;
}
#pragma mark -UIButtonEvent
- (void)leftBtnAction
{
    if (_type == FromMineType) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)rightBtnAction
{
    if (_isSearch == YES) {
        _isSearch = NO;
        [_searchDataArr removeAllObjects];
        [self initSearchView];
        [self.collectionView reloadData];
    }else{
        DLog(@"添加案件");
//        AddCaseVC *vc = [AddCaseVC new];
//        [self.navigationController pushViewController:vc animated:YES];
        
        NSArray *titArr = @[@"诉讼业务",@"非诉业务",@"法律顾问"];
        NSArray *imgArr = @[@"case_mangeSS",@"case_mangeFS",@"case_mangerGW"];
        [self showMenu:nil withTitArr:titArr withImgArr:imgArr];
    }
}
- (void)showMenu:(UIButton *)sender
      withTitArr:(NSArray *)titArr
      withImgArr:(NSArray *)imgArr
{
    
    NSMutableArray *menuItems =[NSMutableArray array];
    
    [titArr enumerateObjectsUsingBlock:^(NSString *tit, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [menuItems addObject:[KxMenuItem menuItem:titArr[idx]
                                            image:[UIImage imageNamed:imgArr[idx]]
                                           target:self
                                           action:@selector(pushMenuItem:)]];
    }];
    
    [menuItems enumerateObjectsUsingBlock:^(KxMenuItem *first, NSUInteger idx, BOOL * _Nonnull stop) {
        first.foreColor = THIRDCOLOR;
    }];
    
    [KxMenu setTitleFont:Font_13];
    CGRect frame = CGRectMake(kMainScreenWidth -40.f,32.f, 20, 20);
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}
- (void) pushMenuItem:(id)sender
{
    KxMenuItem *kx = (KxMenuItem *)sender;
    DLog(@"%@", kx.title);
    OnlyAddCaseVC *vc = [OnlyAddCaseVC new];
    if ([kx.title isEqualToString:@"诉讼业务"]) {
        vc.addType = AddLitigation;
    }else if ([kx.title isEqualToString:@"非诉业务"]){
        vc.addType = AddAccusing;
    }else{
        vc.addType = AddConsultant;
    }
    vc.addSuccessBlock = ^(){
        [self.collectionView.mj_header beginRefreshing];
    };

    [self.navigationController pushViewController:vc animated:YES];

}
//- (void)filterBtnEvent:(id)sender
//{
//    DLog(@"筛选条件");
//    [self dismissKeyBoard];
//    WEAKSELF;
//    [UIView animateWithDuration:.2 animations:^{
//        weakSelf.jtImgView.transform = CGAffineTransformRotate(weakSelf.jtImgView.transform, REES_TO_RADIANS(180));
//    }];
//
//    FilterView *views = [[FilterView alloc] initWithFrame:kMainScreenFrameRect];
//    views.filterBlock = ^{
//        weakSelf.jtImgView.transform = CGAffineTransformIdentity;
//    };
//    views.urlBlock = ^(NSString *url){
//        [SVProgressHUD dismiss];
//        [NetWorkMangerTools arrangeSearchUrl:url RequestSuccess:^(NSArray *arr) {
//
//            [weakSelf.dataSourceArr removeAllObjects];
//            [weakSelf.dataSourceArr addObjectsFromArray:arr];
//            [weakSelf.collectionView reloadData];
//            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//        } fail:^{
//            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//        }];
//    };
//    [self.view addSubview:views];
//}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self serchEvent];
    return true;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
}
#pragma mark -搜索方法
- (void)serchEvent
{
    DLog(@"去搜索");
    WEAKSELF;
    if (_searchField.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您填写搜索内容"];
        return;
    }
    [self dismissKeyBoard];
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&content=%@",kProjectBaseUrl,arrangeSearch,UID,_searchField.text];
    [NetWorkMangerTools arrangeSearchUrl:url RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.searchDataArr removeAllObjects];
        [weakSelf.searchDataArr addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    } fail:^{
        [weakSelf.searchDataArr removeAllObjects];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark - 放下键盘
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - setter and getter
- (UIImageView *)falseImgView
{
    if (!_falseImgView) {
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
    }
    return _falseImgView;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.f , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[TheCaseCollectionCell class] forCellWithReuseIdentifier:TheCaseIdentifer];
    }
    return _collectionView;
}
- (CollectEmptyView *)emptyView
{
    if (!_emptyView) {
       _emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 64.f, kMainScreenWidth, kMainScreenHeight-64.f) WithText:@"暂无案件"];
    }
    return _emptyView;
}
- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(40, 30, kMainScreenWidth-90, 30)];
        _searchView.layer.cornerRadius = 2.5f;
        _searchView.backgroundColor=[UIColor whiteColor];
        _searchView.layer.masksToBounds = YES;
    }
    return _searchView;
}
- (UIImageView *)addImgView
{
    if (!_addImgView) {
       _addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -40.f,32.f, 20, 20)];
        _addImgView.image = [UIImage imageNamed:@"mine_addNZ"];
        _addImgView.userInteractionEnabled = YES;
    }
    return _addImgView;
}
- (UIImageView *)searchImgView
{
    if (!_searchImgView) {
        _searchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth -85.f,32.f, 20, 20)];
        _searchImgView.image = [UIImage imageNamed:@"law_contentSearch"];
        _searchImgView.userInteractionEnabled = YES;
    }
    return _searchImgView;
}
- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField =[[UITextField alloc] initWithFrame:CGRectMake(42.5f, 0, self.searchView.frame.size.width-42.5f, 30)];
        _searchField.placeholder = @"请输入关键字";
        _searchField.delegate = self;
        _searchField.borderStyle = UITextBorderStyleNone;
        [_searchField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [_searchField setValue:Font_15 forKeyPath:@"_placeholderLabel.font"];
        _searchField.returnKeyType = UIReturnKeySearch; //设置按键类型
        [_searchField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_searchField];
    }
    return _searchField;
}
- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
-(NSMutableArray *)searchDataArr
{
    if (!_searchDataArr) {
        _searchDataArr = [NSMutableArray array];
    }
    return _searchDataArr;
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
