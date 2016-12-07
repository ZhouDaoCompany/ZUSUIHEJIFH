//
//  SelectTemplateVC.m
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SelectTemplateVC.h"
#import "JSDropDownMenu.h"
#import "TemplateDetailVC.h"
#import "SelectTemplateCell.h"
static NSString *const selectCellIdentifier = @"selectCellIdentifier";
@interface SelectTemplateVC ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _classCurrent;
    NSUInteger _sortCurrent;
    
    //请求列表参数
    NSString *_scid;//二级id
    NSUInteger _page;
    NSString *_orid;//排序 默认为0，表示不限 1-按阅读次数 2-按下载次数 3-按最新
}
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *classArrays;//分类
@property (nonatomic, strong) NSMutableArray *sortArrays;//排序
@property (nonatomic, strong) JSDropDownMenu *jsMenu;
@end

@implementation SelectTemplateVC
- (instancetype)initWithFirstArrays:(NSMutableArray *)firstArrays
                      withCidArrays:(NSMutableArray *)idArrays
                withTheContractData:(TheContractData *)model
                   withTemplateType:(TemplateType)temType
{
    self = [super init];
    if (self) {
        _temType = temType;
        self.cidArrays = idArrays;
        self.model = model;

        if (_temType == GeneralSelectType) {
            self.firstArrays = firstArrays;
        } else {
            [self.dataSourceArr addObjectsFromArray:firstArrays];
        }
    }
    return self;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - methods
- (void)initUI {
    [self setupNaviBarWithTitle:@"合同模版"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.tableView];
    if (_temType == GeneralSelectType) {
        [self loadClassData];//请求合同分类
    }
}
#pragma mark -获取分类
- (void)loadClassData{ WEAKSELF;
    
    _cidString = _model.id;
    _page = 0;
    _scid = @"";
    _orid = @"0";
    
    [self getRegionData];
    [NetWorkMangerTools theContractListView:_cidString withscid:_scid withPage:_page withOrid:_orid RequestSuccess:^(NSArray *arrays) {
        
        _page ++;
        [weakSelf.dataSourceArr addObjectsFromArray:arrays];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.tableView reloadData];
    }];
}
- (void)getRegionData {
    
    _classCurrent = [_cidArrays indexOfObject:self.cidString];
    
    //默认选中
    _sortCurrent = -1;
    _sortArrays = [NSMutableArray arrayWithObjects:@"排序不限",@"按阅读次数",@"按下载次数",@"按最新", nil];
    [self.view addSubview:self.jsMenu];
}

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender { WEAKSELF;
    _page = 0;
    [NetWorkMangerTools theContractListView:_cidString withscid:_scid withPage:_page withOrid:_orid RequestSuccess:^(NSArray *arrays) {
        
        _page ++;
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arrays];
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^{
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender { WEAKSELF;
    
    [MBProgressHUD showMBLoadingWithText:nil];
    [NetWorkMangerTools theContractListView:_cidString withscid:_scid withPage:_page withOrid:_orid RequestSuccess:^(NSArray *arrays) {
        
        _page ++;
        [weakSelf.dataSourceArr addObjectsFromArray:arrays];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^{
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTemplateCell*cell = (SelectTemplateCell *)[tableView dequeueReusableCellWithIdentifier:selectCellIdentifier];
    if (_dataSourceArr.count >0) {
        [cell setDataModel:_dataSourceArr[indexPath.row]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TemplateDetailVC *detailVC = [TemplateDetailVC new];
    TemplateData *model =  _dataSourceArr[indexPath.row];
    detailVC.idString = model.id;
    [self.navigationController  pushViewController:detailVC animated:YES];
}
#pragma mark -
#pragma mark -JSDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 2;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        return _classCurrent;
    }
    return _sortCurrent;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _firstArrays.count;
    }
    return _sortArrays.count;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:return _firstArrays[_classCurrent];
            break;
        case 1:
        {
            return @"排序不限";
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _firstArrays[indexPath.row];
    }else{
        return _sortArrays[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.column == 0) {
        _classCurrent = indexPath.row;
        _page = 0;
        _cidString = _cidArrays[indexPath.row];
        [NetWorkMangerTools theContractListView:_cidString withscid:_scid withPage:_page withOrid:_orid RequestSuccess:^(NSArray *arrays) {
            _page ++;
            [weakSelf.dataSourceArr removeAllObjects];

            [weakSelf.dataSourceArr addObjectsFromArray:arrays];
            [weakSelf.tableView reloadData];
        } fail:^{
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.tableView reloadData];
        }];
    }else{
        _sortCurrent = indexPath.row;
        _orid = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        _page = 0;
        [NetWorkMangerTools theContractListView:_cidString withscid:_scid withPage:_page withOrid:_orid RequestSuccess:^(NSArray *arrays) {
            
            _page ++;
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.dataSourceArr addObjectsFromArray:arrays];
            [weakSelf.tableView reloadData];
        } fail:^{
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark setter and getter
- (UITableView *)tableView {
    
    if (!_tableView) {

        CGRect frame = (_temType == GeneralSelectType) ? CGRectMake(0,109.f, kMainScreenWidth, kMainScreenHeight-109.f) : CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight-64.f);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerNib:[UINib nibWithNibName:@"SelectTemplateCell" bundle:nil] forCellReuseIdentifier:selectCellIdentifier];
        if (_temType == GeneralSelectType) {
            _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
            _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
        }
    }
    return _tableView;
}
- (JSDropDownMenu *)jsMenu {
    
    if (!_jsMenu) {
        _jsMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
        _jsMenu.indicatorColor = LRRGBColor(175, 175, 175);
        _jsMenu.separatorColor = LRRGBColor(210, 210, 210);
        _jsMenu.textColor = THIRDCOLOR;
        _jsMenu.backgroundColor = [UIColor whiteColor];
        _jsMenu.dataSource = self;
        _jsMenu.delegate = self;
    }
    return _jsMenu;
}
- (NSMutableArray *)dataSourceArr {
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)classArrays {
    if (!_classArrays) {
        _classArrays = [NSMutableArray array];
    }
    return _classArrays;
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
