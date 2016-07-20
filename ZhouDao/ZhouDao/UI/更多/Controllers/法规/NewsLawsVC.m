//
//  NewsLawsVC.m
//  ZhouDao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NewsLawsVC.h"
#import "JSDropDownMenu.h"
#import "LawsTableViewCell.h"
#import "ContentViewController.h"
#import "LawDetailModel.h"
static NSString *const NewsCellIdentifier = @"NewsCellIdentifier";

@interface NewsLawsVC ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>

{
    NSInteger _effectCurrent;
    NSInteger _timeCurrent;
    NSUInteger _page;
    NSString *_eff;
    NSString *_time;
    NSString *_urlString;
}

@property (nonatomic, strong) NSMutableArray *effectArr;//地区
@property (nonatomic, strong) NSMutableArray *timeArr;//时效
@property (nonatomic, strong) JSDropDownMenu *jsMenu;
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArrays;

@end
@implementation NewsLawsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI{
    
    CGRect tabFrame ;
    if (_lawType == commonlyType) {
        [self setupNaviBarWithTitle:@"常用法规"];
        _urlString = CommonLawsList;
        tabFrame = CGRectMake(0, 64.f, kMainScreenWidth, kMainScreenHeight - 64.f);
    }else{
        [self setupNaviBarWithTitle:@"新法速递"];
        _urlString = NewLawSDList;
        [self dropDownBoxToChoose];
        tabFrame = CGRectMake(0,104.f, kMainScreenWidth, kMainScreenHeight-104.f);
    }
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _page = 0;
    _time = @"";
    _eff = @"";
    
    _dataArrays = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:tabFrame style:UITableViewStylePlain];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator= NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LawsTableViewCell" bundle:nil] forCellReuseIdentifier:NewsCellIdentifier];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    
    [SVProgressHUD show];
    // 马上进入刷新状态
    [_tableView.mj_header beginRefreshing];
}
#pragma mark - 下拉框选择
- (void)dropDownBoxToChoose
{
    _effectCurrent = 0;
    _timeCurrent = -1;
    _effectArr = [NSMutableArray arrayWithObjects:@"全部法律",@"法律",@"行政法规",@"司法解释",@"部门规章",@"军事法规规章",@"行业规定",@"团体规定",@"中央规范性文件",@"地方性法规",@"地方规章",@"单行条例和自治条例",@"地方司法文件",@"地方规范性文件",@"外国语国际法律",@"立法动态", nil];
    _timeArr = [NSMutableArray arrayWithObjects:@"按颁布时间",@"按生效时间", nil];
    
    _jsMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    _jsMenu.indicatorColor = LRRGBColor(175, 175, 175);
    _jsMenu.separatorColor = LRRGBColor(210, 210, 210);
    _jsMenu.textColor = thirdColor;
    _jsMenu.dataSource = self;
    _jsMenu.delegate = self;
    [self.view addSubview:_jsMenu];

}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{WEAKSELF;
    _page = 0;
    [NetWorkMangerTools lawsNewsListWithUrl:_urlString withPage:_page witheff:_eff withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    [NetWorkMangerTools lawsNewsListWithUrl:_urlString withPage:_page witheff:_eff withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [_dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page ++;
    } fail:^{
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
    LawsTableViewCell*cell = (LawsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
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
        return _effectCurrent;
    }
    return _timeCurrent;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (column==0) {
        return _effectArr.count;
    }
    return _timeArr.count;
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
        return _effectArr[indexPath.row];
    }
    return _timeArr[indexPath.row];
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    WEAKSELF;
    if (indexPath.column == 0) {
        _effectCurrent = indexPath.row;
        _eff = _effectArr[indexPath.row];
        if ([_eff isEqualToString:@"全部法律"]) {
            _eff = @"";
        }
        [weakSelf didSelectRowMenu];
    }else{
        _timeCurrent = indexPath.row;
        _time = [_timeArr[indexPath.row] isEqualToString:@"按颁布时间"]?@"1":@"2";
//        if ([_time isEqualToString:@"全部"]) {
//            _time = @"";
//        }
        [weakSelf didSelectRowMenu];
    }
}
- (void)didSelectRowMenu{
    WEAKSELF;
    _page = 0;
    [NetWorkMangerTools lawsNewsListWithUrl:_urlString withPage:_page witheff:_eff withTime:_time RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
        _page ++;
    } fail:^{
        [weakSelf.dataArrays removeAllObjects];
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
