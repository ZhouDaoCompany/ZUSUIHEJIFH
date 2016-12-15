//
//  TingShiListVC.m
//  GovermentTest
//
//  Created by apple on 16/12/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiListVC.h"
#import "AddTingShiVC.h"
#import "CollectEmptyView.h"
#import "TingShiListCell.h"
#import "TingShiHeadView.h"
#import "Courtroom_base.h"
#import "Courtroom_linkman.h"

static NSString *const LISTCELLIDENTIFER = @"listCellIdentifer";

@interface TingShiListVC ()<CollectEmptyViewPro, UITableViewDelegate, UITableViewDataSource , TingShiHeadViewPro>

@property (nonatomic, strong) CollectEmptyView *emptyView;
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation TingShiListVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
}
#pragma mark - methods

- (void)initUI {
    
    [self setupNaviBarWithTitle:@"庭室信息"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];
    
    [self.view addSubview:self.tableview];
}
- (void)rightBtnAction {
    
    //添加庭室信息
    AddTingShiVC *addVC = [[AddTingShiVC alloc] initWithJidString:_jidString withType:AddTingShi withCourtroom_base:nil];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - TingShiHeadViewPro
- (void)editTingShiListView:(NSUInteger)section {
    
    DLog(@"点击编辑: %ld",section);
    
    Courtroom_base *baseModel = _baseSourceArrays[section];
    AddTingShiVC *addVC = [[AddTingShiVC alloc] initWithJidString:_jidString withType:EditTingShi withCourtroom_base:baseModel];
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    (_baseSourceArrays.count == 0) ? [self.view addSubview:self.emptyView] : [self.emptyView removeFromSuperview];
    return [_baseSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Courtroom_base *baseModel = _baseSourceArrays[section];
    return [baseModel.courtroom_linkman count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TingShiListCell *cell = (TingShiListCell *)[tableView dequeueReusableCellWithIdentifier:LISTCELLIDENTIFER];
    Courtroom_base *baseModel = _baseSourceArrays[indexPath.section];
    [cell setContactUIWithIndexRow:indexPath.row + 1 withCourtroom_base:baseModel];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    Courtroom_base *baseModel = _baseSourceArrays[section];
    return [[TingShiHeadView alloc] initTingShiListPageHeadViewWithState:@"" withTitleString:baseModel.name withSetion:section withDelegate:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

#pragma mark - CollectEmptyViewPro
- (void)clickAddText {
    
    [self rightBtnAction];
}
#pragma mark - setter and getter

- (CollectEmptyView *)emptyView {
    
    if (!_emptyView) {
        
        _emptyView = [[CollectEmptyView alloc] initTingShiTheDefaultWithDelegate:self];
    }
    return _emptyView;
}
- (UITableView *)tableview {
    
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsHorizontalScrollIndicator= NO;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor clearColor];
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableview registerClass:[TingShiListCell class] forCellReuseIdentifier:LISTCELLIDENTIFER];
    }
    return _tableview;
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
