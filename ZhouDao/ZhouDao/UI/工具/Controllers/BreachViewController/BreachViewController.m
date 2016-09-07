//
//  BreachViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BreachViewController.h"
#import "BreachViewCell.h"
#import "BreachDetailVC.h"
#import "ZHPickView.h"

static NSString *const BREACHCELLID = @"breachcellid";
@interface BreachViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) NSMutableDictionary *rateDictionary;
@property (strong, nonatomic) NSMutableDictionary *detailDictionary;//详情字典
@property (strong, nonatomic) NSMutableArray *detailArrays;//详情字典

@property (strong, nonatomic) NSMutableArray *timeArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳
@property (copy, nonatomic) NSString *reatString;//使用的哪个利率
@property (copy, nonatomic) UIView *bottomView;
@end

@implementation BreachViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];
    [self setupNaviBarWithTitle:@"违约金计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    if (btn.tag == 3034) {
        
        _tableView.tableFooterView = nil;
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
    }else {
        //计算

        NSMutableArray *arr1 = _dataSourceArrays[0];
        
        NSArray *arrays = [NSArray arrayWithObjects:@"请输入标的金额",@"请选择起算日期",@"请选择截止日期",@"请选择利率方式",@"请选择利率选项",@"请输入利率", nil];
        for (NSUInteger i = 0; i<arr1.count ; i++) {
            NSString *str = arr1[i];
            if (str.length == 0) {
                [JKPromptView showWithImageName:nil message:arrays[i]];
                return;
            }
        }
        
        if ([QZManager compareOneDay:[NSDate dateWithTimeIntervalSince1970:[_startTime integerValue]] withAnotherDay:[NSDate dateWithTimeIntervalSince1970:[_endTime integerValue]]] == 1 || [_startTime isEqualToString:_endTime])
        {
            [JKPromptView showWithImageName:nil message:@"请您检查设置时间"];
            return;
        }
        
        //是否循环
        if (arr1.count == 6) {
            [self customRateWithArrays:arr1];
        }else {
            //循环历年利率
            [self cycleCalendarYearInterestRates:arr1];
        }
        _tableView.tableFooterView = self.bottomView;
    }
}
#pragma mark - 循环历年利率
- (void)cycleCalendarYearInterestRates:(NSMutableArray *)arrays
{
    [self.detailArrays removeAllObjects];
    float lastMoney = 0.0f;
    float money = [arrays[0] floatValue];
    float days = ([_endTime integerValue] - [_startTime integerValue])/86400.f;//总的相差天数

    float startTimeInt = [_startTime floatValue];
    float endTimeInt = [_endTime floatValue];

    if (startTimeInt > [QZManager timeToTimeStamp:[self.timeArrays lastObject]]) {
        
        NSArray *rateArrays = self.rateDictionary[[self.timeArrays lastObject]];
        lastMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:days withMoney:money];
        NSArray *array1 = [NSArray arrayWithObjects:_startTime,_endTime,_reatString,[NSString stringWithFormat:@"%.2f",lastMoney], nil];
        [self.detailArrays addObject:array1];
    }else if (endTimeInt < [QZManager timeToTimeStamp:[self.timeArrays firstObject]]){
        
        NSArray *rateArrays = self.rateDictionary[[self.timeArrays firstObject]];
        lastMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:days withMoney:money];
        NSArray *array1 = [NSArray arrayWithObjects:_startTime,_endTime,_reatString,[NSString stringWithFormat:@"%.2f",lastMoney], nil];
        [self.detailArrays addObject:array1];
    }else {
        
        __block NSUInteger startIndex = 0;
        __block NSUInteger endIndex = self.timeArrays.count -1;
        [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            NSUInteger timeObj = [QZManager timeToTimeStamp:obj];
            if (startTimeInt - timeObj <=0) {
                startIndex = (idx == 0)?idx:(idx-1);
                *stop = YES;
            }
        }];
        [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSUInteger timeObj = [QZManager timeToTimeStamp:obj];
            if (endTimeInt - timeObj <=0) {
                endIndex = idx;
                *stop = YES;
            }
        }];
        
        DLog(@"ks----%ld    js----%ld",(unsigned long)startIndex,(unsigned long)endIndex);
        
        for (NSUInteger i = startIndex; i < endIndex; i++)
        {
            NSMutableArray *tempArrays = [NSMutableArray array];
            static float onATimeInt = 0.0f;
            if (i == startIndex) {
                onATimeInt = startTimeInt;
            }
            float dateTimeInt = (i == endIndex -1)?[QZManager timeToTimeStamp:self.timeArrays[i]]:[QZManager timeToTimeStamp:self.timeArrays[i + 1]];//数组里的时间
            NSArray *rateArrays = self.rateDictionary[self.timeArrays[i]];
            float differTimeDay = (i == endIndex -1)?((endTimeInt - dateTimeInt)/86400.f):((dateTimeInt - onATimeInt)/86400.f);//相差天数
            float calculateMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:differTimeDay withMoney:money];
            lastMoney += calculateMoney;

            [tempArrays addObject:[NSString stringWithFormat:@"%.0f",onATimeInt]];//开始时间
            (i == endIndex -1)?[tempArrays addObject:[NSString stringWithFormat:@"%.0f",endTimeInt]]:[tempArrays addObject:[NSString stringWithFormat:@"%.0f",dateTimeInt]];//结束时间
            [tempArrays addObject:GET(_reatString)];
            [tempArrays addObject:[NSString stringWithFormat:@"%.2f",calculateMoney]];
            [self.detailArrays addObject:tempArrays];
            onATimeInt = dateTimeInt;
            DLog(@"相差天数－－%.0f------利率:  %@",differTimeDay,_reatString);
        }
    }
    
    NSString *allDays = [NSString stringWithFormat:@"%@-%@",[QZManager changeTimeMethods:[_startTime integerValue] withType:@"yy/MM/dd"],[QZManager changeTimeMethods:[_endTime integerValue] withType:@"yy/MM/dd"]];
    [self collectInformationToAnotherInterfaceWithMoney:money WithBreachMoney:lastMoney WithAllDays:allDays WithArrays:self.detailArrays WithReatType:@"同期利率"];
    //添加刷新
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f",lastMoney],[NSString stringWithFormat:@"%.0f",days], nil];
    (_dataSourceArrays.count == 2)?[_dataSourceArrays replaceObjectAtIndex:1 withObject:arr2]:[_dataSourceArrays addObject:arr2];
    [self reloadTableViewWithAnimation];
    
}
#pragma mark - 收集信息到另一界面
- (void)collectInformationToAnotherInterfaceWithMoney:(float)money WithBreachMoney:(float)lastMoney WithAllDays:(NSString *)allDays WithArrays:(NSMutableArray *)arrays WithReatType:(NSString *)reatTypes
{
    [self.detailDictionary setObjectWithNullValidate:[NSString stringWithFormat:@"%.2f",money] forKey:@"AllMoney"];
    [self.detailDictionary setObjectWithNullValidate:[NSString stringWithFormat:@"%.2f",lastMoney] forKey:@"BreachMoney"];
    [self.detailDictionary setObjectWithNullValidate:allDays forKey:@"AllDays"];
    [self.detailDictionary setObjectWithNullValidate:arrays forKey:@"MutableArrays"];
    [self.detailDictionary setObjectWithNullValidate:reatTypes forKey:@"ReatType"];

}
#pragma mark - 根据天数找到取第几个利率
- (float)accordingOfDaysLookingForRatesWithRateArrays:(NSArray *)rateArrays withDays:(float)differTimeDay withMoney:(float)money
{
    float lastMoney = 0.0f;
    if(differTimeDay <= 180){
        
        lastMoney = money*differTimeDay*([rateArrays[0] floatValue]/360);
        _reatString = rateArrays[0];
    }else if(differTimeDay > 180 && differTimeDay <= 365){
        
        lastMoney = money*differTimeDay*([rateArrays[1] floatValue]/360);
        _reatString = rateArrays[1];
    }else if(differTimeDay > 365 && differTimeDay <= 1095){
        
        lastMoney = money*differTimeDay*([rateArrays[2] floatValue]/360);
        _reatString = rateArrays[2];
    }else if(differTimeDay > 1095 && differTimeDay <= 1825){
        
        lastMoney = money*differTimeDay*([rateArrays[3] floatValue]/360);
        _reatString = rateArrays[3];
    }else if(differTimeDay > 1825){
        
        lastMoney = money*differTimeDay*([rateArrays[4] floatValue]/360);
        _reatString = rateArrays[4];
    }
    return lastMoney;
}
#pragma mark - 自定义利率
- (void)customRateWithArrays:(NSMutableArray *)arrays
{
    float lastMoney = 0.0f;
    float money = [arrays[0] floatValue];
    NSString *typeString = arrays[4];

    float rate = [arrays[5] floatValue]/100.f;
    float days = ([_endTime integerValue] - [_startTime integerValue])/86400.f;
    if ([typeString isEqualToString:@"日利率"]) {
        lastMoney = money*rate*days*1;
    }else if ([typeString isEqualToString:@"月利率"]){
        lastMoney = money*rate*days*12/360;
    }else{
        lastMoney = money*rate*days/360;
    }
    NSString *lastMoneyString = [NSString stringWithFormat:@"%.2f",lastMoney];
    NSString *lastDaysString = [NSString stringWithFormat:@"%.0f",days];

    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString,lastDaysString, nil];
    (_dataSourceArrays.count == 2)?[_dataSourceArrays replaceObjectAtIndex:1 withObject:arr2]:[_dataSourceArrays addObject:arr2];
    
    
    NSString *allDays = [NSString stringWithFormat:@"%@-%@",[QZManager changeTimeMethods:[_startTime integerValue] withType:@"yy/MM/dd"],[QZManager changeTimeMethods:[_endTime integerValue] withType:@"yy/MM/dd"]];
    NSArray *array1 = [NSArray arrayWithObjects:_startTime,_endTime,arrays[5],lastMoneyString, nil];
    NSMutableArray *lastArrays = [NSMutableArray arrayWithObjects:array1, nil];
    
    [self collectInformationToAnotherInterfaceWithMoney:money WithBreachMoney:lastMoney WithAllDays:allDays WithArrays:lastArrays WithReatType:@"约定利率"];

    [self reloadTableViewWithAnimation];
}
- (void)reloadTableViewWithAnimation
{WEAKSELF;
    
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView reloadData];
    }];
}

