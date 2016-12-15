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
#import "CityModel.h"
#import "AreaModel.h"

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

@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) AreaModel *areaModel;
@property (nonatomic, strong) BaseRightBtn *baseRightButton;
@property (nonatomic, copy) NSString *ctName;
@property (nonatomic, copy) NSString *showLocal;
@property (nonatomic, strong) ProvinceModel *proModel;

@end

@implementation GovernmentListVC

- (void)dealloc {
    
    NSString *url1 = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,goverAllClasslist];
    NSString *url2 = (_proModel) ? [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld",kProjectBaseUrl,judicialList,_pid,_cid,(unsigned long)_page] : [NSString stringWithFormat:@"%@%@pid=%@&cid=%@&page=%ld&prov=%@&city=%@&area=%@",kProjectBaseUrl,judicialList,_pid,_cid,(unsigned long)_page,_proModel.id,_cityModel.id,_areaModel.id];

    [ZhouDao_NetWorkManger cancelRequestWithURL:url1];
    [ZhouDao_NetWorkManger cancelRequestWithURL:url2];
}
- (id)initWithCTName:(NSString *)ctname
        withShowName:(NSString *)showName
   withProvinceModel:(ProvinceModel *)proModel{
    
    self = [super init];
    if (self) {
        _proModel = proModel;
        _showLocal = showName;
        _ctName = ctname;
    }
    return self;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI {
    
    [self setupNaviBarWithTitle:@"司法机关"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.baseRightButton];
    [self.view addSubview:self.tableView];
    
    [self loadAreasPlistfile];
    [self loadClassData];
}
#pragma mark -获取所有分类
- (void)loadClassData{
    WEAKSELF;
    [NetWorkMangerTools goverAllClasslistwithName:_ctName RequestSuccess:^(NSArray *arr, NSInteger index) {
        
        [weakSelf.oneArrays addObjectsFromArray:arr];
        _oneCurrent = index;
        [weakSelf getRegionData:index];
       [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:weakSelf.proModel.id withCity:weakSelf.cityModel.id withareas:weakSelf.areaModel.id RequestSuccess:^(NSArray *arr) {
            
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
    
    _twoCurrent = 0;
    _twoData1SelectedIndex = 0;

    if (_proModel) {
        
        [_proModel.city enumerateObjectsUsingBlock:^(CityModel *cityModel, NSUInteger cityIdx, BOOL * _Nonnull cityStop) {
            
            NSDictionary *tempDcit = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"id",@"全部",@"name", nil];
            AreaModel *areaModel = [[AreaModel alloc] initWithDictionary:tempDcit];
            if ([[PublicFunction ShareInstance].locCity isEqualToString:cityModel.name]) {
                
                weakSelf.cityModel = cityModel;
                weakSelf.twoCurrent = cityIdx;
                weakSelf.areaModel = areaModel;
            }
            
            [cityModel.area insertObject:areaModel atIndex:0];
        }];
        
        weakSelf.twoArrays = _proModel.city;

        if (!_cityModel) {
            
            if ([_twoArrays count] > 0) {
                _cityModel = _twoArrays[0];
            }
        }
        
    }
}
- (void)getRegionData:(NSInteger)index {
    
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
    //默认选中
    _oneData1SelectedIndex = 0;
    
    [self.view addSubview:self.jsMenu];
}
#pragma mark - event response

- (void)baseRightBtnAction
{WEAKSELF;
    SelectProvinceVC *selectVC = [[SelectProvinceVC alloc] initWithSelectType:FromGoverment withIsHaveNoGAT:NO];
    selectVC.provinceBlock = ^(NSString *showName , ProvinceModel *proModel){
        
        if (weakSelf.localBlock) {
            weakSelf.localBlock(proModel, showName);
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
        weakSelf.proModel = proModel;
        weakSelf.showLocal = showName;
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

#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender { WEAKSELF;
    _page = 0;
    [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_proModel.id withCity:_cityModel.id withareas:_areaModel.id RequestSuccess:^(NSArray *arr) {
        
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
- (void)downRefresh:(id)sender { WEAKSELF;
    
   [NetWorkMangerTools goverListViewWithPid:_pid
                                    withCid:_cid
                                   withPage:_page
                                   withProv:_proModel.id
                                   withCity:_cityModel.id
                                  withareas:_areaModel.id
                             RequestSuccess:^(NSArray *arr) {
        
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
    return [self.dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GovListCell*cell = (GovListCell *)[tableView dequeueReusableCellWithIdentifier:JudicialIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if ([cell isKindOfClass:[GovListCell class]]) {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF;
    if (_dataSourceArr.count>0) {
        GovListmodel *model = _dataSourceArr[indexPath.row];
        [NetWorkMangerTools goverDetailWithId:model.id RequestSuccess:^(id obj) {
            
            GovListmodel *tempModel = (GovListmodel *)obj;
            
            NSString *detailAddress = tempModel.address;
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.areaModel.name];
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.cityModel.name];
            detailAddress = [weakSelf completeAddress:detailAddress withTogether:weakSelf.proModel.name];

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
                CityModel *cityModel = _twoArrays[leftRow];
                return [cityModel.area count];
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
            CityModel *cityModel = _twoArrays[_twoCurrent];
            AreaModel *areaModel = cityModel.area[_twoData1SelectedIndex];
            NSString *titleString = areaModel.name;
            if ([areaModel.name isEqualToString:@"全部"]) {
                titleString = cityModel.name;
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
            CityModel *cityModel = _twoArrays[indexPath.row];
            return cityModel.name;
        } else{
            NSInteger leftRow = indexPath.leftRow;
            CityModel *cityModel = _twoArrays[leftRow];
            AreaModel *areaModel = cityModel.area[indexPath.row];
            return areaModel.name;
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
            _cityModel = _twoArrays[leftRow];
            [PublicFunction ShareInstance].locCity = _cityModel.name;
            _areaModel = _cityModel.area[indexPath.row];
            [weakSelf didSelectRowMenu];
        }
    }
}
- (void)didSelectRowMenu{
    WEAKSELF;
    _page = 0;
     [NetWorkMangerTools goverListViewWithPid:_pid withCid:_cid withPage:_page withProv:_proModel.id withCity:_cityModel.id withareas:_areaModel.id RequestSuccess:^(NSArray *arr) {
         
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
- (NSMutableArray *)dataSourceArr {
    
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (NSMutableArray *)oneArrays {
    
    if (!_oneArrays) {
        _oneArrays = [NSMutableArray array];
    }
    return _oneArrays;
}
- (NSMutableArray *)twoArrays {
    if (!_twoArrays) {
        _twoArrays = [NSMutableArray array];
    }
    return _twoArrays;
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
