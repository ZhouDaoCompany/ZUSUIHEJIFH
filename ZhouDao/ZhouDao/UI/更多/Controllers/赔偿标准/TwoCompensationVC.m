//
//  TwoCompensationVC.m
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TwoCompensationVC.h"
#import "JSDropDownMenu.h"
#import "TwoCompensationCell.h"
#import "ContentViewController.h"
#import "CompensationData.h"
#import "IndemnityData.h"
#import "TaskModel.h"
static NSString *const TwoCompensationID = @"TwoCompensationID";

@interface TwoCompensationVC ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    NSUInteger _yearCurrent;
    
    NSString *_yearString;
}
@property (nonatomic, strong) NSMutableArray *provinceArr;//地区
@property (nonatomic, strong) NSMutableArray *yearArr;//时效
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArrays;//列表数据
@property (nonatomic, strong) JSDropDownMenu *jsMenu;
@property (nonatomic, assign) NSUInteger provinceCurrent;
@property (nonatomic, copy) NSString *cityString;
@end

@implementation TwoCompensationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI{
    [self setupNaviBarWithTitle:@"赔偿标准"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    /**
     *  头部数据
     */
    [self getData];
    
    [self.view addSubview:self.jsMenu];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_jsMenu), kMainScreenWidth, .6f)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    _dataArrays = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    [self loadData:_cityString withYear:_yearString];
}
#pragma mark - private methods
#pragma mark - setters and getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,104.6f, kMainScreenWidth, kMainScreenHeight-104.6f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerNib:[UINib nibWithNibName:@"TwoCompensationCell" bundle:nil] forCellReuseIdentifier:TwoCompensationID];
    }
    return _tableView;
}
- (JSDropDownMenu *)jsMenu
{
    if (!_jsMenu) {
        _jsMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
        _jsMenu.indicatorColor = LRRGBColor(175, 175, 175);
        _jsMenu.separatorColor = LRRGBColor(210, 210, 210);
        _jsMenu.textColor = thirdColor;
        _jsMenu.dataSource = self;
        _jsMenu.delegate = self;
    }
    return _jsMenu;
}


- (void)loadData:(NSString *)city withYear:(NSString *)year
{
    WEAKSELF;
    [NetWorkMangerTools getcompensationList:_classId withCity:city withYear:year RequestSuccess:^(NSArray *arrays) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arrays];
        [weakSelf.tableView reloadData];
    } fail:^{
        [weakSelf.tableView reloadData];
    }];
}
- (void)getData{
    WEAKSELF;
    _provinceArr =  ProvinceArrays;
    //默认选中
    _provinceCurrent = 0;
    if ([PublicFunction ShareInstance].locProv.length >0) {
        [_provinceArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![[PublicFunction ShareInstance].locProv rangeOfString:obj].location) {
                weakSelf.provinceCurrent = idx;
                weakSelf.cityString = obj;
            }
        }];
    }else{
        _cityString = @"北京";
    }
    
    _yearArr = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *nowDate =[NSDate date];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSUInteger nowYear = [dateComponent year];
    
    for (NSUInteger i = nowYear; i >=2014; i--)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(unsigned long)i];
        [_yearArr addObject:yearStr];
    }
     _yearString = _yearArr[0];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwoCompensationCell *cell = (TwoCompensationCell *)[tableView dequeueReusableCellWithIdentifier:TwoCompensationID];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TwoCompensationCell class]])
    {
        TwoCompensationCell *sationCell = (TwoCompensationCell *)cell;
        if (_dataArrays.count >0) {
            [sationCell setDataModel:_dataArrays[indexPath.row]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompensationData *model = _dataArrays[indexPath.row];
    TaskModel *tModel = [TaskModel new];
    
    WEAKSELF;
    [NetWorkMangerTools getcompensationDetailswith:model.id RequestSuccess:^(id obj) {
        
        IndemnityData *dataModel = (IndemnityData *)obj;
        tModel.idString = dataModel.id;
        tModel.name = dataModel.title;
        tModel.content = dataModel.content;
        tModel.is_collection = [NSString stringWithFormat:@"%@",dataModel.is_collection];
        ContentViewController *contentVC = [ContentViewController new];
        contentVC.dType = IndemnityType;
        contentVC.model = tModel;
        [weakSelf.navigationController pushViewController:contentVC animated:YES];
    }];
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
        return _provinceCurrent;
    }
    return _yearCurrent;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        return _provinceArr.count;
    }
    return _yearArr.count;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return _provinceArr[_provinceCurrent];
            break;
        case 1: return _yearArr[_yearCurrent];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return _provinceArr[indexPath.row];
    }
    return _yearArr[indexPath.row];
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if (indexPath.column == 0) {
        _provinceCurrent = indexPath.row;
        _cityString = _provinceArr[indexPath.row];
    }else{
        _yearCurrent = indexPath.row;
        _yearString = _yearArr[indexPath.row];
    }
    [self loadData:_cityString withYear:_yearString];
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
