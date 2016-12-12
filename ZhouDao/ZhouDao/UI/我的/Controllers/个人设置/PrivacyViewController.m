//
//  PrivacyViewController.m
//  GovermentTest
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PrivacyViewController.h"
#import "PrivacyTableViewCell.h"

static NSString *const PrivacyCellIdentifier = @"PrivacyCellIdentifier";

@interface PrivacyViewController ()<UITableViewDelegate, UITableViewDataSource> {
    
    NSUInteger _currentRow;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) UIView *footView;//表脚
@end

@implementation PrivacyViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

#pragma mark - methods
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"隐私信息设置"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    _currentRow = 1;
    [self.view addSubview:self.tableview];
    _tableview.tableFooterView = self.footView;

}
- (void)commitButtonEvent:(UIButton *)btn {
    
    DLog(@"提交");
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PrivacyTableViewCell *cell = (PrivacyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PrivacyCellIdentifier];
    NSUInteger indexRow = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.msgArrays = self.dataSourceArrays;
    [cell setIndexRow:indexRow];
    cell.isSelected = (indexRow == _currentRow) ? YES : NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentRow = indexPath.row;
    [_tableview  reloadData];
}
#pragma mark - setter and getter

- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {

        _dataSourceArrays = [NSMutableArray arrayWithObjects:@"",[NSDictionary dictionaryWithObjectsAndKeys:@"信息公开",@"title",@"该信息由张文律师、李莉律师修订过、供您参考",@"message", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"信息半公开",@"title",@"该信息由张**律师、李**律师修订过、供您参考",@"message", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"信息不公开",@"title",@"该信息由**律师、**律师修订过、供您参考",@"message", nil], nil];
    }
    return _dataSourceArrays;
}
- (UITableView *)tableview {
    
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsHorizontalScrollIndicator= NO;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableview registerNib:[UINib nibWithNibName:@"PrivacyTableViewCell" bundle:nil] forCellReuseIdentifier:PrivacyCellIdentifier];
    }
    return _tableview;
}
- (UIView *)footView {
    
    if (!_footView) {
        
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
        _footView.backgroundColor = hexColor(F2F2F2);
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake((kMainScreenWidth - 90)/2.f, 25, 90, 30)];
        commitButton.backgroundColor = [UIColor blackColor];
        commitButton.backgroundColor = hexColor(00c8aa);
        [commitButton addTarget:self action:@selector(commitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [commitButton setTitle:@"提交" forState:0];
        commitButton.titleLabel.font = Font_14;
        commitButton.layer.masksToBounds = YES;
        commitButton.layer.cornerRadius = 3.f;
        [_footView addSubview:commitButton];
    }
    return _footView;
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
