//
//  MeViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "MineCerVCr.h"
#import "HeadTableViewCell.h"
#import "ProfessionalCell.h"
#import "CommonViewCell.h"
#import "MyCollectionVC.h"
#import "AboutZDVC.h"
#import "FeedbackViewController.h"
#import "MineSettingVC.h"
#import  "MyPlanViewController.h"
#import "MyAdvantagesVC.h"
#import "AdvantagesModel.h"
#import "TheCaseManageVC.h"//案件管理
//#import "ScanViewController.h" //扫一扫

//#import ""
static NSString *const HeadCellIdentifier = @"MeCellIdentifier";
static NSString *const COMCellIdentifier = @"commenCellIdentifier";
static NSString *const ProCellIdentifier = @"ProfessionalCellIdentifier";

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _twoSectionH;//第二区的高度
    NSUInteger _sectionCount;
}
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic,strong) LoginViewController *loginvc;
@property (nonatomic,strong) NSMutableArray *domainArrays;//擅长领域
@property (nonatomic, assign) BOOL isCer;//是否需要显示认证

@end

@implementation MeViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    if ([[PublicFunction ShareInstance].m_user.data.type isEqualToString:@"1"]) {
//        _sectionCount = 6;
//        _isCer = YES;
//    }else{
        _sectionCount = 5;
        _isCer = NO;
//    }
    [self initView];
}
#pragma mark - private methods
- (void)initView
{
    [self setupNaviBarWithTitle:@"我的"];
//    [self setupNaviBarWithBtn:NaviRightBtn title:@"扫一扫" img:nil];

    self.view.backgroundColor = ViewBackColor;
    
    if ([PublicFunction ShareInstance].m_bLogin == YES)
    {
        [self getDomainUser];
    }

    _twoSectionH = 44.f;
    _domainArrays = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == _sectionCount - 3 || section ==_sectionCount - 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section == 0) {
        [tableView registerClass:[HeadTableViewCell class] forCellReuseIdentifier:HeadCellIdentifier];
        HeadTableViewCell *cell = (HeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HeadCellIdentifier];
        [cell reloadNameWithPhone];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (section == _sectionCount - 4) {
        [tableView registerClass:[ProfessionalCell class] forCellReuseIdentifier:ProCellIdentifier];
        ProfessionalCell *cell = (ProfessionalCell *)[tableView dequeueReusableCellWithIdentifier:ProCellIdentifier];
        [cell setDomainArrays:_domainArrays];
        return cell;
    }
    [tableView registerClass:[CommonViewCell class] forCellReuseIdentifier:COMCellIdentifier];

    
    CommonViewCell *cell = (CommonViewCell *)[tableView dequeueReusableCellWithIdentifier:COMCellIdentifier];
    cell.isCer = _isCer;
    cell.section = section; cell.row = row;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row;
    NSUInteger section = indexPath.section;
    WEAKSELF;
    
    if (_sectionCount == 5) {
        if (section == 1) {
            [self layoutdomainCell];
        }
    }else{
        if (section == 1){
            MineCerVCr *cerVC = [MineCerVCr new];
            [self.navigationController pushViewController:cerVC animated:YES];
        }else if (section == 2){
            [self layoutdomainCell];
        }
    }
    
    if (section == 0) {
        MineSettingVC *setvc = [MineSettingVC new];
        /****************认证*****************/
//        setvc.profBlock = ^{
//            
//            if ([[PublicFunction ShareInstance].m_user.data.type isEqualToString:@"1"])
//            {
//                weakSelf.isCer = YES;
//                _sectionCount = 6;
//            }else{
//                weakSelf.isCer = NO;
//                _sectionCount = 5;
//            }
//            [weakSelf.tableView reloadData];
//        };
        setvc.exitBlock = ^{
            
            [UIView animateWithDuration:0.35f animations:^{
                
                weakSelf.tabBarController.selectedIndex = 0;
            }];
        };
        [self.navigationController pushViewController:setvc animated:YES];
    }else if (section == _sectionCount - 3 && index == 0){
        MyCollectionVC  *collection = [MyCollectionVC new];
        [self.navigationController pushViewController:collection animated:YES];
    }else if (section == _sectionCount - 1 && index == 1){
        AboutZDVC  *aboutVC = [AboutZDVC new];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (section == _sectionCount - 1 && index == 0){
        FeedbackViewController *feedVC = [FeedbackViewController new];
        [self.navigationController pushViewController:feedVC animated:YES];
    }else if (section == _sectionCount - 3 && index == 1){
        MyPlanViewController *planVC = [MyPlanViewController new];
        [self.navigationController pushViewController:planVC animated:YES];
    }else if (section == _sectionCount - 2 && index == 0){
//        [JKPromptView showWithImageName:nil message:@"功能正在开发中,敬请期待"];

        TheCaseManageVC *vc = [TheCaseManageVC new];
        vc.type = FromMineType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80.f;
    }else if (indexPath.section == _sectionCount - 4){
        return _twoSectionH;
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.f;
    }
    return 10.f;
}
#pragma mark - 擅长领域cell
- (void)layoutdomainCell{WEAKSELF;
    MyAdvantagesVC *advantageVC = [MyAdvantagesVC new];
    advantageVC.type = SelectMine;//从我的界面过去
    advantageVC.compareArr = _domainArrays;
    advantageVC.domainBlock = ^(NSMutableArray *arr){
        
        [weakSelf.domainArrays removeAllObjects];
        weakSelf.domainArrays = arr;
        if (arr.count  == 0) {
            _twoSectionH = 44.f;
        }else if (arr.count >0 && arr.count <5){
            _twoSectionH = 80.f;
        }else if (arr.count >=5 && arr.count <9){
            _twoSectionH = 125.f;
        }else{
            _twoSectionH = 170.f;
        }
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2], nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self presentViewController:advantageVC animated:YES completion:nil];
}
#pragma mark - event respose
//- (void)rightBtnAction
//{
//    ScanViewController *vc = [ScanViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark - 获取用户擅长领域
- (void)getDomainUser
{
    _domainArrays = [NSMutableArray array];
    WEAKSELF;
    [NetWorkMangerTools getUserDomainRequestSuccess:^(CGFloat height, NSMutableArray *arr) {
        
        weakSelf.domainArrays = arr;
        _twoSectionH = height;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:_sectionCount - 4], nil] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}
#pragma mark - setters and getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,74, kMainScreenWidth, kMainScreenHeight-123.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
