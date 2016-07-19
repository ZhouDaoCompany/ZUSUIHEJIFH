//
//  GovernmentListVC.m
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovernmentListVC.h"
#import "JSDropDownMenu.h"
#import "GovListCell.h"
#import "GovListmodel.h"
#import "GovClassModel.h"
#import "GovernmentDetailVC.h"

static NSString *const JudicialIdentifier = @"JudicialIdentifier";
@interface GovernmentListVC ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSUInteger _oneCurrent;
    NSUInteger _oneData1SelectedIndex;
    //请求
    NSString *_pid;
    NSString *_cid;
    NSUInteger _page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//列表数据源
@property (nonatomic, strong) NSMutableArray *oneArrays;//分类
@property (nonatomic, strong) NSMutableArray *twoArrays;//排序
@property (nonatomic, strong) JSDropDownMenu *jsMenu;
@property (nonatomic, assign) NSUInteger twoCurrent;
@property (nonatomic, assign) NSUInteger twoData1SelectedIndex;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *prov;
@end

@implementation GovernmentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"司法机关"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    _dataSourceArr = [NSMutableArray array];
    _oneArrays = [NSMutableArray array];
    _twoArrays = [NSMutableArray array];
    _twoCurrent = 0;
    
    
    [self.view addSubview:self.tableView];
    
    [self loadClassData];
}
#pragma mark -获取所有分类
- (void)loadClassData{
    WEAKSELF;
    NSString *pathSource = [[NSBundle mainBundle] pathForResource:@"Areas" ofType:@"plist"];
   __block NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];

    NSArray *provinceArr = ProvinceArrays;
    [provinceArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tempArr = dict[obj];
        NSMutableArray *cityArr = [NSMutableArray array];
        if ([obj isEqualToString:@"北京"] || [obj isEqualToString:@"重庆"] || [obj isEqualToString:@"天津"] || [obj isEqualToString:@"上海"]) {
            
            [cityArr addObjectsFromArray:[weakSelf getTownArrays:dict withProvArr:obj]];
            [cityArr insertObject:@"全部" atIndex:0];
            if (![[PublicFunction ShareInstance].locProv rangeOfString:obj].location) {
                _prov = obj;
                [cityArr enumerateObjectsUsingBlock:^(NSString *cityObj, NSUInteger cityIdx, BOOL * _Nonnull stop) {
                    
                    if ([cityObj isEqualToString:[PublicFunction ShareInstance].locDistrict]) {
                        weakSelf.twoData1SelectedIndex = cityIdx;
                        weakSelf.twoCurrent = idx +1;
                        weakSelf.city = [PublicFunction ShareInstance].locDistrict;
                        *stop = YES;
                        return ;
                    }
                }];
            }
        }else{
            
            [cityArr addObjectsFromArray:[tempArr[0]  allKeys]];
            [cityArr insertObject:@"全部" atIndex:0];
            
            if (![[PublicFunction ShareInstance].locProv rangeOfString:obj].location)
            {
                _prov = obj;
                [cityArr enumerateObjectsUsingBlock:^(NSString *cityObj, NSUInteger cityIdx, BOOL * _Nonnull stop) {
                    if ([cityObj isEqualToString:[PublicFunction ShareInstance].locCity]) {
                        weakSelf.twoData1SelectedIndex = cityIdx;
                        weakSelf.city = [PublicFunction ShareInstance].locCity;
                        *stop = YES;
                        return ;
                    }
                }];
            }
        }
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:obj,@"title",cityArr,@"data", nil];
        [weakSelf.twoArrays addObject:dictionary];
    }];
    
    NSDictionary *countryDic = [NSDictionary dictionaryWithObjectsAndKeys:@"全国",@"title",[NSArray arrayWithObject:@"全国"],@"data", nil];
    [_twoArrays insertObject:countryDic atIndex:0];
    
    [NetWorkMangerTools goverAllClasslistwithName:_nameString RequestSuccess:^(NSArray *arr, NSUInteger index) {
        
        [weakSelf.oneArrays addObjectsFromArray:arr];
        _oneCurrent = index;
        [weakSelf getRegionData:index];
        [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city RequestSuccess:^(NSArray *arr) {
            
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
            _page ++;
            [weakSelf.tableView reloadData];
        } fail:^{
            [weakSelf.tableView reloadData];
        }];
    }];
}
- (void)getRegionData:(NSUInteger)index
{
    GovClassModel *model = nil;
    GovClassData *dataModel = nil;
    if (_oneArrays.count> index) {
         model = _oneArrays[index];
        if (model.data.count >0) {
            dataModel = model.data[0];
        }
    }
    _pid = model.court_category;
    _cid = GET(dataModel.classid);
    _page = 0;
    if ([PublicFunction ShareInstance].locProv.length == 0) {
        _prov = @"";
        _city = @"";
        _twoData1SelectedIndex = 0;
    }
    //默认选中
    _oneData1SelectedIndex = 0;
    
    [self.view addSubview:self.jsMenu];
}
#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,109.f, kMainScreenWidth, kMainScreenHeight-109.f) style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerNib:[UINib nibWithNibName:@"GovListCell" bundle:nil] forCellReuseIdentifier:JudicialIdentifier];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    }
    return _tableView;
}
- (JSDropDownMenu *)jsMenu{
    if (!_jsMenu) {
        _jsMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
        _jsMenu.indicatorColor = LRRGBColor(175, 175, 175);
        _jsMenu.separatorColor = LRRGBColor(210, 210, 210);
        _jsMenu.textColor = thirdColor;
        _jsMenu.backgroundColor = [UIColor whiteColor];
        _jsMenu.dataSource = self;
        _jsMenu.delegate = self;
    }
    return _jsMenu;
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    WEAKSELF;
    _page = 0;
    [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        _page ++;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];

    } fail:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{    WEAKSELF;
    [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        _page ++;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^{
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GovListCell*cell = (GovListCell *)[tableView dequeueReusableCellWithIdentifier:JudicialIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[GovListCell class]])
    {
        GovListCell *jCell = (GovListCell *)cell;
        if (_dataSourceArr.count >0) {
            [jCell setListModel:_dataSourceArr[indexPath.row]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    if (_dataSourceArr.count>0) {
        GovListmodel *model = _dataSourceArr[indexPath.row];
        [NetWorkMangerTools goverDetailWithId:model.id RequestSuccess:^(id obj) {
            
            GovListmodel *tempModel = (GovListmodel *)obj;
            GovernmentDetailVC *vc = [GovernmentDetailVC new];
            vc.model = tempModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
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
    return YES;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
//    if (column == 0) {
//        return 0.3;
//    }
    return 0.5;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        return _oneCurrent;
    }
    return _twoCurrent;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            return _oneArrays.count;
        } else{
            GovClassModel *model = _oneArrays[leftRow];
            return [model.data count];
        }
    }else{
        if (leftOrRight==0) {
            return _twoArrays.count;
        } else{
            NSDictionary *menuDic = [_twoArrays objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    }
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: {
            GovClassModel *model = _oneArrays[_oneCurrent];
            GovClassData *dataModel = model.data[_oneData1SelectedIndex];
            if ([dataModel.ctname isEqualToString:@"全部"]) {
                return model.ctname;
            }
            return dataModel.ctname;
        }
            break;
        case 1: {
            NSString *titleString = [[_twoArrays[_twoCurrent] objectForKey:@"data"] objectAtIndex:_twoData1SelectedIndex];
            if ([titleString isEqualToString:@"全部"]) {
                titleString = [_twoArrays[_twoCurrent] objectForKey:@"title"];
            }
            return titleString;//[titleString isEqualToString:@" "]?@"按地区":titleString;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            GovClassModel *model = _oneArrays[indexPath.row];
            return model.ctname;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            GovClassModel *model = _oneArrays[leftRow];
            GovClassData *dataModel = model.data[indexPath.row];
            return dataModel.ctname;
        }
    }else{
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_twoArrays objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_twoArrays objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.column == 0) {
        if(indexPath.leftOrRight==0){
            //0 是左边 1是右边
            _oneCurrent = indexPath.row;
            return;
        }
        NSInteger leftRow = indexPath.leftRow;
        GovClassModel *model = _oneArrays[leftRow];
        GovClassData *dataModel = model.data[indexPath.row];
        _pid = model.court_category;
        _cid = dataModel.classid;
        
        [weakSelf didSelectRowMenu];
    }else{
        if (indexPath.leftOrRight==0) {
            _twoCurrent = indexPath.row;
            return;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_twoArrays objectAtIndex:leftRow];
            _prov = [menuDic objectForKey:@"title"];
            _city = [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
            if ([_prov isEqualToString:@"全国"]) {
                _prov = @"";
                _city = @"";
            }
            if ([_city isEqualToString:@"全部"]) {
                _city = @"";
            }

            [weakSelf didSelectRowMenu];
        }
    }
}
- (void)didSelectRowMenu{
    WEAKSELF;
    _page = 0;
    [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        _page ++;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^{
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -四个市
- (NSArray *)getTownArrays:(NSDictionary *)dict withProvArr:(NSString *)prov{
    
   NSArray *selectedArray = [dict objectForKey:prov];
    NSArray *cityArray = [[selectedArray objectAtIndex:0] allKeys];

    NSArray *townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
    return townArray;
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
