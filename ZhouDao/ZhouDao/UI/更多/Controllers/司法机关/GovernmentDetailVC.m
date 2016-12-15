//
//  GovernmentDetailVC.m
//  ZhouDao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovernmentDetailVC.h"
#import "GovDetailCell.h"
#import "GovListCell.h"
#import "LoginViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "AMapLocationKit.h"

#import "DeriveMapVC.h"
#import "MapNavViewController.h"
#import "ZD_AlertWindow.h"
#import "GovHECViewController.h"
#import "LCActionSheet.h"
#import "TingShiHeadView.h"
#import "TingShiListCell.h"
#import "TingShiListVC.h"
#import "Courtroom_base.h"
#import "Courtroom_linkman.h"

static NSString *const DetailCellIdentifier = @"DetailCellIdentifier";
static NSString *const twoDetailCellIdentifier = @"twoDetailCellIdentifier";

@interface GovernmentDetailVC ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate,AMapLocationManagerDelegate,ZD_AlertWindowPro,TingShiHeadViewPro> {
    
}
@property (nonatomic, strong)  AMapSearchAPI *search;
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  UIWebView *callPhoneWebView;
@property (nonatomic, strong)  AMapNaviPoint *endPoint; //导航时候 目标终点
@property (nonatomic, strong)  AMapNaviPoint *startPoint;
@property (nonatomic, strong)  AMapLocationManager *locationService;//定位服务
@property (nonatomic, strong)  UIButton *storeBtn;//收藏
@property (nonatomic, strong)  UIButton *errorBtn;//纠错
@property (nonatomic, strong)  NSMutableArray *kindArrays;
@property (nonatomic, copy)    NSString *mapStyle;//导航地图 (高德，百度，腾讯)

@end

@implementation GovernmentDetailVC

