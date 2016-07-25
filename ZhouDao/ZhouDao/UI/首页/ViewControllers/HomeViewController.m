//
//  HomeViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "HomeViewController.h"
#import "HomeHeadView.h"
#import "HomeTableViewCell.h"
#import "ToolsWedViewVC.h"
#import "SCIntroView.h"
#import "LawsViewController.h"
#import "ExampleSearchVC.h"
#import "GovermentVC.h"
#import "CompensationVC.h"
#import "MoreViewController.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import "AMapLocationKit.h"

static NSString *const HomeCellIdentifier = @"HomeCellIdentifier";

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,HomeHeadViewPro,SCIntroViewDataSource,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) HomeHeadView *headView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager *locationService;//定位服务
@property (nonatomic, strong) CLLocation *userLocation;  //我的位置

@end

@implementation HomeViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [DKNightVersionManager nightFalling];
    //    self.view.dk_backgroundColorPicker = DKColorWithColors([UIColor whiteColor], [UIColor blackColor]);
    
    [self userLocationService];//开始定位
    
    if ([PublicFunction ShareInstance].isFirstLaunch) {
        /**
         *  下下次升级时候注销这些代码
         */
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSArray *arr = [NSArray arrayWithObjects:ToolsStorage,TemplateStorage,GovermentStorage,LawsStorage,ExampleSearchStorage,HomeStorage,HomeHotMsg,RecomStorage,RECOMNEWS,RECOMJDPIC,RECOMHOT, nil];
        [arr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [USER_D removeObjectForKey:obj];
            [USER_D synchronize];
        }];
        [SCIntroView showIntrolViewFromView:[QZManager getWindow] dataSource:self introViewContentImageMode:SCIntroViewContentImageModeDefault introViewDoneMode:SCIntroViewDoneModeDefault];
    }
    
    //设置加载图
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    [self initUI];
    
}
- (void)initUI
{
    _dataSourceArrays = [NSMutableArray array];
    [self setupNaviBarWithTitle:@"首页"];
    _headView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 315.f)];
    _headView.delegate = self;
    WEAKSELF;
    _headView.indexBlock = ^(NSInteger index){
        
        switch (index) {
            case 0:
            {//法规
                LawsViewController *lawVC = [LawsViewController new];
                lawVC.lawType = LawFromHome;
                [weakSelf.navigationController pushViewController:lawVC animated:YES];
            }
                break;
            case 1:
            {//查询案例
                ExampleSearchVC *vc = [ExampleSearchVC new];
                vc.sType = SearchFromHome;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {//司法机关
                GovermentVC *govVC = [GovermentVC new];
                govVC.Govtype = GovFromHome;
                [weakSelf.navigationController pushViewController:govVC animated:YES];
            }
                break;
            case 3:
            {//赔偿
                CompensationVC *vc = [CompensationVC new];
                vc.pType = CompensationFromHome;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;

            default:
                break;
        }
        
    };
   
    [self.view addSubview:self.tableView];
    
    [self loadCacheData];
    
    [self loadNewData];
    
    // 马上进入刷新状态
//    [_tableView.mj_header beginRefreshing];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [moreBtn setTitleColor:sixColor forState:0];
    moreBtn.titleLabel.font = Font_14;
    moreBtn.frame = CGRectMake(0, 0, kMainScreenWidth , 40);
    [moreBtn setTitle:@"点击查看更多" forState:0];
    [moreBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = moreBtn;
    
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-114.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _tableView.tableHeaderView = _headView;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:HomeCellIdentifier];
        //MJRefreshBackNormalFooter MJRefreshAutoNormalFooter
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    }
    return _tableView;
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self.tableView.mj_header endRefreshing];
    [SVProgressHUD show];
    [self loadNewData];
}
- (void)loadNewData{
    WEAKSELF;
    [NetWorkMangerTools homeViewAllDataRequestSuccess:^(NSArray *hdArr, NSArray *hotArr) {
        
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.dataSourceArrays addObjectsFromArray:hotArr];
        [weakSelf.headView setDataArrays:hdArr];
        [weakSelf.tableView reloadData];
    } fail:^{
//        [weakSelf loadCacheData];
    }];
}
- (void)loadCacheData{
    WEAKSELF;
    [NetWorkMangerTools readHomeTheCacheSuccess:^(NSArray *hdArr, NSArray *hotArr) {
        
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.headView setDataArrays:hdArr];
        [weakSelf.dataSourceArrays addObjectsFromArray:hotArr];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -HomeHeadViewPro
- (void)getSlideWithCount:(NSUInteger)count;
{
//    BasicModel *obj  = self.headView.dataArrays[count];
//    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,focusGroomInfo,obj.slide_id];
//    ToolsWedViewVC *vc = [ToolsWedViewVC new];
//    vc.url = url;
//    vc.tType = FromHotType;
//    vc.navTitle = obj.slide_name;
//    vc.shareContent = obj.slide_name;
//    [self.navigationController  pushViewController:vc animated:YES];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HomeTableViewCell class]])
    {
        HomeTableViewCell *homeCell = (HomeTableViewCell *)cell;
        if (_dataSourceArrays.count >0) {
            [homeCell setMdoel:_dataSourceArrays[indexPath.row]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_dataSourceArrays.count >0) {
        
        BasicModel *model = _dataSourceArrays[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,DetailsEventHotSpot,model.id];
        ToolsWedViewVC *vc = [ToolsWedViewVC new];
        vc.url = url;
        vc.tType = FromHotType;
        vc.shareContent = model.title;
        vc.navTitle = @"";//model.title;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}
#pragma mark -UIButtonEvent
- (void)loadMoreData
{
    MoreViewController *moreVC = [MoreViewController new];
    moreVC.moreType = RecomType;
    [self.navigationController  pushViewController:moreVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <SCGuideViewDataSource>
- (NSArray *)contentImagesInIntroView:(SCIntroView *)introView {
//    introView.introViewPageControl.hidden = YES;
    return @[
             [UIImage imageNamed:@"Intro_1"],
             [UIImage imageNamed:@"Intro_2"],
             [UIImage imageNamed:@"Intro_3"]
             ];
}
- (UIButton *)doneButtonInIntroView:(SCIntroView *)introView {
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"立即体验->" forState:UIControlStateNormal];
    [doneButton setTitleColor:KNavigationBarColor forState:0];
    doneButton.layer.borderColor = KNavigationBarColor.CGColor;
    doneButton.layer.masksToBounds = YES;
    doneButton.layer.cornerRadius = 5.f;
    doneButton.layer.borderWidth = .6f;
    [doneButton setImage:[UIImage imageNamed:@"IntroStart"] forState:UIControlStateNormal];
    return doneButton;
}
#pragma mark -获取地理位置信息
- (void)userLocationService
{
    _locationService = [[AMapLocationManager alloc] init];
    _locationService.delegate = self;
    [_locationService startUpdatingLocation];//开启定位
}
#pragma mark - MapView Delegate 更新地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (location)
    {
        _userLocation = location;
        [_locationService stopUpdatingLocation];//停止定位
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        //regeo.radius = 10000;
        regeo.requireExtension = YES;
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
    }
    
    DLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        [PublicFunction ShareInstance].locProv = response.regeocode.addressComponent.province;
        [PublicFunction ShareInstance].locCity = response.regeocode.addressComponent.city;
        [PublicFunction ShareInstance].locDistrict = response.regeocode.addressComponent.district;
    }
}
@end
