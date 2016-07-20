//
//  ExampleListVC.m
//  ZhouDao
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ExampleListVC.h"
#import "CaseModel.h"
#import "ContentViewController.h"
#import "TaskModel.h"
#import "ExampleDetailData.h"
static NSString *const ExampleIdentifier = @"ExampleIdentifier";

@interface ExampleListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger _page;
//    NSUInteger _currentRow;

}
@property (nonatomic,strong) NSMutableArray *dataArrays;
@property (strong,nonatomic) UITableView *tableView;
@end

@implementation ExampleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}
- (void)initView
{
    [self setupNaviBarWithTitle:_titString];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

//     _currentRow = 0;
    _page = 1;
    _dataArrays = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator= NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ExampleIdentifier];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    if (_exampleType == FromComType) {
        // 马上进入刷新状态
        [_tableView.mj_header beginRefreshing];
    }else{
        [_dataArrays addObjectsFromArray:_searArr];
        [_tableView reloadData];
    }
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{WEAKSELF;
    _page = 1;
    if (_exampleType == FromComType) {
        [NetWorkMangerTools inspeTypeList:_idString withPage:_page RequestSuccess:^(NSArray *arr) {
            
            [weakSelf.dataArrays removeAllObjects];
            [weakSelf.dataArrays addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];

            _page ++;
        } fail:^{
            [weakSelf.dataArrays removeAllObjects];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];

        }];
    }else{
        [NetWorkMangerTools LegalIssuesSelfCheckResult:_searText withPage:_page RequestSuccess:^(NSArray *arr) {
            
            [_dataArrays addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            _page ++;
        } fail:^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
    }
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;[SVProgressHUD show];
    if (_exampleType == FromComType) {
        [NetWorkMangerTools inspeTypeList:_idString withPage:_page RequestSuccess:^(NSArray *arr) {
            
            [_dataArrays addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            arr.count>0?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_footer endRefreshingWithNoMoreData];
            _page ++;
        } fail:^{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
    }else{
        [NetWorkMangerTools LegalIssuesSelfCheckResult:_searText withPage:_page RequestSuccess:^(NSArray *arr) {
            [_dataArrays addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
            arr.count>0?[self.tableView.mj_footer endRefreshing]:[self.tableView.mj_footer endRefreshingWithNoMoreData];
            _page ++;
        } fail:^{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }];
    }
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ExampleIdentifier];
    cell.textLabel.textColor = thirdColor;
    cell.textLabel.font = Font_15;
    cell.textLabel.numberOfLines = 1;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArrays.count >0) {
//        [self LargerAnimationCell:cell WithIndexPathRow:indexPath.row];//动画
        CaseModel *model = _dataArrays[indexPath.row];
        cell.textLabel.text = model.title;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SVProgressHUD show];
    CaseModel *model = _dataArrays[indexPath.row];
    TaskModel *tmodel = [TaskModel new];
    [NetWorkMangerTools loadExampleDetailData:model.id RequestSuccess:^(id obj) {
        ExampleDetailData *tempModel = (ExampleDetailData *)obj;
        tmodel.idString =tempModel.id;
        tmodel.name = model.title;
        tmodel.content = tempModel.content;
        tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
        ContentViewController *vc = [ContentViewController new];
        vc.dType = CaseType;
        vc.model = tmodel;
        [self.navigationController pushViewController:vc animated:YES];

    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//#pragma mark -变大动画
//- (void)LargerAnimationCell:(UIView *)cell WithIndexPathRow:(NSUInteger)row
//{
//    cell.transform  = CGAffineTransformMakeScale(0.8, 0.8);
//    
//    if (row>=_currentRow)
//    {
//        [UIView animateWithDuration:.75 animations:^{
//            cell.transform  = CGAffineTransformIdentity;
//        }];
//    }
//    _currentRow = row;
//    cell.transform  = CGAffineTransformIdentity;
//}

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
