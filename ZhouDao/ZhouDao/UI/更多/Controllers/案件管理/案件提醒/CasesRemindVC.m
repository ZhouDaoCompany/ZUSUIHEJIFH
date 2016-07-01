//
//  CasesRemindVC.m
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CasesRemindVC.h"
#import "AddCaseRemindVC.h"
#import "CollectEmptyView.h"
#import "CaseRemindListCell.h"

#import "RemindData.h"

static NSString *const CASEREMINDID = @"cellcaseremindIdentifer";

@interface CasesRemindVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

{
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) CollectEmptyView *emptyView;//为空时候
@property (nonatomic,strong)NSMutableArray *dataArrays;//数据源

@end

@implementation CasesRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"案件提醒管理"];
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:nil img:@"mine_addNZ"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    self.emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 235.5f, kMainScreenWidth, kMainScreenHeight-235.5f) WithText:@"暂无案件提醒"];

    _dataArrays  = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CaseRemindListCell" bundle:nil] forCellReuseIdentifier:CASEREMINDID];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    
    [_tableView.mj_header beginRefreshing];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self.tableView.mj_header endRefreshing];
    [self loadData];
}
- (void)loadData
{WEAKSELF;
    NSString *url = [NSString stringWithFormat:@"%@%@%@&aid=%@",kProjectBaseUrl,arrangeRemindList,UID,_caseId];
    [NetWorkMangerTools arrangeRemindListWithUrl:url RequestSuccess:^(NSArray *arrays) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arrays];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseRemindListCell *cell = (CaseRemindListCell *)[tableView dequeueReusableCellWithIdentifier:CASEREMINDID];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CaseRemindListCell class]])
    {
        CaseRemindListCell *cCell = (CaseRemindListCell *)cell;
        cCell.rightUtilityButtons = [self normalRightButtons];
        cCell.delegate = self;
        if (_dataArrays.count >0) {
            [cCell setDataModel:_dataArrays[indexPath.row]];
        }
    }
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
    RemindData *model = _dataArrays[row];
    WEAKSELF;
    switch (index) {
        case 0:
        {DLog(@"编辑按钮被点击");
            [self goToEditVC:model withRow:row];
            break;
        }
        case 1:
        {// 删除
            [NetWorkMangerTools deleteSelectRemind:model.id RequestSuccess:^{
                
                [weakSelf.dataArrays removeObjectAtIndex:row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    AddCaseRemindVC *vc = [AddCaseRemindVC new];
    vc.caseId = _caseId;
    vc.remindType = DetailRemind;
    vc.dataModel = _dataArrays[row];
    vc.addSuccess = ^(){
        
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}
#pragma mark - event response
#pragma mark -编辑事件
- (void)goToEditVC:(RemindData *)model withRow:(NSInteger)row
{WEAKSELF;
    AddCaseRemindVC *vc = [AddCaseRemindVC new];
    vc.caseId = _caseId;
    vc.remindType = EditRemind;
    vc.dataModel = model;
    vc.addSuccess = ^(){
        
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightBtnAction
{WEAKSELF;
    DLog(@"添加案件提醒");
    
    AddCaseRemindVC *vc = [AddCaseRemindVC new];
    vc.caseId = _caseId;
    vc.remindType = AddRemind;
    vc.addSuccess = ^(){
        
        
    };
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
