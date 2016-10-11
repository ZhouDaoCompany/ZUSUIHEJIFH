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
#import "GcNoticeUtil.h"
#import "TaskModel.h"
#import "ReadViewController.h"

static NSString *const DAYCellID = @"dayCellID";

@interface DayTabViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,CalculateShareDelegate>


@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳
@property (strong, nonatomic) NSMutableArray *timeArrays;
@property (strong, nonatomic) NSMutableDictionary *timeDictionary;

@property (strong, nonatomic) UILabel *bottomLabel;

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
    
    NSString *pathSource = [MYBUNDLE pathForResource:@"Holiday" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
    self.timeArrays = dict[@"time"];
    self.timeDictionary = dict[@"allHoliday"];
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[DayViewCell class] forCellReuseIdentifier:DAYCellID];
    WEAKSELF;
    [self.tableView whenCancelTapped:^{
        
        [weakSelf dismissKeyBoard];
    }];
    
    
    [GcNoticeUtil handleNotification:@"DayTabViewController"
                            Selector:@selector(clickShareEvent)
                            Observer:self];

}
- (void)clickShareEvent
{
    DLog(@"分享天数计算");
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];

}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index
{WEAKSELF;
    if (index >0) {
        if (_dataSourceArrays.count == 1) {
            
            [JKPromptView showWithImageName:nil message:@"请您计算后再来分享"];
            return;
        }
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-tianshujisuan",@"type", nil];
        NSMutableArray *conditionsArr = _dataSourceArrays[0];
        NSMutableArray *resultsArr = [_dataSourceArrays[1] mutableCopy];
        [resultsArr removeObjectAtIndex:0];
        [shareDict setObject:conditionsArr forKey:@"conditions"];
        [shareDict setObject:resultsArr forKey:@"results"];

        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            if (index == 1) {
                 NSArray *arrays = [NSArray arrayWithObjects:@"天数计算",@"天数计算结果",urlString,@"", nil];
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];

            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"天数计算结果Word%@.docx",idString];
                model.url= wordString;
                model.content = @"天数计算结果Word";
                model.destinationPath=[kCachePath stringByAppendingPathComponent:model.name];
                
                ReadViewController *readVC = [ReadViewController new];
                readVC.model = model;
                readVC.navTitle = @"计算结果";
                readVC.rType = FileNOExist;
                [weakSelf.navigationController pushViewController:readVC animated:YES];

            }

            
            
        } fail:^{
            
        }];
        
    }else {//分享计算器
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,DAYSCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"天数计算",@"天数计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
}

#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{WEAKSELF;
    [self dismissKeyBoard];
    
    if (btn.tag == 3045) {
        
        [self.tableView setTableFooterView:nil];

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
        if ([_endTime floatValue] <= [_startTime floatValue]) {
            [JKPromptView showWithImageName:nil message:@"请您检查所选时间"];
            return;
        }

        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
        }

        __block NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"", nil];
        __block NSString *workDays = @"0";
        [self calculateTheTotalDaysWithWorkingDaysFromDate:[QZManager timeStampChangeNSDate:[_startTime floatValue]] toDate:[QZManager timeStampChangeNSDate:[_endTime floatValue]] Success:^(NSString *allDays, NSString *workingDays) {
            
            workDays = workingDays;
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
        
        [self.tableView reloadData];

        [self concludedThatMoreAccurateWorkingDays:workDays withSuccess:^(NSString *work) {
            
            NSMutableArray *arrays = weakSelf.dataSourceArrays[1];
            [arrays replaceObjectAtIndex:4 withObject:work];
            [weakSelf.tableView reloadData];
        }];
        
        [self.tableView setTableFooterView:self.bottomLabel];

    }
    DLog(@"计算或者重置");
}
- (void)concludedThatMoreAccurateWorkingDays:(NSString *)workDays withSuccess:(void(^)(NSString *work))success
{
    NSUInteger workDayInter = [workDays integerValue];
    NSString *working = @"";
    float startTimeInt = [_startTime floatValue];
    float endTimeInt = [_endTime floatValue];

    if ([_startTime integerValue] > [[_timeArrays lastObject] integerValue]) {
        
        working = [NSString stringWithFormat:@"%@天",workDays];
    }else if ([_endTime integerValue] < [[_timeArrays firstObject] integerValue]){
        
        working = [NSString stringWithFormat:@"%@天",workDays];
    }else {
        
        __block NSUInteger startIndex = 0;
        __block NSUInteger endIndex = [self.timeArrays count];

        [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (startTimeInt - [obj floatValue] <=0) {
                startIndex = idx;
                *stop = YES;
            }
        }];
        [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (endTimeInt - [obj floatValue] == 0) {
                endIndex = idx + 1;
                *stop = YES;
            }
            if (endTimeInt - [obj floatValue] < 0) {
                endIndex = idx;
                *stop = YES;
            }
        }];

        for (NSUInteger i = startIndex; i < endIndex; i++)
        {
            /*
             2   放假
             0   周六周日 工作日
             3   放假并且是周六周日
             */
            NSString *holiday = _timeArrays[i];
            NSString *contrastString = [NSString stringWithFormat:@"%@",_timeDictionary[holiday]];
            if ([contrastString isEqualToString:@"2"]) {
                
                workDayInter -= 1;
            }else if ([contrastString isEqualToString:@"0"]){
                
                workDayInter += 1;
            }
        }
        working = [NSString stringWithFormat:@"%ld天",workDayInter];
    }
    success(working);
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
    
    //处理临界点，比如起始日是周六
    if (weekend >0) {
        
        if(beginWeekDay == 7){
            weekend -= 1;
        }
        if(endWeekDay == 7){
            weekend += 1;
        }else if(endWeekDay > 6){
            weekend += 2;
        }
    }
    
    //weekend 的值就是周末的天数
    //weekday 的值就是工作日的天数
    NSUInteger weekday =days - weekend;
    DLog(@"总天数:%lu     工作日:%lu",(unsigned long)days,(unsigned long)weekday);
    success([NSString stringWithFormat:@"%ld天",days],[NSString stringWithFormat:@"%ld",weekday]);
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
- (NSMutableDictionary *)timeDictionary
{
    if (!_timeDictionary) {
        _timeDictionary = [NSMutableDictionary dictionary];
    }
    return _timeDictionary;
}
- (NSMutableArray *)timeArrays
{
    if (!_timeArrays) {
        _timeArrays = [NSMutableArray array ];
    }
    return _timeArrays;
}
- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 50)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(00c8aa);
        _bottomLabel.text = @"申明：本平台提供的数据从2010开始至今，若给您的使用带来不便，敬请谅解。";
        _bottomLabel.font = Font_12;
    }
    return _bottomLabel;
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
