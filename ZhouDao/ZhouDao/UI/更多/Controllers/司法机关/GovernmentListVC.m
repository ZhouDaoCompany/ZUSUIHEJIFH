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
#import "SelectProvinceVC.h"
#import "BaseRightBtn.h"

static NSString *const JudicialIdentifier = @"JudicialIdentifier";
@interface GovernmentListVC ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
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
@property (nonatomic, assign) NSUInteger oneCurrent;
@property (nonatomic, assign) NSUInteger oneData1SelectedIndex;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *areas;
@property (nonatomic, strong) BaseRightBtn *baseRightButton;

@end

@implementation GovernmentListVC

- (void)dealloc
{
    NSString *url1 = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,goverAllClasslist];
    NSString *url2 = (_prov.length == 0) ? [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld",kProjectBaseUrl,judicialList,_pid,_cid,(unsigned long)_page] : [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld&prov=%@&city=%@&area=%@",kProjectBaseUrl,judicialList,_pid,_cid,(unsigned long)_page,_prov,_city,_areas];

    [ZhouDao_NetWorkManger cancelRequestWithURL:url1];
    [ZhouDao_NetWorkManger cancelRequestWithURL:url2];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"司法机关"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.baseRightButton];

    _dataSourceArr = [NSMutableArray array];
    _oneArrays = [NSMutableArray array];
    _twoArrays = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self loadAreasPlistfile];
    [self loadClassData];
}
#pragma mark -获取所有分类
- (void)loadClassData{
    WEAKSELF;
    [NetWorkMangerTools goverAllClasslistwithName:_nameString RequestSuccess:^(NSArray *arr, NSInteger index) {
        
        [weakSelf.oneArrays addObjectsFromArray:arr];
        _oneCurrent = index;
        [weakSelf getRegionData:index];
       [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city withareas:_areas RequestSuccess:^(NSArray *arr) {
            
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
            _page ++;
            [weakSelf.tableView reloadData];
        } fail:^{
            [weakSelf.tableView reloadData];
        }];
    }];
}
- (void)loadAreasPlistfile
{WEAKSELF;
    NSString *pathSource = [MYBUNDLE pathForResource:@"Areas" ofType:@"plist"];
    __block NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
    
    _twoCurrent = 0;
    _twoData1SelectedIndex = 0;

    if (_prov.length > 0) {
        
        NSArray *tempArr = dict[_prov];
        NSArray *cityArr = [[tempArr objectAtIndex:0] allKeys];
        _city = cityArr[0];
        [cityArr enumerateObjectsUsingBlock:^(NSString *cityObj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([PublicFunction ShareInstance].locProv.length >0  && [weakSelf.prov isEqualToString:[PublicFunction ShareInstance].locProv ]) {
                if ([[PublicFunction ShareInstance].locCity isEqualToString:cityObj]) {
                    weakSelf.city = [PublicFunction ShareInstance].locCity;
                    weakSelf.twoCurrent = idx;
                }
            }
            
            NSMutableArray *townArray = [NSMutableArray array];
            [townArray addObjectsFromArray:[tempArr[0] objectForKey:cityArr[idx]]];
            [townArray insertObject:@"全部" atIndex:0];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:cityObj,@"title",townArray,@"data", nil];
            [weakSelf.twoArrays addObject:dictionary];
        }];
    }
}
- (void)getRegionData:(NSInteger)index
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
        _city = @"";
        _areas = @"";
        _twoData1SelectedIndex = 0;
    }
    //默认选中
    _oneData1SelectedIndex = 0;
    
    [self.view addSubview:self.jsMenu];
}
#pragma mark - event response

