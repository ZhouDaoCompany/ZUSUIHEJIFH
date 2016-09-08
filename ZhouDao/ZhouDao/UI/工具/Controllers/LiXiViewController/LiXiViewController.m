//
//  LiXiViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LiXiViewController.h"
#import "LiXiViewCell.h"
#import "ZHPickView.h"

static NSString *const LIXICELL = @"lixicellid";

@interface LiXiViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳
@property (copy, nonatomic) NSString *reatString;//使用的哪个利率
@property (copy, nonatomic) NSString *customrateString;//自定义利率或者 银行折扣
@property (strong, nonatomic) NSMutableDictionary *rateDictionary;
@property (strong, nonatomic) NSMutableArray *timeArrays;
@property (assign, nonatomic) BOOL isConvention;//是否约定利率
@end

@implementation LiXiViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];
    
    [self setupNaviBarWithTitle:@"利息计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    if (btn.tag == 3035) {
        
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
    }else {
        //计算
        //等额本息
        NSMutableArray *arr1 = self.dataSourceArrays[0];
        
        NSArray *arrays = [NSArray arrayWithObjects:@"请输入本金总额",@"请选择贷款起算日期",@"请选择贷款截止日期",@"请选择还款方式",@"请选择利率方式",@"请选择利率选项",@"请您填写利率", nil];

        NSUInteger counts = (_isConvention == YES)?arr1.count:(arr1.count -1);
        for (NSUInteger i = 0; i<counts ; i++) {
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

        [self reimbursementTypeMethods:arr1];
    }
}
#pragma mark - 四种还款方式比较
- (void)reimbursementTypeMethods:(NSMutableArray *)arr1
{
    NSString *reimbursementType = arr1[3];
    NSString *rateType = arr1[4];
    if ([reimbursementType isEqualToString:@"等额本息"]) {
        
        [self accordingToTheInterestRateCalculationWithRateType:rateType withArrays:arr1];
    }else if ([reimbursementType isEqualToString:@"一次性还本付息"]) {
        
        [self accordingToTheInterestRateCalculationWithRateType:rateType withArrays:arr1];
    }else if ([reimbursementType isEqualToString:@"月付息到期一次性还本"]) {
        
        [self accordingToTheInterestRateCalculationWithRateType:rateType withArrays:arr1];
    }else if ([reimbursementType isEqualToString:@"等额本息"]) {
        
        if ([rateType isEqualToString:@"人民银行同期利率"]) {
            
        }else{
            
            
        }
    }

}
- (void)accordingToTheInterestRateCalculationWithRateType:(NSString *)rateType withArrays:(NSMutableArray *)arr1
{
    if ([rateType isEqualToString:@"人民银行同期利率"]) {
        
        [self cycleCalendarYearInterestRates:arr1];
    }else{
        
        [self customRateWithArrays:arr1];
    }
}
#pragma mark - 银行同期利率计算得出 本金利息总额
- (void)cycleCalendarYearInterestRates:(NSMutableArray *)arrays
{
    float lastMoney = 0.0f;
    float money = [arrays[0] floatValue];
    float days = ([_endTime integerValue] - [_startTime integerValue])/86400.f;//总的相差天数
    float startTimeInt = [_startTime floatValue];
    float endTimeInt = [_endTime floatValue];
    NSString *discountString = [arrays lastObject];
    float discount = (discountString.length == 0)?1.f:([discountString floatValue]/100.f);
    
    if (startTimeInt > [QZManager timeToTimeStamp:[self.timeArrays lastObject]]) {
        
        NSArray *rateArrays = self.rateDictionary[[self.timeArrays lastObject]];
        lastMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:days withMoney:money];

    }else if (endTimeInt < [QZManager timeToTimeStamp:[self.timeArrays firstObject]]){
       
        NSArray *rateArrays = self.rateDictionary[[self.timeArrays firstObject]];
        lastMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:days withMoney:money];

    }else {
        
        __block NSUInteger startIndex = 0;
        [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSUInteger timeObj = [QZManager timeToTimeStamp:obj];
            if (startTimeInt - timeObj <=0) {
                startIndex = (idx == 0)?idx:(idx-1);
                *stop = YES;
            }
        }];
        NSArray *rateArrays = self.rateDictionary[self.timeArrays[startIndex]];
        lastMoney = [self accordingOfDaysLookingForRatesWithRateArrays:rateArrays withDays:days withMoney:money];
    }
    
    lastMoney = lastMoney*discount;
    float allMoney = lastMoney + money;
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f",allMoney],[NSString stringWithFormat:@"%.2f",lastMoney],[NSString stringWithFormat:@"%.2f",money], nil];
    (_dataSourceArrays.count == 2)?[_dataSourceArrays replaceObjectAtIndex:1 withObject:arr2]:[_dataSourceArrays addObject:arr2];
    [self reloadTableViewWithAnimation];
}
#pragma mark - 按约定利率 自定义利率
- (void)customRateWithArrays:(NSMutableArray *)arrays
{
    float lastMoney = 0.0f;
    float money = [arrays[0] floatValue];
    NSString *discountString = [arrays lastObject];
    float rate = [discountString floatValue]/100.f;
    float days = ([_endTime integerValue] - [_startTime integerValue])/86400.f;
    NSString *typeString = arrays[5];

    if ([typeString isEqualToString:@"日利率"]) {
        lastMoney = money*rate*days*1;
    }else if ([typeString isEqualToString:@"月利率"]){
        lastMoney = money*rate*days*12/360;
    }else{
        lastMoney = money*rate*days/360;
    }
    float allMoney = lastMoney + money;
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f",allMoney],[NSString stringWithFormat:@"%.2f",lastMoney],[NSString stringWithFormat:@"%.2f",money], nil];
    (_dataSourceArrays.count == 2)?[_dataSourceArrays replaceObjectAtIndex:1 withObject:arr2]:[_dataSourceArrays addObject:arr2];
    [self reloadTableViewWithAnimation];

}
#pragma mark - 等额本金 按约定利率 自定义利率
- (void)standardOfCustomReatWithArrays:(NSMutableArray *)arrays
{

    __block NSUInteger startIndex = 0;
    double startTimeInt = [_startTime doubleValue];
    
    NSString *nextMonth = [QZManager getNextMonthTheTimeStamp:_startTime];
    if ([_endTime doubleValue] > [nextMonth doubleValue]) {
        
        NSString *next = [QZManager getNextMonthTheTimeStamp:nextMonth];
        
    }
    
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
- (void)reloadTableViewWithAnimation
{WEAKSELF;
    
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView reloadData];
    }];
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
    LiXiViewCell *cell = (LiXiViewCell *)[tableView dequeueReusableCellWithIdentifier:LIXICELL];
    cell.textField.delegate = self;
    [cell settingLiXiCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
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
                [pickView setDataViewWithItem:@[@"等额本息",@"等额本金",@"一次性还本付息",@"月付息到期一次性还本"] title:@"还款方式"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                };
            }
                break;

            case 4:
            {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:@[@"人民银行同期利率",@"按约定利率"] title:@"利率方式"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    if ([selectedStr isEqualToString:@"人民银行同期利率"]) {
                        
                        weakSelf.isConvention = NO;
                        if (arr1.count == 7) {
                            [arr1 removeObjectAtIndex:6];
                            [arr1 removeObjectAtIndex:arr1.count -1];
                            [arr1 addObject:@""];
                        }
                    }else {
                        
                        weakSelf.isConvention = YES;
                        if (arr1.count == 6) {
                            [arr1 removeObjectAtIndex:5];
                            [arr1 addObject:@""];
                            [arr1 addObject:@""];
                        }
                    }
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                };
            }
                break;
            case 5:
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                
                if ([arr1[4] isEqualToString:@"按约定利率"]) {
                    
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
-(UITableView *)tableView{WEAKSELF;
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[LiXiViewCell class] forCellReuseIdentifier:LIXICELL];
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
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
        _calculateButton.tag = 3036;
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
        _resetButton.tag = 3035;
        [_resetButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
- (NSMutableArray *)timeArrays
{
    if (!_timeArrays) {
        _timeArrays = TIMEARRAYS;
    }
    return _timeArrays;
}
- (NSMutableDictionary *)rateDictionary
{
    if (!_rateDictionary) {
        _rateDictionary = RATEDICTIONARY;
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
