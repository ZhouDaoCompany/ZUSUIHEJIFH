//
//  OverdueViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "OverdueViewController.h"
#import "OverdueCell.h"
#import "ZHPickView.h"

static NSString *const OverdueCellID = @"OverdueCellID";

@interface OverdueViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) NSMutableDictionary *rateDictionary;//银行同期利率
@property (strong, nonatomic) NSMutableArray *timeArrays;

@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳

@end

@implementation OverdueViewController
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
//    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"", @"",nil];
    [self.dataSourceArrays addObject:arr1];
//    [self.dataSourceArrays addObject:arr2];

    [self setupNaviBarWithTitle:@"裁决书逾期利息计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - 
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    
    if (btn.tag == 3034) {
        
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        _tableView.tableFooterView = nil;
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];

    }else{
        NSMutableArray *arr1 = _dataSourceArrays[0];
        NSArray *alertArrays = @[@"请输入本金",@"请选择开始日期",@"请选择结束日期",@"请选择利率方式",@"请输入约定利率"];
        
        for (NSUInteger i = 0; i<arr1.count; i++) {
            
            NSString *valueString = arr1[i];
            if (valueString.length == 0) {
                
                [JKPromptView showWithImageName:nil message:alertArrays[i]];
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
        [self conformToTheStartingConditions:arr1];
    }
    DLog(@"计算或者重置");
}
#pragma mark - 符合条件开始计算
- (void)conformToTheStartingConditions:(NSMutableArray *)arrays
{
    double money = [arrays[0] doubleValue];
    double days = ([_endTime integerValue] - [_startTime integerValue])/86400.f;//总的相差天数
    double startTimeInt = [_startTime doubleValue];
    double endTimeInt = [_endTime doubleValue];

    NSString *rateStyle = arrays[3];//利率方式
    double rate = 0.0f;
    if ([rateStyle isEqualToString:@"人民银行同期利率"]) {
        
        
        NSArray *rateArrays = [NSArray array];
        if (startTimeInt > [QZManager timeToTimeStamp:[self.timeArrays lastObject]]){
            
            rateArrays = self.rateDictionary[[self.timeArrays lastObject]];
        }else {
            
            __block NSUInteger startIndex = 0;
            [self.timeArrays enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSUInteger timeObj = [QZManager timeToTimeStamp:obj];
                if (startTimeInt - timeObj <=0) {
                    startIndex = (idx == 0)?idx:(idx-1);
                    *stop = YES;
                }
            }];
            rateArrays = self.rateDictionary[self.timeArrays[startIndex]];
        }

        rate = [CalculateManager getRateCalculateWithRateArrays:rateArrays withDays:days]/360.f;
    }else {
        rate = [[arrays lastObject] doubleValue];
    }
    
    double generalLiXiMoney = days*rate*money;//一般利息
    double limitLiXiMoney = 0.0f;//逾期利息
    if (startTimeInt > 1406822400) {
        
        limitLiXiMoney = money * days *1.75/10000.f;
    }else if (endTimeInt <1406822400){
        
        limitLiXiMoney = money * days *rate *2.f;
    }else{
        
        double days1 = (1406822400 - startTimeInt)/86400.f;
        double days2 = (endTimeInt - 1406822400)/86400.f;

        limitLiXiMoney = money * days1 *rate *2.f + money * days2 *1.75/10000.f;
    }
    
    NSString *allLiXi = [NSString stringWithFormat:@"%.2f",generalLiXiMoney + limitLiXiMoney];
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f",generalLiXiMoney],[NSString stringWithFormat:@"%.2f",limitLiXiMoney],allLiXi, nil];
    [_dataSourceArrays addObject:arr2];
    [_tableView reloadData];

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
    OverdueCell *cell = (OverdueCell *)[tableView dequeueReusableCellWithIdentifier:OverdueCellID];
    [cell settingOverdueCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
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
        
        if (row == 1 || row == 2) {
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            UIWindow *windows = [QZManager getWindow];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                (row == 1)?(weakSelf.startTime = timeStr):(weakSelf.endTime = timeStr);
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }else if (row == 3){
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"人民银行同期利率",@"按约定利率"] title:@"利率方式"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                if ([selectedStr isEqualToString:@"按约定利率"]) {
                    
                    if (arr1.count == 4) {
                        [arr1 addObject:@""];
                    }
                }else{
                    if (arr1.count == 5) {
                        [arr1 removeObjectAtIndex:4];
                    }
                }
                
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
        [_tableView registerClass:[OverdueCell class] forCellReuseIdentifier:OverdueCellID];
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
- (NSMutableDictionary *)rateDictionary
{
    if (!_rateDictionary) {
      
        _rateDictionary = RATEDICTIONARY;
    }
    return _rateDictionary;
}
- (NSMutableArray *)timeArrays
{
    if (!_timeArrays) {
        _timeArrays = TIMEARRAYS;
    }
    return _timeArrays;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self initUI];
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