- (void)rightBtnAction
{
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BreachViewCell *cell = (BreachViewCell *)[tableView dequeueReusableCellWithIdentifier:BREACHCELLID];
    cell.textField.delegate = self;
    [cell settingBreachCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        switch (row) {
            case 1:
            {
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
                break;
            case 2:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDateViewWithTitle:@"选择时间"];
                UIWindow *windows = [QZManager getWindow];
                [pickView showWindowPickView:windows];
                pickView.alertBlock = ^(NSString *selectedStr)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                    weakSelf.endTime = timeStr;
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                };

            }
                break;
            case 3:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:@[@"人民银行同期利率",@"按约定利率"] title:@"利率方式"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    if ([selectedStr isEqualToString:@"人民银行同期利率"]) {
                        if (arr1.count > 4) {
                            [arr1 removeObjectAtIndex:4];
                            [arr1 removeObjectAtIndex:4];
                        }
                    }else {
                        if (arr1.count == 4) {
                            [arr1 addObject:@""];
                            [arr1 addObject:@""];
                        }
                    }
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                };

            }
                break;
            case 4:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:@[@"年利率",@"月利率",@"日利率"] title:@"利率选项"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                };

            }
                break;
   
            default:
                break;
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
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}

#pragma mark - setters and getters
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[BreachViewCell class] forCellReuseIdentifier:BREACHCELLID];
        [_tableView whenCancelTapped:^{
            
            [self dismissKeyBoard];
        }];
    }
    return _tableView;
}
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
        _calculateButton.tag = 3033;
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
        _resetButton.tag = 3034;
        [_resetButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
- (NSMutableArray *)detailArrays
{
    if (!_detailArrays) {
        _detailArrays = [NSMutableArray array];
    }
    return _detailArrays;
}
- (NSMutableDictionary *)detailDictionary
{
    if (!_detailDictionary) {
        _detailDictionary = [NSMutableDictionary dictionary];
    }
    return _detailDictionary;
}
- (UIView *)bottomView
{
    if (!_bottomView) {WEAKSELF;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 75.f)];
        _bottomView.backgroundColor = [UIColor clearColor];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, kMainScreenWidth-10, 25)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = hexColor(00c8aa);
        label2.font = Font_12;
        label2.text = @"按《人民银行利率表》进行计算，结果仅供参考。";
        [_bottomView addSubview:label2];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 35)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.numberOfLines = 0;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = hexColor(00c8aa);
        label1.font = Font_12;
        label1.text = @"查看分段计算详情 >";
        [_bottomView addSubview:label1];

        [label1 whenCancelTapped:^{
            
            BreachDetailVC *vc = [BreachDetailVC new];
            vc.detailDictionary = weakSelf.detailDictionary;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];

    }
    return _bottomView;
}
- (NSMutableArray *)timeArrays
{
    if (!_timeArrays) {
        _timeArrays = [NSMutableArray arrayWithObjects:@"19890201",@"19900821",@"19910321",@"19910421",@"19930515",@"19930711",@"19950101",@"19950701",@"19960501",@"19960823",@"19971023",@"19980325",@"19980701",@"19981207",@"19990610",@"20020221",@"20041029",@"20050317",@"20060428",@"20060819",@"20070318",@"20070519",@"20070721",@"20070822",@"20070915",@"20071221",@"20080916",@"20081009",@"20081027",@"20081030",@"20081127",@"20081223",@"20101020",@"20101226",@"20110209",@"20110406",@"20110707",@"20120608",@"20120706",@"20141122",@"20150301",@"20150511",@"20150628",@"20150826",nil];
    }
    return _timeArrays;
}
- (NSMutableDictionary *)rateDictionary
{
    if (!_rateDictionary) {
        _rateDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[@"0.1134",@"0.1134",@"0.1278",@"0.1440",@"0.1926"],@"19890201",@[@"0.0864",@"0.0936",@"0.1008",@"0.1080",@"0.1116"],@"19900821",@[@"0.0900",@"0.1008",@"0.1080",@"0.1152",@"0.1188"],@"19910321",@[@"0.0810",@"0.0864",@"0.0900",@"0.0954",@"0.0972"],@"19910421",@[@"0.0882",@"0.0936",@"0.1080",@"0.1206",@"0.1224"],@"19930515",@[@"0.0900",@"0.1098",@"0.1224",@"0.1386",@"0.1404"],@"19930711",@[@"0.0900",@"0.1098",@"0.1296",@"0.1458",@"0.1476"],@"19950101",@[@"0.1008",@"0.1206",@"0.1305",@"0.1512",@"0.1530"],@"19950701",@[@"0.0972",@"0.1098",@"0.1314",@"0.1494",@"0.1512"],@"19960501",@[@"0.0918",@"0.1008",@"0.1098",@"0.1170",@"0.1242"],@"19960823",@[@"0.0765",@"0.0864",@"0.0936",@"0.0990",@"0.1053"],@"19971023",@[@"0.0702",@"0.0792",@"0.0900",@"0.0972",@"0.1035"],@"19980325",@[@"0.0657",@"0.0693",@"0.0711",@"0.0765",@"0.0801"],@"19980701",@[@"0.0612",@"0.0639",@"0.0666",@"0.0720",@"0.0756"],@"19981207",@[@"0.0558",@"0.0585",@"0.0594",@"0.0603",@"0.0621"],@"19990610",@[@"0.0504",@"0.0531",@"0.0549",@"0.0558",@"0.0576"],@"20020221",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20041029",@[@"0.0522",@"0.0558",@"0.0576",@"0.0585",@"0.0612"],@"20050317",@[@"0.0540",@"0.0585",@"0.0603",@"0.0612",@"0.0639"],@"20060428",@[@"0.0558",@"0.0612",@"0.0630",@"0.0648",@"0.0684"],@"20060819",@[@"0.0567",@"0.0639",@"0.0657",@"0.0675",@"0.0711"],@"20070318",@[@"0.0585",@"0.0657",@"0.0675",@"0.0693",@"0.0720"],@"20070519",@[@"0.0603",@"0.0684",@"0.0702",@"0.0720",@"0.0738"],@"20070721",@[@"0.0621",@"0.0702",@"0.0720",@"0.0738",@"0.0756"],@"20070822",@[@"0.0648",@"0.0729",@"0.0747",@"0.0765",@"0.0783"],@"20070915",@[@"0.0657",@"0.0747",@"0.0756",@"0.0774",@"0.0783"],@"20071221",@[@"0.0621",@"0.0720",@"0.0729",@"0.0756",@"0.0774"],@"20080916",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081009",@[@"0.0612",@"0.0693",@"0.0702",@"0.0729",@"0.0747"],@"20081027",@[@"0.0603",@"0.0666",@"0.0675",@"0.0702",@"0.0720"],@"20081030",@[@"0.0504",@"0.0558",@"0.0567",@"0.0594",@"0.0612"],@"20081127",@[@"0.0486",@"0.0531",@"0.0540",@"0.0576",@"0.0594"],@"20081223",@[@"0.0510",@"0.0556",@"0.0560",@"0.0596",@"0.0614"],@"20101020",@[@"0.0535",@"0.0581",@"0.0585",@"0.0622",@"0.0640"],@"20101226",@[@"0.0560",@"0.0606",@"0.0610",@"0.0645",@"0.0660"],@"20110209",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20110406",@[@"0.0610",@"0.0656",@"0.0665",@"0.0690",@"0.0705"],@"20110707",@[@"0.0585",@"0.0631",@"0.0640",@"0.0665",@"0.0680"],@"20120608",@[@"0.0560",@"0.0600",@"0.0615",@"0.0640",@"0.0655"],@"20120706",@[@"0.0560",@"0.0560",@"0.0600",@"0.0600",@"0.0615"],@"20141122",@[@"0.0535",@"0.0535",@"0.0575",@"0.0575",@"0.0590"],@"20150301",@[@"0.0510",@"0.0510",@"0.0550",@"0.0550",@"0.0565"],@"20150511",@[@"0.0485",@"0.0485",@"0.0525",@"0.0525",@"0.0540"],@"20150628",@[@"0.0460",@"0.0460",@"0.0500",@"0.0500",@"0.0515"],@"20150826", nil];
    }
    return _rateDictionary;
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
