//
//  HouseDetailVC.m
//  ZhouDao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HouseDetailVC.h"
#import "ParallaxHeaderView.h"
#import "HouseDetailHeadView.h"
#import "HouseDetailHeadView.h"
#import "PaymentTabViewCell.h"

static NSString *const HOUSEDETAILCELL = @"HouseDetailCell";

@interface HouseDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataSourceArrays;
@property (strong, nonatomic)  ParallaxHeaderView *headerView;
@property (strong, nonatomic) UISegmentedControl *segmentButton;
@end

@implementation HouseDetailVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    
    [self setupNaviBarWithTitle:@"还款详情"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    [_headerView addSubview:self.segmentButton];
}
#pragma mark - event response
- (void)didClicksegmentedControlAction:(UISegmentedControl *)seg
{
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;//[_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentTabViewCell *cell = (PaymentTabViewCell *)[tableView dequeueReusableCellWithIdentifier:HOUSEDETAILCELL];
    [cell settingUI];
    if (_dataSourceArrays.count >0) {
        
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0)?[HouseDetailHeadView instanceHouseDetailHeadViewPaymentMoney:@"2000" withInterest:@"100" withLoan:@"2100" withMonths:@"12"]:[HouseDetailHeadView setOtherSetionTitle:[NSString stringWithFormat:@"第%ld年",section + 1]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0)?130.f:30.f;
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
        [_tableView registerClass:[PaymentTabViewCell class] forCellReuseIdentifier:HOUSEDETAILCELL];
        _tableView.showsVerticalScrollIndicator = NO;
        
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 160)] forSize:CGSizeMake(kMainScreenWidth, 60)];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}
- (UISegmentedControl *)segmentButton
{
    if (!_segmentButton) {
        _segmentButton = [[UISegmentedControl alloc]initWithItems:@[@"等额本息",@"等额本金"]];
        _segmentButton.frame = CGRectMake((kMainScreenWidth - 180)/2.f, 10, 180, 25);
        _segmentButton.selectedSegmentIndex = 0;
        _segmentButton.tintColor = hexColor(FFFFFF);
        NSDictionary* selectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                 NSForegroundColorAttributeName: hexColor(00c8aa)};
        [_segmentButton setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:Font_13,
                                                   NSForegroundColorAttributeName: hexColor(FFFFFF)};
        [_segmentButton setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [_segmentButton addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentButton;
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
