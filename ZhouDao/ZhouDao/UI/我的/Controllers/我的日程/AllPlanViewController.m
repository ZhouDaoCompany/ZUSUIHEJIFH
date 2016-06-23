//
//  AllPlanViewController.m
//  ZhouDao
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AllPlanViewController.h"
#import "PlanTableViewCell.h"
#import "AddAlertVC.h"
#import "RemindData.h"

static NSString *const AllPlanCellIdentifier = @"AllPlanCellIdentifier";

@interface AllPlanViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArr;
@end

@implementation AllPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];

}
- (void)initUI
{
    _dataSourceArr = [NSMutableArray array];
    [self setupNaviBarWithTitle:@"全部日程"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PlanTableViewCell" bundle:nil] forCellReuseIdentifier:AllPlanCellIdentifier];
    [self loadData];
}
- (void)loadData{
    WEAKSELF;
    [NetWorkMangerTools lookAllScheduleRequestSuccess:^(NSArray *arr) {
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanTableViewCell *cell = (PlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AllPlanCellIdentifier];
    cell.rightUtilityButtons = [self normalRightButtons];
    cell.delegate = self;
    cell.isToday = NO;
    if (_dataSourceArr.count >0) {
        RemindData *model = _dataSourceArr[indexPath.row];
        cell.noDayString = model.time;
        [cell setModel:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    RemindData *model = _dataSourceArr[row];
    [self goToEditVC:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.f;
}
- (NSArray *)normalRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     KNavigationBarColor
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#dfdcdc"]
                                                title:@"删除"];
    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            DLog(@"utility buttons closed");
            break;
        case 1:
            DLog(@"left utility buttons open");
            break;
        case 2:
            DLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = cellIndexPath.row;
    RemindData *model = _dataSourceArr[row];
    WEAKSELF;
    switch (index) {
        case 0:
        {DLog(@"编辑按钮被点击");
            [self goToEditVC:model];
            break;
        }
        case 1:
        {// 删除
            [NetWorkMangerTools deleteSelectRemind:model.id RequestSuccess:^{
                [weakSelf.dataSourceArr removeObjectAtIndex:row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    WEAKSELF;
    AddAlertVC *vc = [AddAlertVC new];
    vc.alertType = FromAddBtn;
    vc.successBlock = ^(NSDate *date,NSString *sjcStr){
        [weakSelf loadData];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -编辑事件
- (void)goToEditVC:(RemindData *)model
{WEAKSELF;
    AddAlertVC *vc = [AddAlertVC new];
    vc.successBlock = ^(NSDate *date,NSString *sjcStr){
        
        [weakSelf loadData];
        [weakSelf.tableView reloadData];
    };
    vc.alertType = FromEditBtn;
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
