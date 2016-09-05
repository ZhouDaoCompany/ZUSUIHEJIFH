//
//  CourtViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CourtViewController.h"
#import "CourtViewCell.h"
#import "ZHPickView.h"
#import "Disability_AlertView.h"

static NSString *const COURTCELL = @"courtacceptcell";
@interface CourtViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,Disability_AlertViewPro,CourtViewDelegate>
{
    BOOL _isHalf;
    BOOL _isMoney;
}
@property (assign, nonatomic) CGFloat theFrontalMoney;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) NSMutableDictionary *noMoneyDictionary;//不涉及财产计算
@end

@implementation CourtViewController
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
    _isMoney = YES;
    _isHalf = NO;
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"是",@"",@"减半", nil];
    [self.dataSourceArrays addObject:arr1];

    [self setupNaviBarWithTitle:@"法院受理费计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{WEAKSELF;
    [self dismissKeyBoard];
    if (btn.tag == 3034) {
        [self.dataSourceArrays removeAllObjects];
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"是",@"",@"全额", nil];
        [self.dataSourceArrays addObject:arr1];
        [UIView animateWithDuration:.25f animations:^{
            [weakSelf.tableView reloadData];
        }];
        return;
    }
    if (_dataSourceArrays.count >1) {
        [_dataSourceArrays removeObjectAtIndex:1];
    }
    NSMutableArray *arr1 = _dataSourceArrays[0];
    CGFloat lastmoney = 0.0f;
    
    NSString *caseType = arr1[0];
    if (caseType.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请选择案件类型"];
        return;
    }
    if ([arr1[0] isEqualToString:@"财产案件"] || [arr1[0] isEqualToString:@"支付令"]) {
        
        NSString *moneyString = arr1[1];
        if (moneyString.length == 0) {
            [JKPromptView showWithImageName:nil message:@"请输入金额"];
            return;
        }
        if ([arr1[0] isEqualToString:@"支付令"]) {
            lastmoney = [self involvingPropertyCalculationWithmoney:[moneyString floatValue]]/3.f;
        }else{
            lastmoney = [self involvingPropertyCalculationWithmoney:[moneyString floatValue]];
        }
        lastmoney = (_isHalf == YES)?(lastmoney/2.f):lastmoney;
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f元",lastmoney], nil];
        [self.dataSourceArrays addObject:arr2];
        [_tableView reloadData];
        
    }else if ([arr1[0] isEqualToString:@"离婚案件"] || [arr1[0] isEqualToString:@"人格权案件"] || [arr1[0] isEqualToString:@"知识产权案件"] || [arr1[0] isEqualToString:@"财产保全案件"]){
        
        if (_isMoney == YES) {
            
            NSString *moneyString = arr1[2];
            if (moneyString.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请输入金额"];
                return;
            }

            if ([arr1[0] isEqualToString:@"离婚案件"]) {
                
                NSString *str = [self divorceWithMoney:[moneyString floatValue]];
                [self doNotInvolvePropertyCalculation:str];
                
            }else if ([arr1[0] isEqualToString:@"人格权案件"]){
                
                NSString *str = [self personalityRight:[moneyString floatValue]];
                [self doNotInvolvePropertyCalculation:str];
            }else if ([arr1[0] isEqualToString:@"知识产权案件"]){
                lastmoney = (_isHalf == YES)?[self involvingPropertyCalculationWithmoney:[[self propertyPreservationWithMoney:[moneyString floatValue]] floatValue]/2.f]:[self involvingPropertyCalculationWithmoney:[[self propertyPreservationWithMoney:[moneyString floatValue]] floatValue]];
                NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f",lastmoney], nil];
                [self.dataSourceArrays addObject:arr2];
                [_tableView reloadData];

            }else{
                lastmoney = (_isHalf == YES)? [self involvingPropertyCalculationWithmoney:[moneyString floatValue]/2.f]:[self involvingPropertyCalculationWithmoney:[moneyString floatValue]];
                NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",[NSString stringWithFormat:@"%.2f元",lastmoney], nil];
                [self.dataSourceArrays addObject:arr2];
                [_tableView reloadData];
            }
            
        }else {
            NSString *str = self.noMoneyDictionary[caseType];
            [self doNotInvolvePropertyCalculation:str];
        }
        
    }else {
        NSString *str = self.noMoneyDictionary[caseType];
        [self doNotInvolvePropertyCalculation:str];
    }
}
- (void)doNotInvolvePropertyCalculation:(NSString *)string
{
    NSString *lastStr = @"";
    NSArray *array = [string componentsSeparatedByString:@","];
    if (array.count > 1) {
        lastStr  = (_isHalf == YES)?[NSString stringWithFormat:@"%.2f~%.2f元",[array[0] floatValue]/2.f,[array[1] floatValue]/2.f]:[NSString stringWithFormat:@"%.2f~%.2f元",[array[0] floatValue],[array[1] floatValue]];
    }else{
        lastStr  = (_isHalf == YES)?[NSString stringWithFormat:@"%.2f元",[array[0] floatValue]/2.f]:[NSString stringWithFormat:@"%.2f元",[array[0] floatValue]];
    }
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastStr, nil];
    [self.dataSourceArrays addObject:arr2];
    [_tableView reloadData];
}
#pragma mark -
#pragma mark - 离婚
- (NSString *)divorceWithMoney:(float)frontalMoney
{
    CGFloat lastmoney = 0.0f;
    if (frontalMoney > 200000.f) {
        lastmoney = (frontalMoney - 200000.f)*0.005f;
    }
    return [NSString stringWithFormat:@"%.2f,%.2f",50 + lastmoney,300 + lastmoney];
}
#pragma mark - 人格权
- (NSString *)personalityRight:(float)frontalMoney
{
    CGFloat lastmoney = 0.0f;
    if (frontalMoney > 50000.f && frontalMoney < 100000.f) {
        lastmoney = (frontalMoney - 50000.f)*0.01f;
    }else if (frontalMoney > 100000.f){
        lastmoney = (frontalMoney - 100000.f)*0.005f + 500.f;
    }
    return [NSString stringWithFormat:@"%.2f,%.2f元",100 + lastmoney,500 + lastmoney];
}
#pragma mark - 财产保全
- (NSString *)propertyPreservationWithMoney:(float)frontalMoney
{
    CGFloat lastmoney = 0.0f;
    if (frontalMoney > 1000.f && frontalMoney < 100000.f) {
        lastmoney = (frontalMoney - 50000.f)*0.01f;
    }else if (frontalMoney > 100000.f){
        lastmoney = (frontalMoney - 100000.f)*0.005f + 990.f;
    }
    if (lastmoney > 5000.f) {
        lastmoney = 5000.f;
    }
    return [NSString stringWithFormat:@"%.2f元",30 + lastmoney];
}
#pragma mark -  财产案件根据诉讼请求的金额或者价额，按照下列比例分段累计交纳
- (float)involvingPropertyCalculationWithmoney:(float)frontalMoney
{
    __block CGFloat lastmoney = 0.0f;
    NSArray *moneyArrays = @[@"10000",@"100000",@"200000",@"500000",@"1000000",@"2000000",@"5000000",@"10000000",@"20000000"];
    NSArray *percentageArrays = @[@"0.025",@"0.02",@"0.015",@"0.01",@"0.009",@"0.008",@"0.007",@"0.006",@"0.005"];
    NSArray *pieceArrays = @[@"50",@"2250",@"2000",@"4500",@"5000",@"9000",@"24000",@"35000",@"60000"];
    
    __block NSUInteger index = moneyArrays.count;
    [moneyArrays enumerateObjectsUsingBlock:^(NSString *objMoney, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (frontalMoney - [objMoney floatValue]<= 0) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == 0) {
        lastmoney = [pieceArrays[0] floatValue];
    }else if (index > moneyArrays.count - 1){
        
        [pieceArrays enumerateObjectsUsingBlock:^( NSString *objmoney, NSUInteger idx, BOOL * _Nonnull stop) {
            
            lastmoney  += [objmoney floatValue];
        }];
        lastmoney += (frontalMoney - [[moneyArrays lastObject] floatValue])*[[percentageArrays lastObject] floatValue];
    }else {
        
        for (NSInteger i = 0; i <index; i++) {
            lastmoney +=  [pieceArrays[i] floatValue];
        }
        lastmoney += (frontalMoney - [moneyArrays[index -1] floatValue])*[percentageArrays[index -1] floatValue];
    }
    return lastmoney;
}
#pragma mark - UITableViewDataSource
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
    CourtViewCell *cell = (CourtViewCell *)[tableView dequeueReusableCellWithIdentifier:COURTCELL];
    cell.textField.delegate = self;
    cell.delegate = self;
    [cell settingUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (row == 0) {
            Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:CaseType withDelegate:self];
            [alertView show];

        }
    }
}
#pragma mark - CourtViewDelegate
- (void)fullORHalf:(NSInteger)index withRow:(NSInteger)row
{
    _isHalf = (index == 1)?YES:NO;
    NSString *str2 = (_isHalf == YES)?@"减半":@"全额";
    NSMutableArray *arr1 = _dataSourceArrays[0];
    [arr1 replaceObjectAtIndex:row withObject:str2];
}
- (void)isInvolvedInTheAmount:(NSInteger)index withRow:(NSInteger)row
{
    _isMoney = (index == 0)?YES:NO;
    NSString *str1 = (_isMoney == YES)?@"是":@"否";
    NSMutableArray *arr1 = _dataSourceArrays[0];
    if (arr1.count == 4) {
        [arr1 replaceObjectAtIndex:row withObject:str1];
        [arr1 removeObjectAtIndex:row+1];
    }else{
        [arr1 replaceObjectAtIndex:row withObject:str1];
        [arr1 insertObject:@"" atIndex:row+1];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Disability_AlertViewPro
- (void)selectCaseType:(NSString *)caseString
{
    NSString *str1 = (_isMoney == YES)?@"是":@"否";
    NSString *str2 = (_isHalf == YES)?@"减半":@"全额";

    if ([caseString isEqualToString:@"财产案件"] || [caseString isEqualToString:@"支付令"]) {
        
        _isMoney = YES;
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:caseString,@"",str2, nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
    }else if ([caseString isEqualToString:@"离婚案件"] || [caseString isEqualToString:@"人格权案件"] || [caseString isEqualToString:@"知识产权案件"] || [caseString isEqualToString:@"财产保全案件"]){
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:caseString,str1,@"",str2, nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];

    }else{
        _isMoney = NO;
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:caseString,str2, nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
    }
    [_tableView reloadData];
    
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
        [_tableView registerClass:[CourtViewCell class] forCellReuseIdentifier:COURTCELL];
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
- (NSMutableDictionary *)noMoneyDictionary
{
    if (!_noMoneyDictionary) {
        _noMoneyDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"30",@"财产保全案件",@"50,300",@"离婚案件",@"100,500",@"人格权案件",@"500,1000元",@"知识产权案件",@"10",@"劳动争议案件",@"50,100",@"管辖权异议不成立的案件",@"100",@"商标、专利、海事行政案件",@"50",@"其他行政案件",@"100",@"公示催告", nil];
    }
    return _noMoneyDictionary;
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
