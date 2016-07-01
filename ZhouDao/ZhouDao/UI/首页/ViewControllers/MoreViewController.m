//
//  MoreViewController.m
//  ZhouDao
//
//  Created by cqz on 16/5/23.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MoreViewController.h"
#import "HomeTableViewCell.h"
#import "ToolsWedViewVC.h"

static NSString *const MoreCellIdentifier = @"MoreCellIdentifier";

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger _page;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    _page = 0;
    _dataSourceArrays = [NSMutableArray array];
    [self setupNaviBarWithTitle:@"时事热点"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:MoreCellIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];

}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{WEAKSELF;
    [self.dataSourceArrays removeAllObjects];
    _page = 0;
    [weakSelf.tableView.mj_header endRefreshing];
    NSString *url = [NSString stringWithFormat:@"%@%@%ld",kProjectBaseUrl,hotspotAll,(unsigned long)_page];
    [NetWorkMangerTools loadMoreDataHomePage:url RequestSuccess:^(NSArray *arr) {
        [weakSelf.dataSourceArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;

    } fail:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    NSString *url = [NSString stringWithFormat:@"%@%@%ld",kProjectBaseUrl,hotspotAll,(unsigned long)_page];
    [NetWorkMangerTools loadMoreDataHomePage:url RequestSuccess:^(NSArray *arr) {
        [weakSelf.dataSourceArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MoreCellIdentifier];
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
        vc.navTitle = @"";//model.title;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
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
