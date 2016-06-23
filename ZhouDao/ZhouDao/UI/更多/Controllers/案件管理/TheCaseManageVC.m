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
#import "FilterView.h"
#import "AddCaseVC.h"

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
@property (nonatomic,strong) UITextField *searchField;
@property (nonatomic,strong) UIImageView *jtImgView;
@property (nonatomic, strong) UICollectionView *collectionView;//案件
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//数据源
@end

@implementation TheCaseManageVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [_falseImgView removeFromSuperview];
    _falseImgView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"案件管理"];
    if (_type == FromMineType) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    }else{
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:_falseImgView];
        [windows sendSubviewToBack:_falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
        self.navigationController.navigationBarHidden = YES;
    }
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];
    
    DLog(@"lujing-----%@",[NSString stringWithFormat:@"%@",self.rightBtn]);

    [self initSearchView];
    
    _dataSourceArr = [NSMutableArray array];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 119.f , kMainScreenWidth ,kMainScreenHeight-119.f) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[TheCaseCollectionCell class] forCellWithReuseIdentifier:TheCaseIdentifer];
    
    _page = 0;
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.collectionView.mj_header endRefreshing];
        _page = 0;
        _searchField.text = @"";
        [SVProgressHUD show];
        [NetWorkMangerTools arrangeListWithPage:_page RequestSuccess:^(NSArray *arr) {
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
            _page ++;
        } fail:^{
            _page ++;
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [SVProgressHUD show];
        [NetWorkMangerTools arrangeListWithPage:_page RequestSuccess:^(NSArray *arr) {
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
            _page ++;
        } fail:^{
            _page ++;
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }];
    }];

    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView whenCancelTapped:^{
        [self dismissKeyBoard];
    }];
}
- (void)initSearchView
{
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 55.f)];
    bigView.backgroundColor = ViewBackColor;
    [self.view addSubview:bigView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(15, 12.5f, 50, 30);
    [btn addTarget:self action:@selector(filterBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:btn];
    
    UILabel *sxLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32.5, 30)];
    sxLab.textColor = [UIColor colorWithHexString:@"#999999"];
    sxLab.text = @"筛选";
    sxLab.font = Font_15;
    [btn addSubview:sxLab];
    
    UIImageView *jtImgView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 12.5f, 12.f, 6.5f)];
    jtImgView.image = [UIImage imageNamed:@"case_jianTou"];
    jtImgView.userInteractionEnabled = YES;
    _jtImgView = jtImgView;
    [btn addSubview:_jtImgView];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(90, 12.5, kMainScreenWidth-106.f, 30)];
    [bigView addSubview:searchView];
    searchView.backgroundColor= [UIColor whiteColor];
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 2.f;
    searchView.layer.borderColor = lineColor.CGColor;
    searchView.layer.borderWidth = .5f;
    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 20, 20)];
    [searchView addSubview:search];
    search.image = [UIImage imageNamed:@"law_sousuo"];
    
    _searchField =[[UITextField alloc] initWithFrame:CGRectMake(32, 0, searchView.frame.size.width-32, 30)];
    [self.view addSubview:_searchField];
    _searchField.placeholder = @"请输入关键字";
    _searchField.delegate = self;
    [_searchField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchField setValue:Font_15 forKeyPath:@"_placeholderLabel.font"];
    _searchField.returnKeyType = UIReturnKeySearch; //设置按键类型
    [searchView addSubview:_searchField];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_searchField];

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TheCaseCollectionCell * cell = (TheCaseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TheCaseIdentifer forIndexPath:indexPath];
    if (_dataSourceArr.count >0) {
        [cell setDataModel:_dataSourceArr[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissKeyBoard];
//    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    ManagerData *model = _dataSourceArr[row];
    NSUInteger count;
    if ([model.type integerValue] == 1) {
        count = 2;
    }else if ([model.type integerValue] == 2){
        count = 0;
    }else{
        count = 1;
    }
    WEAKSELF;
    [SVProgressHUD dismiss];
    [NetWorkMangerTools arrangeInfoWithIdString:model.id RequestSuccess:^(NSMutableArray *obj) {
        TheCaseDetailVC *vc = [TheCaseDetailVC new];
        vc.caseId = model.id;
        vc.type = count;
        vc.msgArrays  = obj;
        [weakSelf.navigationController  pushViewController:vc animated:YES];
    }];
     //    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",section,row);
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
    DLog(@"添加案件");
    AddCaseVC *vc = [AddCaseVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)filterBtnEvent:(id)sender
{
    DLog(@"筛选条件");
    [self dismissKeyBoard];
    WEAKSELF;
    [UIView animateWithDuration:.2 animations:^{
        weakSelf.jtImgView.transform = CGAffineTransformRotate(weakSelf.jtImgView.transform, REES_TO_RADIANS(180));
    }];

    FilterView *views = [[FilterView alloc] initWithFrame:kMainScreenFrameRect];
    views.filterBlock = ^{
        weakSelf.jtImgView.transform = CGAffineTransformIdentity;
    };
    views.urlBlock = ^(NSString *url){
        [SVProgressHUD dismiss];
        [NetWorkMangerTools arrangeSearchUrl:url RequestSuccess:^(NSArray *arr) {
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        } fail:^{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }];
    };
    [self.view addSubview:views];
}
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
{    DLog(@"去搜索");
    WEAKSELF;
    if (_searchField.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您填写搜索内容"];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&content=%@",kProjectBaseUrl,arrangeSearch,UID,_searchField.text];
    [NetWorkMangerTools arrangeSearchUrl:url RequestSuccess:^(NSArray *arr) {
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
    } fail:^{
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
