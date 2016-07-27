//
//  SearchResultsVC.m
//  ZhouDao
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SearchResultsVC.h"
#import "LawsTableViewCell.h"
#import "LawDetailModel.h"
#import "TaskModel.h"
#import "ContentViewController.h"

static NSString *const SearchResultsIdentifier = @"SearchResultsIdentifier";
@interface SearchResultsVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSUInteger _page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArrays;
@end

@implementation SearchResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _page = 1;
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"查询结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _dataArrays = [NSMutableArray array];
    [_dataArrays addObjectsFromArray:_arrays];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    self.tableView.showsHorizontalScrollIndicator= NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LawsTableViewCell" bundle:nil] forCellReuseIdentifier:SearchResultsIdentifier];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    [NetWorkMangerTools LawsSearchResultKeyWords:_keyStr withPage:_page RequestSuccess:^(NSArray *arr) {
        
        [_dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        _page++;
    } fail:^{
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawsTableViewCell*cell = (LawsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultsIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LawsTableViewCell class]]) {
        LawsTableViewCell *lawCell = (LawsTableViewCell *)cell;
        if (_dataArrays.count >0) {
            [lawCell setDataModel:_dataArrays[indexPath.row]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawsDataModel *model = _dataArrays[indexPath.row];
    TaskModel *tmodel = [TaskModel new];
    [NetWorkMangerTools lawsDetailData:model.id RequestSuccess:^(id obj) {
        
        LawDetailModel *tempModel = (LawDetailModel *)obj;
        tmodel.idString =tempModel.id;
        tmodel.name = tempModel.name;
        tmodel.content = tempModel.content;
        tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
        ContentViewController *vc = [ContentViewController new];
        vc.dType = lawsType;
        vc.model = tmodel;
        [self.navigationController pushViewController:vc animated:YES];
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
