//
//  RiQiTablViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RiQiTablViewController.h"
#import "RiQiViewCell.h"
#import "ZHPickView.h"
#import "TaskModel.h"
#import "ReadViewController.h"

static NSString *const RIQICellID = @"RIQICellID";

@interface RiQiTablViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,RiQiViewCellDelegate,CalculateShareDelegate>

{
    BOOL _flags[2];
}
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (strong, nonatomic) NSMutableArray *timeArrays;
@property (strong, nonatomic) NSMutableDictionary *timeDictionary;

@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation RiQiTablViewController

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
    
    NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"holiday.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:pathSource];
    self.timeArrays = dict[@"time"];
    self.timeDictionary = dict[@"allHoliday"];

    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"0",@"0", nil];
//    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",nil];
    [self.dataSourceArrays addObject:arr1];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[RiQiViewCell class] forCellReuseIdentifier:RIQICellID];
    WEAKSELF;
    [self.tableView whenCancelTapped:^{
        
        [weakSelf dismissKeyBoard];
    }];
    
    [GcNoticeUtil handleNotification:@"RiQiTablViewController"
                            Selector:@selector(clickShareEvent)
                            Observer:self];

}
- (void)clickShareEvent
{
    DLog(@"分享日期计算");
    
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
    
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index
{WEAKSELF;
    if (index >0) {
        if (_dataSourceArrays.count == 1) {
            
            [JKPromptView showWithImageName:nil message:LOCCALCULATESHARE];
            return;
        }
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-riqijisuan",@"type", nil];
        NSMutableArray *arr1 = _dataSourceArrays[0];
        NSString *str3 = @"";
        if (_flags[0] == NO) {
            str3 = @"向后推算";
        }else {
           str3 = @"向前推算";
        }
        NSString *str4 = @"";
        if (_flags[1] == NO) {
            str3 = @"否";
        }else {
            str3 = @"是";
        }


        NSMutableArray *conditionsArr = [NSMutableArray arrayWithObjects:arr1[0],arr1[1],str3,str4, nil];
        NSMutableArray *resultsArr = [_dataSourceArrays[1] mutableCopy];
        [resultsArr removeObjectAtIndex:0];
        [shareDict setObject:conditionsArr forKey:@"conditions"];
        [shareDict setObject:resultsArr forKey:@"results"];
        
        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            
            if (index == 1) {
                
                NSArray *arrays = [NSArray arrayWithObjects:@"日期计算",@"日期计算结果",urlString,@"", nil];
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];

            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"日期计算结果Word%@.docx",idString];
                model.url= wordString;
                model.content = @"律师费计算结果Word";
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
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,DATESCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"日期计算",@"日期计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
}

#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    
    if (btn.tag == 3064) {
        
        [self.tableView setTableFooterView:nil];

        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"0",@"0", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView  endUpdates];
        
    }else{
        NSMutableArray *arr1 = _dataSourceArrays[0];
        for (NSUInteger i = 0; i<arr1.count; i++) {
            
            NSString *dateString = arr1[i];
            if (dateString.length == 0 && i== 0) {
                [JKPromptView showWithImageName:nil message:@"请您选择日期"];
                return;
            }
            if (dateString.length == 0 && i== 1) {
                [JKPromptView showWithImageName:nil message:@"请您输入间隔天数"];
                return;
            }
        }
        
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
        }
        
        _startTime = [NSString stringWithFormat:@"%ld",[_startTime integerValue]];
        
        if (_flags[1] == NO) {
            //不按照工作日推算
            [self doNotCalculateAccordingToTheWorkingDaysWithArr:arr1];
        }else {
            //按照工作日推算
            [self CalculateAccordingToTheWorkingDaysWithArr:arr1];
        }
        
        [self.tableView setTableFooterView:self.bottomLabel];

    }
    
    DLog(@"计算或者重置");
}
#pragma mark - 按照工作日推算
- (void)CalculateAccordingToTheWorkingDaysWithArr:(NSMutableArray *)arrays
{
    NSUInteger index = [arrays[1] integerValue];
    NSString *tempTimeString = _startTime;
//    NSUInteger limitIndex = index;
    
    while (index > 0) {
        
        NSUInteger indexInter;
        if (_flags[0] == NO) {
            
            indexInter = [[NSString stringWithFormat:@"%ld",(unsigned long)index] integerValue];
        }else {
            indexInter = [[NSString stringWithFormat:@"-%ld",index] integerValue];
        }

        //得到终点时间
        NSString *endTimeString = [self getManyDaysLaterTheTimeStamp:tempTimeString withDays:indexInter];
        NSUInteger weekDays = 0;
        
        if (_flags[0] == NO) {
            //向后推算
            weekDays = [self getPreciseWorkDaysWithDateTime1:tempTimeString withDateTime2:endTimeString];
        }else {
            //向前推算
            weekDays = [self getPreciseWorkDaysWithDateTime1:endTimeString withDateTime2:tempTimeString];
        }
        
        tempTimeString = endTimeString;
        
        if (index < weekDays) {
            index = 0;
        }else{
            index = index - weekDays;
        }
        DLog(@"-----%ld",index);
    }
    
    tempTimeString = [NSString stringWithFormat:@"%ld",[tempTimeString integerValue] + 172800];
    //得到终点时间
    NSString *twoSectionString = [self getTheFinalResultWithTimeString:tempTimeString];
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",twoSectionString,nil];
    [_dataSourceArrays addObject:arr2];
    [self.tableView reloadData];

}