- (void)baseRightBtnAction
{WEAKSELF;
    SelectProvinceVC *selectVC = [SelectProvinceVC new];
    selectVC.selectBlock = ^(NSString *province, NSString *local){
        
        if (weakSelf.localBlock) {
            weakSelf.localBlock(province,local);
        }
        [weakSelf.twoArrays removeAllObjects];
        [weakSelf.jsMenu.leftTableView removeFromSuperview];
        weakSelf.jsMenu.leftTableView = nil;
        [weakSelf.jsMenu.rightTableView removeFromSuperview];
        weakSelf.jsMenu.rightTableView = nil;
        [weakSelf.jsMenu.backGroundView removeFromSuperview];
        weakSelf.jsMenu.backGroundView = nil;

        [weakSelf.jsMenu removeFromSuperview];
        weakSelf.jsMenu = nil;
        weakSelf.prov = province;
        weakSelf.showLocal = local;
        [weakSelf.baseRightButton setTitle:weakSelf.showLocal forState:0];
        [weakSelf loadAreasPlistfile];
        [weakSelf.view addSubview:weakSelf.jsMenu];

        JSIndexPath *indexPath1 = [JSIndexPath new];
        indexPath1.column = 1;
        indexPath1.leftOrRight = 1;
        [weakSelf menu:weakSelf.jsMenu didSelectRowAtIndexPath:indexPath1];
    };
    [self presentViewController:selectVC animated:YES completion:nil];
}

#pragma mark - getters and setters
- (BaseRightBtn *)baseRightButton
{
    if (!_baseRightButton) {
        CGRect frame = CGRectMake(kMainScreenWidth - 70, 20, 70, 44);
        _baseRightButton = [BaseRightBtn buttonWithType:UIButtonTypeCustom];
        _baseRightButton.frame = frame;
        _baseRightButton.backgroundColor = [UIColor clearColor];
        [_baseRightButton addTarget:self
                             action:@selector(baseRightBtnAction)
                   forControlEvents:UIControlEventTouchUpInside];
        [_baseRightButton setTitle:_showLocal forState:0];
        [_baseRightButton setImage:kGetImage(@"gov_SelectLoc") forState:0];
    }
    return _baseRightButton;
}

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
        [_tableView registerClass:[GovListCell class] forCellReuseIdentifier:JudicialIdentifier];
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
        _jsMenu.textColor = THIRDCOLOR;
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
    [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city withareas:_areas RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
        _page ++;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } fail:^{
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{    WEAKSELF;
   [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city withareas:_areas RequestSuccess:^(NSArray *arr) {
        
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
            
            NSString *detailAddress = tempModel.address;
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.areas];
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.city];
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.prov];

            GovernmentDetailVC *vc = [GovernmentDetailVC new];
            vc.model = tempModel;
            vc.detailAddress = detailAddress;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
}
- (NSString *)completeAddress:(NSString *)tempAddress withTogether:(NSString *)templeString
{
    NSString *addressString = tempAddress;
    if (templeString.length >0) {
        if ([QZManager isString:tempAddress withContainsStr:templeString] == NO) {
           addressString = [NSString stringWithFormat:@"%@%@",templeString,tempAddress];
        }
    }
    return addressString;
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
            
            if (_oneArrays.count > leftRow) {
                GovClassModel *model = _oneArrays[leftRow];
                return [model.data count];
            }
            return 0;
        }
    }else{
        if (leftOrRight==0) {
            return _twoArrays.count;
        } else{
            if (_twoArrays.count > leftRow) {
                NSDictionary *menuDic = [_twoArrays objectAtIndex:leftRow];
                return [[menuDic objectForKey:@"data"] count];
            }
            return 0;
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
            return titleString;
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
        _oneData1SelectedIndex = indexPath.row;
        [weakSelf didSelectRowMenu];
    }else{
        if (indexPath.leftOrRight==0) {
            _twoCurrent = indexPath.row;
            return;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_twoArrays objectAtIndex:leftRow];
            _city = [menuDic objectForKey:@"title"];
            [PublicFunction ShareInstance].locCity = _city;
            _areas = [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
            if ([_areas isEqualToString:@"全部"]) {
                _areas = @"";
            }
            [weakSelf didSelectRowMenu];
        }
    }
}
- (void)didSelectRowMenu{
    WEAKSELF;
    _page = 0;
     [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_prov withCity:_city withareas:_areas RequestSuccess:^(NSArray *arr) {
         
         [weakSelf.dataSourceArr removeAllObjects];
         [weakSelf.dataSourceArr addObjectsFromArray:arr];
         _page ++;
         [weakSelf.tableView reloadData];
         [weakSelf.tableView.mj_footer endRefreshing];

     } fail:^{
         [weakSelf.dataSourceArr removeAllObjects];
         [weakSelf.tableView reloadData];
     }];
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
