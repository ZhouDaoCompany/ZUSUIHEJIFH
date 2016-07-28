//
//  SelectProvinceVC.m
//  ZhouDao
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectProvinceVC.h"

static NSString *const CELLIDENTIFER = @"SelectCellIdentifier";

@interface SelectProvinceVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@end

@implementation SelectProvinceVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];
    self.statusBarView.backgroundColor = [UIColor whiteColor];
    self.naviBarView.backgroundColor = [UIColor whiteColor];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"D7D7D7"];
    [self.view addSubview:lineView];

    _dataSourceArr = [NSMutableArray arrayWithObjects:@"北京",@"天津",@"上海",@"江苏省",@"河北省",@"河南省",@"湖南省",@"湖北省",@"浙江省",@"云南省",@"陕西省",@"台湾",@"贵州省",@"广西壮族自治区",@"黑龙江省",@"甘肃省",@"吉林省",@"四川省",@"广东省",@"江西省",@"青海省",@"辽宁省",@"香港特别行政区",@"山东省",@"西藏自治区",@"重庆",@"福建省",@"新疆维吾尔自治区",@"内蒙古自治区",@"山西省",@"海南省",@"宁夏回族自治区",@"澳门特别行政区",@"安徽省", nil];
    
    [self.view addSubview:self.tableView];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDENTIFER];
    cell.textLabel.font = Font_15;
    if (_dataSourceArr.count >0) {
        cell.textLabel.text = _dataSourceArr[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"indexRow----%ld",indexPath.row);
    
    self.selectBlock(_dataSourceArr[indexPath.row]);
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
#pragma mark - event response

- (void)rightBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}
#pragma mark - getters and setters
    
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.6f, kMainScreenWidth, kMainScreenHeight-64.6f) style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDENTIFER];
    }
    return _tableView;
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