- (NSString *)getManyDaysLaterTheTimeStamp:(NSString *)timeStamp withDays:(NSUInteger)days
{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDate *tempDate = [QZManager timeStampChangeNSDate:[timeStamp doubleValue]];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:0];
    [dateComponent setDay:days];
    [dateComponent setHour:-16];
    [dateComponent setMinute:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    NSString *sjcString = [QZManager dateChangeTimeStampMethods:newdate];
    DLog(@"%@",sjcString);
    return sjcString;
}

#pragma mark - 不按工作日推算
- (void)doNotCalculateAccordingToTheWorkingDaysWithArr:(NSMutableArray *)arrays
{
    NSUInteger indexInter;
    if (_flags[0] == NO) {
        
        indexInter = [[NSString stringWithFormat:@"%@",arrays[1]] integerValue];
    }else {
        indexInter = [[NSString stringWithFormat:@"-%@",arrays[1]] integerValue];
    }
    
    NSString *twoSectionString = [self getHowManyDaysLaterTheTimeStamp:_startTime withDays:indexInter];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",twoSectionString,nil];
    [_dataSourceArrays addObject:arr2];
    [self.tableView reloadData];
    
}
- (NSString *)getHowManyDaysLaterTheTimeStamp:(NSString *)timeStamp withDays:(NSUInteger)days
{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDate *tempDate = [QZManager timeStampChangeNSDate:[timeStamp doubleValue]];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:0];
    [dateComponent setDay:days];
    [dateComponent setHour:-16];
    [dateComponent setMinute:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    NSString *sjcString = [QZManager dateChangeTimeStampMethods:newdate];
    DLog(@"%@",sjcString);
    
    
    //算出是否是周末
    //计算开始星期几
    NSString *lastString = [self getTheFinalResultWithTimeString:sjcString];
    return lastString;
}
#pragma mark - 得到最后结果描述
- (NSString *)getTheFinalResultWithTimeString:(NSString *)timeString
{
    NSDate *newdate = [QZManager timeStampChangeNSDate:[timeString floatValue]];
    //算出是否是周末
    //计算开始星期几
    NSDateComponents *endComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:newdate];
    NSUInteger endWeekDay = [endComponets weekday];
    
    NSString *suffix = @"";
    if ([self.timeArrays containsObject:timeString]) {
        //包含的话就是节假日
        NSString *contrastString = [NSString stringWithFormat:@"%@",_timeDictionary[timeString]];
        if ([contrastString isEqualToString:@"0"]) {
            suffix = @"工作日";
        }else {
            suffix = @"节假日";
        }
        
    }else {
        
        if (endWeekDay == 1 || endWeekDay == 7) {
            suffix = @"休息日";
        }else{
            suffix = @"工作日";
        }
    }
    
    NSString *str1 = [QZManager changeTimestampToCommonTime:[timeString doubleValue] format:@"yyyy年MM月dd日"];
    NSArray *weekArrays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *str2 = [NSString stringWithFormat:@"%@",weekArrays[endWeekDay -1]];
    
    NSString *lastString = [NSString stringWithFormat:@"%@（%@，%@）",str1,str2,suffix];
    return lastString;
}
#pragma mark - 得到精确工作日时间
- (NSUInteger)getPreciseWorkDaysWithDateTime1:(NSString *)startTime withDateTime2:(NSString *)endTime
{
    NSDate *date1 = [QZManager timeStampChangeNSDate:[startTime floatValue]];
    NSDate *date2 = [QZManager timeStampChangeNSDate:[endTime floatValue]];

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
    
    //跑文件
    float startTimeInt = [startTime floatValue];
    float endTimeInt = [endTime floatValue];
    
    if ([_startTime integerValue] > [[_timeArrays lastObject] integerValue]) {
        
    }else if ([endTime integerValue] < [[_timeArrays firstObject] integerValue]){
        
    }else {
        
        __block NSUInteger startIndex = [self.timeArrays count];
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
                
                weekday -= 1;
            }else if ([contrastString isEqualToString:@"0"]){
                
                weekday += 1;
            }
        }
    }

    return weekday;
}

