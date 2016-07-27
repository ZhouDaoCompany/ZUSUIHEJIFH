//
//  LocalLawsVC.m
//  ZhouDao
//
//  Created by cqz on 16/4/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LocalLawsVC.h"
#import "JSDropDownMenu.h"
#import "LawsTableViewCell.h"
#import "ContentViewController.h"
#import "LawDetailModel.h"
#import "SecrchLawsVC.h"

static NSString *const LocalCellIdentifier = @"LocalCellIdentifier";
@interface LocalLawsVC ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _timeCurrent;
    NSString *_time;
    NSUInteger _page;
}
@property (nonatomic, strong) NSMutableArray *areasArrays;//地区
@property (nonatomic, strong) NSMutableArray *timeArrays;//时效
@property (nonatomic, strong) JSDropDownMenu *jsMenu;
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArrays;
@property (nonatomic, assign) NSInteger areasCurrent;
@property (nonatomic, copy) NSString *city;
@end
@implementation LocalLawsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"法规库"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Esearch_SouSuo"];

    _page = 0;
    _city = @"";
    _time = @"";
    _timeCurrent = -1;
    _areasCurrent = 0;

    _dataArrays = [NSMutableArray array];
    _areasArrays = [NSMutableArray arrayWithObjects:@"全部法律",@"法律",@"行政法规",@"司法解释",@"部门规章",@"军事法规规章",@"行业规定",@"团体规定",@"中央规范性文件",@"地方性法规",@"地方规章",@"单行条例和自治条例",@"地方司法文件",@"地方规范性文件",@"外国语国际法律",@"立法动态", nil];
    _timeArrays = [NSMutableArray arrayWithObjects:@"按颁布时间",@"按生效时间", nil];

    _jsMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    _jsMenu.indicatorColor = LRRGBColor(175, 175, 175);
    _jsMenu.separatorColor = LRRGBColor(210, 210, 210);
    _jsMenu.textColor = thirdColor;
    _jsMenu.dataSource = self;
    _jsMenu.delegate = self;
    [self.view addSubview:_jsMenu];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,104.f, kMainScreenWidth, kMainScreenHeight-104.f) style:UITableViewStylePlain];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator= NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LawsTableViewCell" bundle:nil] forCellReuseIdentifier:LocalCellIdentifier];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{WEAKSELF;
     _page = 0;
    [NetWorkMangerTools lawsNewsListWithUrl:AreaLawsList withPage:_page witheff:_city withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays removeAllObjects];
        
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    [SVProgressHUD show];
    [NetWorkMangerTools lawsNewsListWithUrl:AreaLawsList withPage:_page witheff:_city withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawsTableViewCell*cell = (LawsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LocalCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LawsTableViewCell class]]) {
        LawsTableViewCell *lawCell = (LawsTableViewCell *)cell;
        if (_dataArrays.count >0) {
            [lawCell setDataModel:_dataArrays[indexPath.row]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArrays.count >0) {
        LawsDataModel *model = _dataArrays[indexPath.row];
        TaskModel *tmodel = [TaskModel new];
        [NetWorkMangerTools lawsDetailData:model.id RequestSuccess:^(id obj) {
            
            LawDetailModel *tempModel = (LawDetailModel *)obj;
            tmodel.idString =tempModel.id;
            tmodel.name = model.name;
            tmodel.content = tempModel.content;
            tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
            ContentViewController *vc = [ContentViewController new];
            vc.dType = lawsType;
            vc.model = tmodel;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

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
        return _areasCurrent;
    }
    return _timeCurrent;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _areasArrays.count;
    }
    return _timeArrays.count;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
        {
            return @"效力级别";
        }
            break;
        case 1:
        {
            return @"智能排序";
        }
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _areasArrays[indexPath.row];
    }
    return _timeArrays[indexPath.row];
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.column == 0) {
        _areasCurrent = indexPath.row;
        _city = _areasArrays[indexPath.row];
        if ([_city isEqualToString:@"全部法律"]) {
            _city = @"";
        }
        [weakSelf didSelectRowMenu];
    }else{
        _timeCurrent = indexPath.row;
        _time = [_timeArrays[indexPath.row] isEqualToString:@"按颁布时间"]?@"1":@"2";
//        if ([_time isEqualToString:@"全部"]) {
//            _time = @"";
//        }
        [weakSelf didSelectRowMenu];
    }
}
- (void)didSelectRowMenu{
    WEAKSELF;
     _page = 0;
    [NetWorkMangerTools lawsNewsListWithUrl:AreaLawsList withPage:_page witheff:_city withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arr];
        if (arr.count==0) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableView reloadData];
        _page ++;
    } fail:^{
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -event respose
- (void)rightBtnAction
{
    SecrchLawsVC *searchVC = [SecrchLawsVC new];
    [AnimationTools makeAnimationFade:searchVC :self.navigationController];

//    [self.navigationController  pushViewController:searchVC animated:YES];
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
