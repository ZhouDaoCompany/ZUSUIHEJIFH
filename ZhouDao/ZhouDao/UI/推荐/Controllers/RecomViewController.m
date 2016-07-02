//
//  RecomViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RecomViewController.h"
#import "HomeTableViewCell.h"
#import "RecomHeadView.h"
#import "ContentViewController.h"
#import "LawDetailModel.h"
#import "NewsLawsVC.h"
#import "CompensationVC.h"
#import "ToolsWedViewVC.h"
#import "MoreViewController.h"

static NSString *const RecomCellIdentifier = @"RecomCellIdentifier";

@interface RecomViewController ()<UITableViewDataSource,UITableViewDelegate,RecomHeadViewPro>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) RecomHeadView *headView;
@end

@implementation RecomViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
- (void)initUI
{
    _dataSourceArrays = [NSMutableArray array];
    [self setupNaviBarWithTitle:@"推荐"];
    
    _headView = [[RecomHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 379)];
    _headView.delegate = self;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-114.f) style:UITableViewStylePlain];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headView;
    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:RecomCellIdentifier];
    //MJRefreshBackNormalFooter MJRefreshAutoNormalFooter
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    // 马上进入刷新状态
    
    [self loadCacheData];
    [self loadNewData];
    
//    [_tableView.mj_header beginRefreshing];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = ViewBackColor;
    [moreBtn setTitleColor:sixColor forState:0];
    moreBtn.titleLabel.font = Font_14;
    moreBtn.frame = CGRectMake(0, 0, kMainScreenWidth , 40);
    [moreBtn setTitle:@"点击查看更多" forState:0];
    [moreBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView = moreBtn;
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self.tableView.mj_header endRefreshing];
    [self loadNewData];
}
- (void)loadNewData{
    WEAKSELF;
    [NetWorkMangerTools recomViewAllRequestSuccess:^(NSArray *hdArr, NSArray *xfArr, NSArray *jdArr, NSArray *hotArr) {
        
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.headView setFlipPageArr:xfArr];
        [weakSelf.headView setRecomArrays:hdArr];
        [weakSelf.headView setJdArrays:jdArr];
        [weakSelf.dataSourceArrays addObjectsFromArray:hotArr];
        [weakSelf.tableView reloadData];
    } fail:^{
//        [weakSelf loadCacheData];
    }];
}
- (void)loadCacheData{
    WEAKSELF;
    [NetWorkMangerTools recomTheCacheSuccess:^(NSArray *hdArr, NSArray *xfArr, NSArray *jdArr, NSArray *hotArr) {
        
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.headView setFlipPageArr:xfArr];
        [weakSelf.headView setRecomArrays:hdArr];
        [weakSelf.headView setJdArrays:jdArr];
        [weakSelf.dataSourceArrays addObjectsFromArray:hotArr];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecomCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *homeCell = (HomeTableViewCell *)cell;
    if (_dataSourceArrays.count >0) {
        [homeCell setMdoel:_dataSourceArrays[indexPath.row]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
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
#pragma mark -RecomHeadViewPro
//幻灯片
- (void)getSlideWithCount:(NSUInteger)count
{
    if (_headView.recomArrays.count > count) {
        [self getBasicObjCount:count withArrays:_headView.recomArrays];
    }
}
//常用法规
- (void)commonRegulations
{
    DLog(@"常用法规");
    NewsLawsVC *vc = [NewsLawsVC new];
    vc.lawType = commonlyType;
    [self.navigationController pushViewController:vc animated:YES];
}
//赔偿标准
- (void)theCompensationStandard
{
    DLog(@"赔偿标准");
    CompensationVC *vc = [CompensationVC new];
    vc.pType = CompensationFromHome;
    [self.navigationController pushViewController:vc animated:YES];
}
//气质文章
- (void)recommendTheArticle
{
    DLog(@"气质文章");
    if (_headView.jdArrays.count >0) {
        BasicModel *obj = _headView.jdArrays[0];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,dailyInfo,obj.slide_id];
        ToolsWedViewVC *vc = [ToolsWedViewVC new];
        vc.url = url;
        vc.tType = FromEveryType;
        vc.shareContent = obj.slide_name;
        vc.navTitle = @"";//model.title;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
#pragma mark - 幻灯
- (void)getBasicObjCount:(NSUInteger)count withArrays:(NSArray *)arr
{
    BasicModel *obj = arr[count];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,focusGroomInfo,obj.slide_id];
    ToolsWedViewVC *vc = [ToolsWedViewVC new];
    vc.url = url;
    vc.tType = FromRecHDType;
    vc.shareContent = obj.slide_name;
    vc.navTitle = @"";//model.title;
    [self.navigationController  pushViewController:vc animated:YES];
}
//滚动条点击
- (void)startAdsClick:(NSString *)idString
{WEAKSELF;
    TaskModel *tmodel = [TaskModel new];
    [NetWorkMangerTools lawsDetailData:idString RequestSuccess:^(id obj) {
        
        LawDetailModel *tempModel = (LawDetailModel *)obj;
        tmodel.idString =tempModel.id;
        tmodel.name = tempModel.name;
        tmodel.content = tempModel.content;
        tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
        ContentViewController *vc = [ContentViewController new];
        vc.dType = lawsType;
        vc.model = tmodel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
