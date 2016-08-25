//
//  MyPlanViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyPlanViewController.h"
#import "FDCalendar.h"
#import "PlanTableViewCell.h"
#import "AddAlertVC.h"
#import "RemindData.h"
#import "AllPlanViewController.h"

static NSString *const PlanCellIdentifier = @"planCellIdentifier";

@interface MyPlanViewController ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArr;
@property (strong, nonatomic)  FDCalendar *calendar;
@property (assign, nonatomic) BOOL isToday;
@property (copy, nonatomic) NSString *noDayString;//时间戳
@property (nonatomic, strong) UIView *lookView;

@end

@implementation MyPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initUI];
}
- (void)initUI
{
    _dataSourceArr = [NSMutableArray array];
    [self setupNaviBarWithTitle:@"我的日程"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];

    _isToday = YES;
    [self setCalendarWithDate:[NSDate date]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,345.6, kMainScreenWidth, kMainScreenHeight-345.6f) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PlanTableViewCell" bundle:nil] forCellReuseIdentifier:PlanCellIdentifier];
    
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
    [self getNowDatePlan:timeSJC];
}
- (void)getNowDatePlan:(NSString *)dateString
{
    WEAKSELF;
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *url = [NSString stringWithFormat:@"%@%@time=%@&uid=%@",kProjectBaseUrl,RemindList,dateString,UID];
    [ZhouDao_NetWorkManger GetJSONWithUrl:url success:^(NSDictionary *jsonDic) {
        [MBProgressHUD hideHUD];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        weakSelf.tableView.tableFooterView = nil;
        [weakSelf.lookView removeFromSuperview];

//        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
//            [JKPromptView showWithImageName:nil message:msg];
            weakSelf.lookView = [weakSelf lookAllScheduleView];
            [weakSelf.view addSubview:weakSelf.lookView];
            return ;
        }
        if ([jsonDic[@"data"] isKindOfClass:[NSDictionary class]]) {
            NSArray *valueArr = [jsonDic[@"data"] allValues];
            for (NSDictionary *dict in valueArr) {
                RemindData *model = [[RemindData alloc] initWithDictionary:dict];
                [weakSelf.dataSourceArr addObject:model];
            }
        }else{
            NSMutableArray *arrays = jsonDic[@"data"];
            for (NSDictionary *dict in arrays) {
                RemindData *model = [[RemindData alloc] initWithDictionary:dict];
                [weakSelf.dataSourceArr addObject:model];
            }
        }
        if (weakSelf.dataSourceArr.count >0) {
            weakSelf.tableView.tableFooterView = [weakSelf tabFootBtn];
        }
        [weakSelf.tableView reloadData];
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanTableViewCell *cell = (PlanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PlanCellIdentifier];
    cell.rightUtilityButtons = [self normalRightButtons];
    cell.delegate = self;
    cell.isToday = _isToday;
    cell.noDayString = _noDayString;
    if (_dataSourceArr.count >0) {
        [cell setModel:_dataSourceArr[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    RemindData *model = _dataSourceArr[row];
    [self goToEditVC:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.f;
}
- (NSArray *)normalRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     KNavigationBarColor
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#dfdcdc"]
                                                title:@"删除"];
    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            DLog(@"utility buttons closed");
            break;
        case 1:
            DLog(@"left utility buttons open");
            break;
        case 2:
            DLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = cellIndexPath.row;
    RemindData *model = _dataSourceArr[row];
    WEAKSELF;
    switch (index) {
        case 0:
        {DLog(@"编辑按钮被点击");
            [self goToEditVC:model];
            break;
        }
        case 1:
        {// 删除
            [NetWorkMangerTools deleteSelectRemind:model.id RequestSuccess:^{
                
                [weakSelf.dataSourceArr removeObjectAtIndex:row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:model.id];
            }];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    return YES;
}
- (void)loadAllData{
    
    AllPlanViewController *allPlan = [AllPlanViewController new];
    [self.navigationController  pushViewController:allPlan animated:YES];
}
- (UIView *)lookAllScheduleView
{WEAKSELF;
    UIView *lookView = [[UIView alloc] init];
    lookView.center = _tableView.center;
    lookView.bounds = CGRectMake(0, 0, 200, 20);
    lookView.backgroundColor = [UIColor clearColor];
    [lookView whenTapped:^{
        [weakSelf loadAllData];
    }];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    lab1.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"当天无日程,点击查看全部"];
    NSRange range1=[[hintString string]rangeOfString:@"当天无日程，"];
    [hintString addAttribute:NSForegroundColorAttributeName value:SIXCOLOR range:range1];
    NSRange range2=[[hintString string]rangeOfString:@"点击查看全部"];
    [hintString addAttribute:NSForegroundColorAttributeName value:KNavigationBarColor range:range2];
    lab1.attributedText=hintString;
    lab1.font = Font_14;
    [lookView addSubview:lab1];
    return lookView;
}
- (UIButton *)tabFootBtn{
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [moreBtn setTitleColor:SIXCOLOR forState:0];
    moreBtn.titleLabel.font = Font_14;
    moreBtn.frame = CGRectMake(0, 0, kMainScreenWidth , 40);
    [moreBtn setTitle:@"点击查看更多" forState:0];
    [moreBtn addTarget:self action:@selector(loadAllData) forControlEvents:UIControlEventTouchUpInside];
    return moreBtn;
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    WEAKSELF;
    AddAlertVC *vc = [AddAlertVC new];
    vc.alertType = FromAddBtn;
    vc.successBlock = ^(NSDate *date,NSString *sjcStr){
        
        weakSelf.noDayString = sjcStr;
        [weakSelf setCalendarWithDate:date];
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf getNowDatePlan:sjcStr];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setCalendarWithDate:(NSDate *)date
{
    if ([QZManager compareOneDay:date withAnotherDay:[NSDate date]] == 1) {
        _isToday = NO;
    }else{
        _isToday = YES;
    }
    [_calendar removeFromSuperview];
    _calendar = [[FDCalendar alloc] initWithCurrentDate:date];
    CGRect frame = _calendar.frame;
    WEAKSELF;
    _calendar.calendarBlock = ^(NSString *dateString){
        
        weakSelf.noDayString = dateString;
         NSDate *date1 = [QZManager timeStampChangeNSDate:[dateString doubleValue]];
        if ([QZManager compareOneDay:date1 withAnotherDay:[NSDate date]] == 1) {
            weakSelf.isToday = NO;
        }else{
            weakSelf.isToday = YES;
        }
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf getNowDatePlan:dateString];
    };
    frame.origin.y = 64;
    //calendar.frame = frame;
    _calendar.frame = CGRectMake(0, 64, kMainScreenWidth, 276.6);
    [self.view addSubview:_calendar];

}
#pragma mark -编辑事件
- (void)goToEditVC:(RemindData *)model
{WEAKSELF;
    AddAlertVC *vc = [AddAlertVC new];
    vc.successBlock = ^(NSDate *date,NSString *sjcStr){
        
        weakSelf.noDayString = sjcStr;
        [weakSelf setCalendarWithDate:date];
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf getNowDatePlan:sjcStr];
    };
    vc.alertType = FromEditBtn;
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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
