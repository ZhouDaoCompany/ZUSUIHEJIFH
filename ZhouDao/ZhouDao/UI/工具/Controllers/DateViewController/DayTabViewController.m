//
//  DayTabViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DayTabViewController.h"
#import "DayViewCell.h"
#import "ZHPickView.h"

static NSString *const DAYCellID = @"dayCellID";

@interface DayTabViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>


@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳

@end

@implementation DayTabViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[DayViewCell class] forCellReuseIdentifier:DAYCellID];
    WEAKSELF;
    [self.tableView whenCancelTapped:^{
        
        [weakSelf dismissKeyBoard];
    }];

}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{WEAKSELF;
    [self dismissKeyBoard];
    
    if (btn.tag == 3045) {
        
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView  endUpdates];
        
    }else{
        NSMutableArray *arr1 = _dataSourceArrays[0];
        for (NSString *dateString in arr1) {
            
            if (dateString.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您选择日期"];
                return;
            }
        }
        
        __block NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"", nil];
//        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",nil];
        
        [self calculateTheTotalDaysWithWorkingDaysFromDate:[QZManager timeStampChangeNSDate:[_startTime floatValue]] toDate:[QZManager timeStampChangeNSDate:[_endTime floatValue]] Success:^(NSString *allDays, NSString *workingDays) {
            
            [arr2 addObject:allDays];
            [arr2 addObject:workingDays];
            
        }];
        
        [self calculateYearsWithMonthsFromDate:[QZManager timeStampChangeNSDate:[_startTime floatValue]] toDate:[QZManager timeStampChangeNSDate:[_endTime floatValue]] withYear:NO Success:^(NSString *dateString) {
            
            [arr2 insertObject:dateString atIndex:2];
        }];
        [self calculateYearsWithMonthsFromDate:[QZManager timeStampChangeNSDate:[_startTime floatValue]] toDate:[QZManager timeStampChangeNSDate:[_endTime floatValue]] withYear:YES Success:^(NSString *dateString) {
            
            [arr2 insertObject:dateString atIndex:3];
        }];

        [_dataSourceArrays addObject:arr2];
        [UIView animateWithDuration:.25 animations:^{
            [weakSelf.tableView reloadData];
        }];

    }
    

    DLog(@"计算或者重置");
}

#pragma mark - 计算总天数 工作日
- (void)calculateTheTotalDaysWithWorkingDaysFromDate:(NSDate *)date1 toDate:(NSDate *)date2 Success:(void(^)(NSString *allDays,NSString *workingDays))success
{
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags =  NSCalendarUnitDay;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    //两个日期相距的天数
    NSUInteger days = [components day];
    //计算开始星期几
    NSDateComponents *beginComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date1];
    NSUInteger beginWeekDay = [beginComponets weekday];
    
    //计算结束星期几
    NSDateComponents *endComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date2];
    NSUInteger endWeekDay = [endComponets weekday];
    
    //计算多少个星期
    NSUInteger allWeek = days/7;
    
    //每周算2天周末，计算一共多少个周末
    NSUInteger weekend = allWeek * 2;
    
    //处理临界点，比如起始日是周日
    if(beginWeekDay == 1){
        weekend -= 1;
    }
    if(endWeekDay == 1){
        weekend += 1;
    }else if(endWeekDay > 6){
        weekend += 2;
    }
    
    //weekend 的值就是周末的天数
    //weekday 的值就是工作日的天数
    NSUInteger weekday =days - weekend;
    DLog(@"总天数:%lu     工作日:%lu",(unsigned long)days,(unsigned long)weekday);
    success([NSString stringWithFormat:@"%ld天",days],[NSString stringWithFormat:@"%ld天",weekday]);
}
- (void)calculateYearsWithMonthsFromDate:(NSDate *)date1 toDate:(NSDate *)date2 withYear:(BOOL)isYear Success:(void(^)(NSString *dateString))success
{
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = (isYear == YES)?(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay):(NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSUInteger years = [components year];
    NSUInteger months = [components month];
    NSUInteger days = [components day];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    if (isYear == YES) {
       
        if (years > 0) {
            
            [str appendFormat:@"%ld年",years];
        }
    }
    if (months > 0) {
        
        [str appendFormat:@"%ld月",months];
    }
    if (days > 0) {
     
        [str appendFormat:@"%ld天",days];
    }

    success(str);
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    DayViewCell *cell = (DayViewCell *)[tableView dequeueReusableCellWithIdentifier:DAYCellID];
    [cell settingDayCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    cell.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0 || row == 1) {
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            UIWindow *windows = [QZManager getWindow];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                (row == 0)?(weakSelf.startTime = timeStr):(weakSelf.endTime = timeStr);
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return nil;
    }
    UIView *secitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 80)];
    secitionView.backgroundColor = hexColor(F2F2F2);
    [secitionView addSubview:self.calculateButton];
    [secitionView addSubview:self.resetButton];
    return secitionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 0)?80.f:0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self dismissKeyBoard];
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    CaseTextField *textField = (CaseTextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    NSInteger row = textField.row;
    NSInteger section = textField.section;
    
    NSMutableArray *arr = _dataSourceArrays[section];
    [arr replaceObjectAtIndex:row withObject:textField.text];
}
#pragma mark - setters and getters
- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (UIButton *)calculateButton
{
    if (!_calculateButton) {
        _calculateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _calculateButton.frame = CGRectMake(15 , 20, (kMainScreenWidth - 45)/2.f, 40);
        _calculateButton.layer.masksToBounds = YES;
        _calculateButton.layer.cornerRadius = 3.f;
        _calculateButton.backgroundColor  = hexColor(00c8aa);
        [_calculateButton setTitleColor:[UIColor whiteColor] forState:0];
        [_calculateButton setTitle:@"计算" forState:0];
        _calculateButton.titleLabel.font = Font_15;
        _calculateButton.tag = 3044;
        [_calculateButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calculateButton;
}
- (UIButton *)resetButton
{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.frame = CGRectMake(30 + (kMainScreenWidth - 45)/2.f , 20, (kMainScreenWidth - 45)/2.f, 40);
        _resetButton.layer.masksToBounds = YES;
        _resetButton.layer.cornerRadius = 3.f;
        _resetButton.backgroundColor  = hexColor(C2C2C2);
        [_resetButton setTitleColor:[UIColor whiteColor] forState:0];
        [_resetButton setTitle:@"重置" forState:0];
        _resetButton.titleLabel.font = Font_15;
        _resetButton.tag = 3045;
        [_resetButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
