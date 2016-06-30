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
#import "GBTagListView.h"

static NSString * const       ALLFINANCEIDENTIFER       =  @"allFinanceCellIdentifier";

@interface CaseFIViewController ()<UITableViewDataSource,UITableViewDelegate,FinanceDesCellPro>
{
//    BOOL _flag[24];//bool 数组
    
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) CollectEmptyView *emptyView;//为空时候
@property (nonatomic,strong)NSMutableArray *dataArrays;//数据源
@property (nonatomic,strong)NSMutableArray *oriHeiArr;//原始高度
@property (nonatomic,strong)NSMutableArray *heightArr;//高度收缩

@end

@implementation CaseFIViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"财务信息"];
    [self setupNaviBarWithBtn:NaviRightBtn
                        title:nil img:@"mine_addNZ"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    self.emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 235.5f, kMainScreenWidth, kMainScreenHeight-235.5f) WithText:@"暂无案件文件"];
    _dataArrays = [NSMutableArray array];
    _oriHeiArr  = [NSMutableArray array];
    _heightArr  = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerClass:[FinanceDesCell class] forCellReuseIdentifier:ALLFINANCEIDENTIFER];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];

    [_tableView.mj_header beginRefreshing];
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
        [weakSelf.dataArrays removeAllObjects];
        
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf CalculateTheLineHeight:weakSelf.dataArrays];
        [weakSelf.tableView reloadData];

    } fail:^{
        [weakSelf.dataArrays removeAllObjects];
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
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    FinanceDesCell *cell = (FinanceDesCell *)[tableView dequeueReusableCellWithIdentifier:ALLFINANCEIDENTIFER];
    cell.delegate = self;
    if (_dataArrays.count >0) {
        [cell setFinanceModel:_dataArrays[indexPath.row]];
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
    
    FinanceModel *model = _dataArrays[row];
    NSData *contentData = [model.content dataUsingEncoding:NSUTF8StringEncoding];
    __block NSArray *jsonConArr = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
    NSInteger indexType = 0;
    if ([model.type isEqualToString:@"9"]) {
        indexType = 4;
    }else {
        indexType = [model.type integerValue] -1;
    }
    
    AddFinanceVC *vc = [AddFinanceVC new];
    vc.caseId = _caseId;
    vc.cwid = model.id;
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
//    FinanceDesCell *cell = (FinanceDesCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return  cell.rowHeight;
    FinanceModel *model = _dataArrays[indexPath.row];
    if (model.isExpanded == YES) {
        float height = [_oriHeiArr[indexPath.row] floatValue];
        return height;
    }
    
    float height = [_heightArr[indexPath.row] floatValue];
    return height;

}
#pragma mark - DesTableViewCellPro
- (void)expandOrClose:(UITableViewCell *)cell{
    
    FinanceDesCell *desCell = (FinanceDesCell *)cell;
    NSIndexPath *indexpath = [_tableView indexPathForCell:desCell];
    FinanceModel *model = _dataArrays[indexpath.row];
    model.isExpanded = !model.isExpanded;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -DetailImgCellPro
- (void)TheRefreshTableCell:(UITableViewCell *)cell{
//    FinanceDesCell *desCell = (FinanceDesCell *)cell;
//    NSIndexPath *indexpath = [_tableView indexPathForCell:desCell];
//    NSArray *arrays = [self.tableView visibleCells];
//    if ([arrays containsObject:cell]) {
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexpath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//    }
}
- (void)CalculateTheLineHeight:(NSMutableArray *)dataSource
{
    for (NSUInteger i =0; i<dataSource.count; i++) {
        
        FinanceModel *financeModel = dataSource[i];
        NSData *titData = [financeModel.title dataUsingEncoding:NSUTF8StringEncoding];
        __block NSMutableArray *jsonTitArr = [NSJSONSerialization JSONObjectWithData:titData options:NSJSONReadingAllowFragments error:nil];
        
        NSData *contentData = [financeModel.content dataUsingEncoding:NSUTF8StringEncoding];
        __block NSMutableArray *jsonConArr = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
//        [_titArr addObject:jsonTitArr];
//        [_contentArr addObject:jsonConArr];
        
        CGFloat labelMaxWidth = kMainScreenWidth-30;
        
        __block NSMutableArray *arr = [NSMutableArray array];
        
        
        [jsonConArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx < jsonConArr.count -1) {
                if (obj.length >0) {
                    NSString *str = [NSString stringWithFormat:@"%@:%@",jsonTitArr[idx],jsonConArr[idx]];
                    
                    [arr addObject:str];
                }
            }
        }];
        
        float rowHeight = 68.f;
        
//        if (arr.count == 1) {
//            rowHeight = 68.f;
//        }
        if (arr.count == 2) {
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];

            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:10.f]};
            CGSize Size_str1=[str1 sizeWithAttributes:attrs];
            CGSize Size_str2=[str2 sizeWithAttributes:attrs];
            if ((Size_str1.width + Size_str2.width +15) > kMainScreenWidth) {
                rowHeight = 93.f;
            }
        }

        if (arr.count == 3) {
            NSString *str1 = arr[0];
            NSString *str2 = arr[1];
            NSString *str3 = arr[2];

            NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:10.f]};
            CGSize Size_str1=[str1 sizeWithAttributes:attrs];
            CGSize Size_str2=[str2 sizeWithAttributes:attrs];
            CGSize Size_str3=[str3 sizeWithAttributes:attrs];

            if ((Size_str1.width + Size_str2.width + Size_str3.width +20) > kMainScreenWidth) {
                rowHeight = 93.f;
            }
        }

        
        NSString *desString = [NSString stringWithFormat:@"%@",[jsonConArr lastObject]];

        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize size = [desString boundingRectWithSize:CGSizeMake(labelMaxWidth, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        float height1 = 0.f;
        float height2 = 0.f;

        if (desString.length == 0) {
            height1 = rowHeight + 5.f;
            height2 = rowHeight + 5.f;

        }else {
            
            if (size.height < 34.f) {
                
                height1 = size.height + rowHeight + 15;
                height2 = size.height + rowHeight + 15;

            }else {
                height1 =  size.height + 45 +  rowHeight;
                height2 =  34.f + 45 +  rowHeight;

            }
        }

        [_oriHeiArr addObject:[NSString stringWithFormat:@"%f",height1]];
        [_heightArr addObject:[NSString stringWithFormat:@"%f",height2]];

    }
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
#pragma mark - private methods

#pragma mark - getters and setters 
- (CollectEmptyView *)emptyView
{
    if (_emptyView == nil){
        
        _emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64.f)
                                                    WithText:@"暂无财务信息"];
    }
    return _emptyView;
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