#pragma mark - life cycle
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_tableView);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self userLocationService];//开始定位
    
    [self searchDetailCode];
    [self initUI];
}
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBarWithTitle:@"详情"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.errorBtn];
    [self.view addSubview:self.storeBtn];
    
    [self.view addSubview:[[TingShiHeadView alloc] initEmailErrorCorrectionWithFrame:CGRectMake(0, kMainScreenHeight - 60.f, kMainScreenWidth, 30.f)]];
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
    }else if (section == 1) {
        
        return 0;
    }else if (section == 2 + [_model.courtroom_base count]) {
        return 1;
    } else {
        Courtroom_base *baseModel = _model.courtroom_base[section - 2];
        if (baseModel.isFlag) {
            return [baseModel.courtroom_linkman count];
        }
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_model.courtroom_base count] + 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0 || indexPath.section == 2 + [_model.courtroom_base count]) {
        
        [self.tableView registerClass:[GovDetailCell class] forCellReuseIdentifier:DetailCellIdentifier];
        GovDetailCell *cell = (GovDetailCell *)[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            [cell setGovermentPictureUI:_model];
        } else if (indexPath.section == 2 + [_model.courtroom_base count]) {
            
            [cell setDetailIntroductionText:_model.introduce];
        } else {
            [cell SetPhoneNumberAndAddress:_model withIndexRow:indexPath.row];
        }
        return cell;
    }
    
    [tableView registerClass:[TingShiListCell class] forCellReuseIdentifier:twoDetailCellIdentifier];
    TingShiListCell *cell = (TingShiListCell *)[tableView dequeueReusableCellWithIdentifier:twoDetailCellIdentifier];
    Courtroom_base *baseModel = _model.courtroom_base[indexPath.section - 2];

    if (indexPath.row == 0) {
        
        [cell setAddressUIWithIndexRow:indexPath.row withCourtroom_base:baseModel];
    } else {
        
        [cell setContactUIWithIndexRow:indexPath.row withCourtroom_base:baseModel];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return nil;
    }else if (section == 1) {
        
        return [[TingShiHeadView alloc] initTingShiHeadViewWithDelegate:self];
    }else if (section == 2 + [_model.courtroom_base count]) {
        
        return [[TingShiHeadView alloc] initIntroductionToThe];
    }
    Courtroom_base *baseModel = _model.courtroom_base[section - 2];

    return [[TingShiHeadView alloc] initAdministrativeTrialWithSection:section withCourtroom_base:baseModel withDelegate:self];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else if (section == 2 + [_model.courtroom_base count] || section == 1) {
        
        return 60;
    }
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return (indexPath.row == 0) ? 100.f : 45;
    } else if (indexPath.section == 2 + [_model.courtroom_base count]) {
        GovDetailCell *cell = (GovDetailCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.rowHeight;
    }
    return (indexPath.row == 0) ? 45.f : 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleReview withTextAlignment:NSTextAlignmentLeft Title:@"审查说明" WithOptionArrays:[NSArray array]];
            
            [self.view addSubview:alertWindow];

        } else if(indexPath.row == 1){
            
            if (!_endPoint) {
                [JKPromptView showWithImageName:nil message:@"获取目标地理位置失败!"];
                return;
            }
            
            if (!_startPoint) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有开启定位 ，请您开启定位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置》", nil];
                alertView.tag = 6389;
                [alertView show];
                return;
            }
            
            [self whatKindOfMapForInstallation];
            
        } else if (indexPath.row == 2) {
            
            if (_model.phone.length > 0) {
                if ([QZManager isString:_model.phone withContainsStr:@"/"] == YES) {
                    
                    NSArray *array = [_model.phone componentsSeparatedByString:@"/"];
                    ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStylePhone withTextAlignment:NSTextAlignmentLeft Title:@"选择号码" WithOptionArrays:array];
                    alertWindow.delegate = self;
                    [self.view addSubview:alertWindow];
                    
                }else {
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.phone]]];
                    [self.callPhoneWebView loadRequest:request];
                }
            }
        }
    }
}
#pragma mark - TingShiHeadViewPro
- (void)selectTingShiItem {
    
    //查看庭室列表
    TingShiListVC *listVC = [TingShiListVC new];
    NSMutableArray *baseArrays = [NSMutableArray array];
    baseArrays = [_model.courtroom_base mutableCopy];
    listVC.baseSourceArrays = baseArrays;
    listVC.jidString = _model.id;
    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)onAddOffClickWithSection:(NSUInteger)section {
    
    Courtroom_base *baseModel = _model.courtroom_base[section - 2];
    baseModel.isFlag = !baseModel.isFlag;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 得到手机安装了哪几种地图
- (void)whatKindOfMapForInstallation {
    
    [self.kindArrays removeAllObjects];//清空数组
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        [_kindArrays addObject:@"百度地图"];
    }
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [_kindArrays addObject:@"高德地图"];
    }
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        
        [_kindArrays addObject:@"腾讯地图"];
    }
    
    if ([_kindArrays count] == 0) {
        //未安装以上几种地图 调用高德SDK
        
        [_kindArrays addObjectsFromArray:@[@"驾车导航",@"步行导航"]];
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleNAV withTextAlignment:NSTextAlignmentLeft Title:@"选择导航模式" WithOptionArrays:_kindArrays];
        alertWindow.delegate = self;
        [self.view addSubview:alertWindow];
        
    } else {
        
        //显示选择第三方地图
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleKindsMAP withTextAlignment:NSTextAlignmentLeft Title:@"选择导航地图" WithOptionArrays:_kindArrays];
        alertWindow.delegate = self;
        [self.view addSubview:alertWindow];
    }
}
#pragma mark - 百度导航
-(void)onDaoHangForBaiDuMapWithModelStyle:(NSString *)modelStyle {
    /*
     location	lat<纬度>,lng<经度>	必选
     title	标注点显示标题	必选	product下可直接跟方法，当然产品线也可增加一个service级别
     content	标注点显示内容	必选
     coord_type	坐标类型，可选参数，默认为bd09ll。	可选	允许的值为bd09ll、gcj02、wgs84。bd09ll表示百度经纬度坐标， gcj02表示经过国测局坐标，wgs84表示gps获取的坐标。
     zoom	展现地图的级别，默认为视觉最优级别。	可选
     src	调用来源，规则：companyName|appName。	必选	此参数不传值，不保证服务。
     */
    
    NSString * openUrl = [[NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=%@&mode=%@&region=%@&src=法大秘",_model.name,modelStyle,[PublicFunction ShareInstance].locCity] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
}
#pragma mark - 高德导航
-(void)onDaoHangForGaoDeMapWithModelStyle:(NSString *)modelStyle  {
    
    /*
     m 驾车：0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵 公交：0：最快捷，2：最少换乘，3：最少步行，5：不乘地铁 ，7：只坐地铁 ，8：时间短  是
     t = 0：驾车 =1：公交 =2：步行
     */
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",_startPoint.latitude,_startPoint.longitude, _endPoint.latitude,_endPoint.longitude,_model.name,modelStyle] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
#pragma mark - 腾讯导航
-(void)onDaoHangForTengXunMapWithModelStyle:(NSString *)modelStyle  {
    
    NSString *openUrl = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=%@&from=%@&to=%@&policy=0&referer=法大秘",modelStyle,[PublicFunction ShareInstance].formatAddress,_model.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 6389 && buttonIndex == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark - ZD_AlertWindowPro
- (void)customAlertView:(ZD_AlertWindow *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.style == ZD_AlertViewStyleNAV) {
        //选择集成的 高德SDK 导航的方式
        if (buttonIndex == 0) {
            
            DeriveMapVC *mapVC = [DeriveMapVC new];
            mapVC.endPoint   = _endPoint;
            mapVC.startPoint = _startPoint;
            [self.navigationController pushViewController:mapVC animated:YES];
            
        }else {
            
            MapNavViewController *vc = [MapNavViewController new];
            vc.endPoint   = _endPoint;
            vc.startPoint = _startPoint;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (alertView.style == ZD_AlertViewStyleKindsMAP) {
        
        //选择了哪个第三方地图
        _mapStyle = _kindArrays[buttonIndex];
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleMAPNAV withTextAlignment:NSTextAlignmentLeft Title:@"选择导航模式" WithOptionArrays:@[@"公交",@"驾车",@"步行"]];
        alertWindow.delegate = self;
        [self.view addSubview:alertWindow];
        
    }else if (alertView.style == ZD_AlertViewStyleMAPNAV) {
        //选择第三方应用导航模式
        NSArray *modelArrays = @[@"公交",@"驾车",@"步行"];
        NSString *tempStyle = modelArrays[buttonIndex];
        
        if ([_mapStyle isEqualToString:@"百度地图"]) {
            
            NSDictionary *modelDictionqry = [NSDictionary dictionaryWithObjectsAndKeys:@"transit",@"公交",@"driving",@"驾车",@"walking",@"步行", nil];
            NSString *modelStyle = modelDictionqry[tempStyle];
            [self onDaoHangForBaiDuMapWithModelStyle:modelStyle];
            
        } else if ([_mapStyle isEqualToString:@"高德地图"]) {
            
            NSDictionary *modelDictionqry = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"公交",@"0",@"驾车",@"2",@"步行", nil];
            NSString *modelStyle = modelDictionqry[tempStyle];
            [self onDaoHangForGaoDeMapWithModelStyle:modelStyle];
        } else if ([_mapStyle isEqualToString:@"腾讯地图"]) {
            
            NSDictionary *modelDictionqry = [NSDictionary dictionaryWithObjectsAndKeys:@"bus",@"公交",@"drive",@"驾车",@"walk",@"步行", nil];
            NSString *modelStyle = modelDictionqry[tempStyle];
            [self onDaoHangForTengXunMapWithModelStyle:modelStyle];
        }
        
    }else if (alertView.style == ZD_AlertViewStylePhone) {
        //选择电话号码
        NSArray *array = [_model.phone componentsSeparatedByString:@"/"];
        NSString *phoneString = array[buttonIndex];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneString]]];
        [self.callPhoneWebView loadRequest:request];
    }
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction { WEAKSELF;
    DLog(@"收藏");
    if ([PublicFunction ShareInstance].m_bLogin == NO) {
        [JKPromptView showWithImageName:nil message:LOCLOGINCOLLECT];
        LoginViewController *loginVc = [LoginViewController new];
        loginVc.closeBlock = ^{
            if ([PublicFunction ShareInstance].m_bLogin == YES) {
                [NetWorkMangerTools goverDetailWithId:_model.id RequestSuccess:^(id obj) {
                    GovListmodel *tempModel = (GovListmodel *)obj;
                    _model = tempModel;
                    if ([weakSelf.model.is_collection  integerValue] == 0) {
                        [weakSelf.storeBtn setImage:kGetImage(@"template_shoucang") forState:0];
                        [weakSelf govCollectionMethod];
                    }else{
                        [weakSelf.storeBtn setImage:kGetImage(@"template_SC") forState:0];
                    }
                }];
            }
        };
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVc] animated:YES completion:nil];
        return;
    }
    
    if ([_model.is_collection  integerValue] == 0) {
        
        [self govCollectionMethod];
    }else{
        
        [NetWorkMangerTools collectionDelMine:_model.id withType:govCollect RequestSuccess:^{
            _model.is_collection = @0;
            [weakSelf.storeBtn setImage:kGetImage(@"template_shoucang") forState:0];
        }];
    }
}
- (void)govCollectionMethod{ WEAKSELF;
    
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:govCollect,@"type",_model.id,@"article_id",_model.name,@"article_title",_model.address,@"article_subtitle",timeSJC,@"article_time",UID,@"uid", nil];
    [NetWorkMangerTools collectionAddMine:dictionary RequestSuccess:^{
        
        _model.is_collection = @1;
        [weakSelf.storeBtn setImage:kGetImage(@"template_SC") forState:0];
    }];
}
- (void)goToErrorEvent:(id)sender {
    
    GovHECViewController *vc = [GovHECViewController new];
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - getters and setters
- (UIButton *)storeBtn {
    if (!_storeBtn) {
        _storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _storeBtn.frame = CGRectMake(kMainScreenWidth -45.f,27.f, 30, 30);
        if ([self.model.is_collection  integerValue] == 0) {
            [_storeBtn setImage:kGetImage(@"template_shoucang") forState:0];
        }else{
            [_storeBtn setImage:kGetImage(@"template_SC") forState:0];
        }
        [_storeBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeBtn;
}
- (UIButton *)errorBtn
{
    if (!_errorBtn) {
        _errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _errorBtn.frame = CGRectMake(kMainScreenWidth - 90.f,27.f, 30, 30);
        [_errorBtn setImage:kGetImage(@"Gov_Edit") forState:0];
        [_errorBtn addTarget:self action:@selector(goToErrorEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorBtn;
}
#pragma mark -打电话
- (UIWebView *)callPhoneWebView {
    if (!_callPhoneWebView) {
        _callPhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _callPhoneWebView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-124.f) style:UITableViewStyleGrouped];
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}
- (NSMutableArray *)kindArrays {
    
    if (!_kindArrays) {
        
        _kindArrays = [NSMutableArray array];
    }
    return _kindArrays;
}
#pragma mark -获取地理位置信息
- (void)userLocationService {
    
    _locationService = [[AMapLocationManager alloc] init];
    _locationService.delegate = self;
    [_locationService startUpdatingLocation];//开启定位
}
#pragma mark - MapView Delegate 更新地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
    if (location) {
        _startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        [_locationService stopUpdatingLocation];//停止定位
    }
}
#pragma mark -地理编码
- (void)searchDetailCode {
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = [NSString stringWithFormat:@"%@%@",_detailAddress,_model.name];
    //发起正向地理编码
    [_search AMapGeocodeSearch: geo];
}
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response {
    
    if(response.geocodes.count == 0) {
        return;
    }
    //通过AMapGeocodeSearchResponse对象处理搜索结果
    DLog(@"多少个地址---- %@",[NSString stringWithFormat:@"count: %ld", (long)response.count]);
    
    //    AMapTip *p = response.geocodes[0];
    AMapGeocode *p = response.geocodes[0];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:p.location.latitude longitude:p.location.longitude];
    //    DLog(@"Geocode: %@", result);
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
