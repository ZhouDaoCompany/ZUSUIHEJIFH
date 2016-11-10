//
//  BreachDetailVC.m
//  ZhouDao
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BreachDetailVC.h"
#import "ParallaxHeaderView.h"
#import "BreachHeadView.h"
#import "BreachDetailCell.h"

static NSString *const BREACHDETAILCELL = @"BreachDetailCellid";

@interface BreachDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)  ParallaxHeaderView *headerView;
@property (nonatomic, strong)  NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation BreachDetailVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - private methods
- (void)initUI
{
    self.dataSourceArrays = _detailDictionary[@"MutableArrays"];
    NSString *tit = (_detailType == BreachType)?@"违约金分段详情":@"利息分段详情";
    [self setupNaviBarWithTitle:tit];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    [_tableView setTableFooterView:self.bottomLabel];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 18, kMainScreenWidth - 60, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.textColor = hexColor(FFFFFF);
    NSString *headTit = (_detailType == BreachType)?@"违约金累加/总计金额（元）":@"利息累加/总计金额（元）";
    titleLabel.text = headTit;
    [_headerView addSubview:titleLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, Orgin_y(titleLabel), kMainScreenWidth - 60, 20)];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:20.f];
    moneyLabel.textColor = hexColor(FFFFFF);
    moneyLabel.text = _detailDictionary[@"BreachMoney"];
    [_headerView addSubview:moneyLabel];

    [_bottomLabel whenCancelTapped:^{
        
        DLog(@"点击跳转");
        
    }];

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
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BreachDetailCell *cell = (BreachDetailCell *)[tableView dequeueReusableCellWithIdentifier:BREACHDETAILCELL];
    if (_dataSourceArrays.count >0) {
        
        [cell settUIWithArrays:_dataSourceArrays[indexPath.row]];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BreachHeadView *secitionView = [[BreachHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 75.f) WithMoney:_detailDictionary[@"AllMoney"] withDate:_detailDictionary[@"AllDays"] withRate:_detailDictionary[@"ReatType"]];
    return secitionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75.f;
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
        [_tableView registerClass:[BreachDetailCell class] forCellReuseIdentifier:BREACHDETAILCELL];
        _tableView.showsVerticalScrollIndicator = NO;
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 100)] forSize:CGSizeMake(kMainScreenWidth, 100)];
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
- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(999999);
        _bottomLabel.font = Font_12;
        _bottomLabel.text = @"按《人民银行利率表》进行计算，结果仅供参考。";
    }
    return _bottomLabel;
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