#pragma mark - RiQiViewCellDelegate
- (void)optionRiQiEventWithCell:(RiQiViewCell *)cell withSelecIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSMutableArray *arr1 = _dataSourceArrays[0];

    _flags[row-2] = (index == 0)?NO:YES;
    [arr1 replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%ld",index]];
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
    RiQiViewCell *cell = (RiQiViewCell *)[tableView dequeueReusableCellWithIdentifier:RIQICellID];
    [cell settingRiQiCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    cell.textField.delegate = self;
    cell.delegate = self;
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
        if (row == 0) {
            
            ZHPickView *pickView = [[ZHPickView alloc] initWithSelectString:_startTime];
            [pickView setDateViewWithTitle:@"选择时间"];
            UIWindow *windows = [QZManager getWindow];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                weakSelf.startTime = timeStr;
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
        _calculateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _calculateButton.frame = CGRectMake(15 , 20, (kMainScreenWidth - 45)/2.f, 40);
        _calculateButton.layer.masksToBounds = YES;
        _calculateButton.layer.cornerRadius = 3.f;
        _calculateButton.backgroundColor  = hexColor(00c8aa);
        [_calculateButton setTitleColor:[UIColor whiteColor] forState:0];
        [_calculateButton setTitle:@"计算" forState:0];
        _calculateButton.titleLabel.font = Font_15;
        _calculateButton.tag = 3063;
        [_calculateButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calculateButton;
}
- (UIButton *)resetButton
{
    if (!_resetButton) {
        _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _resetButton.frame = CGRectMake(30 + (kMainScreenWidth - 45)/2.f , 20, (kMainScreenWidth - 45)/2.f, 40);
        _resetButton.layer.masksToBounds = YES;
        _resetButton.layer.cornerRadius = 3.f;
        _resetButton.backgroundColor  = hexColor(C2C2C2);
        [_resetButton setTitleColor:[UIColor whiteColor] forState:0];
        [_resetButton setTitle:@"重置" forState:0];
        _resetButton.titleLabel.font = Font_15;
        _resetButton.tag = 3064;
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
        _bottomLabel.textColor = hexColor(999999);
        _bottomLabel.text = @"申明：本平台提供的数据从2010开始至今，若给您的使用带来不便，\n 敬请谅解。";
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
