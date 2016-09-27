//
//  InjuryResultVC.m
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "InjuryResultVC.h"
#import "InjuryHeadView.h"
#import "ParallaxHeaderView.h"
#import "InjuryViewCell.h"

static NSString *const INJURYRESULTCELL = @"injurycellid";

@interface InjuryResultVC ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;

@end

@implementation InjuryResultVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"计算结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    self.dataSourceArrays = _detailDictionary[@"mutableArrays"];
    
    [self.view addSubview:self.tableView];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        [(ParallaxHeaderView*)_tableView.tableHeaderView  layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    InjuryViewCell *cell = (InjuryViewCell *)[tableView dequeueReusableCellWithIdentifier:INJURYRESULTCELL];
    
    if (_dataSourceArrays.count >0) {
        NSDictionary *dict = _dataSourceArrays[indexPath.row];
        [cell settingUIDetailWithDictionary:dict];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0)?[InjuryHeadView instancePersonalHeadViewWithDictionary:_detailDictionary]:nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0)?145.f:10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark - setter and getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[InjuryViewCell class] forCellReuseIdentifier:INJURYRESULTCELL    ];
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 145)] forSize:CGSizeMake(kMainScreenWidth, 1)];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
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
