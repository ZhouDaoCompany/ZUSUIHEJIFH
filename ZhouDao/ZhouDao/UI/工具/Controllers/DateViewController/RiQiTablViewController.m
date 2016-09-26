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

static NSString *const RIQICellID = @"RIQICellID";

@interface RiQiTablViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,RiQiViewCellDelegate>

{
    BOOL _flags[2];
}
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (strong, nonatomic) NSMutableArray *timeArrays;
@property (strong, nonatomic) NSMutableDictionary *timeDictionary;

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
    
    NSString *pathSource = [[NSBundle mainBundle] pathForResource:@"Holiday" ofType:@"plist"];
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
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    
    if (btn.tag == 3063) {
        
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

        if (_flags[1] == YES) {
            //不按照工作日推算
            [self doNotCalculateAccordingToTheWorkingDaysWithArr:arr1];
        }else {
            //按照工作日推算
            
        }
    }
    
    DLog(@"计算或者重置");
}
#pragma mark - 不按工作日推算
- (void)doNotCalculateAccordingToTheWorkingDaysWithArr:(NSMutableArray *)arrays
{
    NSUInteger indexInter;
    if (_flags[0] == NO) {
        
        indexInter = [[NSString stringWithFormat:@"%@",arrays[2]] integerValue];
    }else {
        indexInter = [[NSString stringWithFormat:@"-%@",arrays[2]] integerValue];
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
    [dateComponent setDay:0];
    [dateComponent setHour:days];
    [dateComponent setMinute:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    NSString *sjcString = [QZManager dateChangeTimeStampMethods:newdate];
    DLog(@"%@",sjcString);
    
    
    //算出是否是周末
    //计算开始星期几
    NSDateComponents *endComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:newdate];
    NSUInteger endWeekDay = [endComponets weekday];

    NSString *suffix = @"";
    if ([self.timeArrays containsObject:sjcString]) {
        //包含的话就是节假日
        NSString *contrastString = [NSString stringWithFormat:@"%@",_timeDictionary[sjcString]];
        if ([contrastString isEqualToString:@"0"]) {
            suffix = @"工作日";
        }else {
            suffix = @"放假";
        }
        
    }else {
        
        if (endWeekDay == 1 && endWeekDay == 7) {
            suffix = @"休息日";
        }else{
            suffix = @"工作日";
        }
    }
    
    NSString *str1 = [QZManager changeTimestampToCommonTime:[sjcString doubleValue] format:@"yyyy年MM月dd日"];
    NSArray *weekArrays = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    NSString *str2 = [NSString stringWithFormat:@"%@",weekArrays[endWeekDay -1]];
    
    NSString *lastString = [NSString stringWithFormat:@"%@（%@，%@）",str1,str2,suffix];
    return lastString;
}

#pragma mark - RiQiViewCellDelegate
- (void)optionRiQiEventWithCell:(RiQiViewCell *)cell withSelecIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSMutableArray *arr1 = _dataSourceArrays[0];

    _flags[row] = (index == 0)?NO:YES;
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
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
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
