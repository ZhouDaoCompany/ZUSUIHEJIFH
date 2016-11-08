//
//  CaseFIViewController.m
//  ZhouDao
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseFIViewController.h"
#import "CollectEmptyView.h"
#import "AddFinanceVC.h"
#import "FinanceDesCell.h"
#import "FinanceModel.h"
#import "FinanceFrameItem.h"

static NSString * const       ALLFINANCEIDENTIFER       =  @"allFinanceCellIdentifier";

@interface CaseFIViewController ()<UITableViewDataSource,UITableViewDelegate,FinanceDesCellPro> {
//    BOOL _flag[24];//bool 数组
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) CollectEmptyView *emptyView;//为空时候

@property (nonatomic, strong) NSMutableArray *fianceFrames;
//@property (nonatomic,strong)FinanceFrameItem *fianceFrames;

@end

@implementation CaseFIViewController
- (NSArray *)fianceFramesWithArrays:(NSArray *)arrays {
    
    _fianceFrames = [FinanceFrameItem financeFramesWithDataArr:arrays];
    return _fianceFrames;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"财务信息"];
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:nil img:@"mine_addNZ"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _fianceFrames = [NSMutableArray array];

    [self emptyView];
    [self.view addSubview:self.tableView];
    
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self.tableView.mj_header endRefreshing];
    [self requestListData];
}

- (void)requestListData
{WEAKSELF;
    [NetWorkMangerTools financialListToCheckTheCaseWithCaseID:_caseId RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.fianceFrames removeAllObjects];
        [weakSelf fianceFramesWithArrays:arr];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.fianceFrames removeAllObjects];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_fianceFrames.count == 0) {
        [self.view addSubview:self.emptyView];
    } else {
        TTVIEW_RELEASE_SAFELY(self.emptyView);
    }
    return [_fianceFrames count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    FinanceDesCell *cell = [tableView dequeueReusableCellWithIdentifier:ALLFINANCEIDENTIFER];
    if (cell == nil) {
        cell = [[FinanceDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ALLFINANCEIDENTIFER];
    }

    cell.delegate = self;
    if (_fianceFrames.count >0) {
        
        [cell setFinanceFrameItem:_fianceFrames[indexPath.row]];
    }

    return cell;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell isKindOfClass:[FinanceDesCell class]])
//    {
//        FinanceDesCell *fCell = (FinanceDesCell *)cell;
//        fCell.delegate = self;
//        if (_dataArrays.count >0) {
//            [fCell setTitArr:_titArr[indexPath.row] withconArr:_contentArr[indexPath.row]];
//        }
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    
    FinanceFrameItem *items = _fianceFrames[row];
    NSData *contentData = [items.financeModel.content dataUsingEncoding:NSUTF8StringEncoding];
    __block NSArray *jsonConArr = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
    NSInteger indexType = 0;
    if ([items.financeModel.type isEqualToString:@"9"]) {
        indexType = 4;
    }else {
        indexType = [items.financeModel.type integerValue] -1;
    }
    
    AddFinanceVC *vc = [AddFinanceVC new];
    vc.caseId = _caseId;
    vc.cwid = items.financeModel.id;
    vc.oriArr = jsonConArr;
    vc.currentBtnTag = indexType;
    vc.successBlock = ^(){
        
        [weakSelf requestListData];
    };
    vc.financeType = EditFinance;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinanceFrameItem *financeItem = self.fianceFrames[indexPath.row];
    
    if (financeItem.financeModel.isExpanded) {
        return financeItem.cellHeight2;
    }else{
        return financeItem.cellHeight1;
    }

}
#pragma mark - DesTableViewCellPro
- (void)expandOrClose:(UITableViewCell *)cell{
    
    FinanceDesCell *desCell = (FinanceDesCell *)cell;
    NSIndexPath *indexpath = [_tableView indexPathForCell:desCell];
    FinanceFrameItem *item = _fianceFrames[indexpath.row];
    item.financeModel.isExpanded = !item.financeModel.isExpanded;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - event response
-(void)rightBtnAction
{WEAKSELF;
    DLog(@"添加财务管理");
    
    AddFinanceVC *vc = [AddFinanceVC new];
    vc.caseId = _caseId;
    vc.financeType = AddFinance;
    vc.successBlock = ^(){
        
        [weakSelf requestListData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getters and setters 
- (CollectEmptyView *)emptyView {
    if (!_emptyView){
        
        _emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 64.f, kMainScreenWidth, kMainScreenHeight - 64.f)
                                                    WithText:@"暂无财务信息"];
    }
    return _emptyView;
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[FinanceDesCell class] forCellReuseIdentifier:ALLFINANCEIDENTIFER];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        [_tableView.mj_header beginRefreshing];
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
