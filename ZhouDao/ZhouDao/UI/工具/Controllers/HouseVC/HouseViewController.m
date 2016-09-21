//
//  HouseViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#define  FUNDARRAYS      @[ @"2.75", @"3.25"]
#define  BUSINESSARRSYS  @[@"4.35",@"4.35",@"0.0475",@"4.75",@"4.90"]

#import "HouseViewController.h"
#import "HouseViewCell.h"
#import "ZHPickView.h"
#import "HouseDetailVC.h"

static NSString *const HOUSECELL = @"housecellid";

@interface HouseViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,HouseViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (assign, nonatomic) BOOL isBJ;
@property (strong, nonatomic) NSMutableDictionary *bigDictionary;//详情大字典
@property (copy, nonatomic) UIView *bottomView;

@end

@implementation HouseViewController

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
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
//    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];
//    [self.dataSourceArrays addObject:arr2];

    [self setupNaviBarWithTitle:@"房屋还贷计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    if (btn.tag == 3034) {
        
        if (_dataSourceArrays.count == 2) {
            
            [_dataSourceArrays removeObjectAtIndex:1];
        }
        _tableView.tableFooterView = nil;
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadData];
    }else {
        
        NSMutableArray *arr1 = _dataSourceArrays[0];
        NSString *oneString = arr1[0];
        NSArray *alertArrays = [oneString isEqualToString:@"商业贷款"]?@[@"请选择贷款类型",@"请填写商业贷款额度",@"请您选择请选择商业贷款期限",@"请您选择请选择商业贷款期限",@""]:@[@"请选择贷款类型",@"请填写公积金贷款额度",@"请您选择请选择公积金贷款期限",@"请选择公积金贷款期限",@"请填写商业贷款额度",@"请您选择请选择商业贷款期限",@"请您选择请选择商业贷款期限",@""];
        
        for (NSUInteger i = 0; i<arr1.count; i++) {
            
            NSString *tempString = arr1[i];
            if (tempString.length == 0 && i<arr1.count -1) {
                [JKPromptView showWithImageName:nil message:alertArrays[i]];
                return;
            }
        }
        _isBJ = NO;
        _tableView.tableFooterView = self.bottomView;

        if (_dataSourceArrays.count == 2) {
            
            [_dataSourceArrays removeObjectAtIndex:1];
        }
        if ([oneString isEqualToString:@"组合贷款"]) {
            
            NSString *limitString = arr1[1];
            double rate01 = [arr1[3] doubleValue];
            rate01 = rate01/1200.f;

            //商业
            NSString *discountString = [arr1 lastObject];
            double discount = (discountString.length == 0)?1.f:([discountString floatValue]/100.f);
            double rate11 = [arr1[5] doubleValue];
            rate11 = rate11*discount/1200.f;

            [self loanPortfolioMethodsWithArrays:arr1 withRate01:rate01 withRate11:rate11 withLimitString:limitString];
        }else {
            
            NSString *limitString = arr1[2];
            double rate = [arr1[3] doubleValue];
            rate = rate/1200.f;
            if ([oneString isEqualToString:@"商业贷款"]){
                NSString *discountString = [arr1 lastObject];
                double discount = (discountString.length == 0)?1.f:([discountString floatValue]/100.f);
                rate = rate*discount;
            }
            [self calculationOfAccumulationFundLoanWithArrays:arr1 withRate:rate withLimitString:limitString];
        }
    }
}
#pragma mark - 公积金 ,商业 贷款
- (void)calculationOfAccumulationFundLoanWithArrays:(NSMutableArray *)arrays withRate:(double)rate withLimitString:(NSString *)limitString
{
    double money = [arrays[1] doubleValue];
    double limit = [limitString doubleValue]*12;
    //等额本息
    double monthMoney1 = [CalculateManager loanPrincipal:money withAnInterest:rate withRepaymentPeriods:limit];
    
    double allMoney1 = limit * monthMoney1;
    double allLiXiMoney1 = allMoney1 - money;

    NSArray *array1 = @[@"",[NSString stringWithFormat:@"%.2f",monthMoney1*10000],[NSString stringWithFormat:@"%.0f",limit],[NSString stringWithFormat:@"%.2f",allLiXiMoney1],[NSString stringWithFormat:@"%.2f",allMoney1]];

    //详情
    NSMutableArray *dicArr1 = [CalculateManager getAllMonthsWithPrincipal:money withMonthsMoney:monthMoney1 withRate:rate withMonthsCounts:limit];
    NSMutableDictionary *oneDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",allMoney1],@"allMoney",[NSString stringWithFormat:@"%.2f",allLiXiMoney1],@"allLiXiMoney",[NSString stringWithFormat:@"%.2f",money],@"money",[NSString stringWithFormat:@"%.0f",limit],@"months",dicArr1,@"MutableArray",nil,@"MutableArray2",nil];
    [self.bigDictionary setObjectWithNullValidate:oneDict forKey:@"OneDictionary"];

    //等额本金
    NSMutableArray *dicArr2 = [NSMutableArray array];
    double monthBJMoney2 = money/limit;//月供本金
    double allLiXiMoney2 = 0.0f;
    for (NSUInteger i = 0; i<limit; i++) {
        
        NSMutableArray *smallArrays = [NSMutableArray array]; //小数组内结构 月供本金，月供利息，剩余本金
        double remainMoney = money - monthBJMoney2*i;//剩余本金
        double monthLiXiMoney2 = remainMoney*rate;//月供利息
        allLiXiMoney2 += monthLiXiMoney2;
        
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",monthBJMoney2 *10000]];
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",monthLiXiMoney2 *10000]];
        [smallArrays addObject:[NSString stringWithFormat:@"%.2f",(remainMoney -monthBJMoney2)*10000]];
        
        [dicArr2 addObject:smallArrays];
    }
    double allMoney2 = allLiXiMoney2 + money;
    
    NSArray *array2 = @[@"",[NSString stringWithFormat:@"%.0f",limit],[NSString stringWithFormat:@"%.2f",allLiXiMoney2],[NSString stringWithFormat:@"%.2f",allMoney2]];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:array1,array2, nil];
    [_dataSourceArrays addObject:arr2];
    [self  reloadTableViewWithAnimation];
    
    //添加详情
    NSMutableDictionary *twoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",allMoney2],@"allMoney",[NSString stringWithFormat:@"%.2f",allLiXiMoney2],@"allLiXiMoney",[NSString stringWithFormat:@"%.2f",money],@"money",[NSString stringWithFormat:@"%.0f",limit],@"months",dicArr2,@"MutableArray",nil,@"MutableArray2",nil];
    [self.bigDictionary setObjectWithNullValidate:twoDict forKey:@"TwoDictionary"];

}
#pragma mark - 组合贷款
- (void)loanPortfolioMethodsWithArrays:(NSMutableArray *)arrays withRate01:(double)rate01 withRate11:(double)rate11 withLimitString:(NSString *)limitString
{
    double money01 = [arrays[2] doubleValue];
    double money11 = [arrays[4] doubleValue];
    double limit = [limitString doubleValue]*12;
    
    /*******等额本息****************/
    //公积金
    double monthMoney01 = [CalculateManager loanPrincipal:money01 withAnInterest:rate01 withRepaymentPeriods:limit];
    double allMoney01 = limit * monthMoney01;
    double allLiXiMoney01 = allMoney01 - money01;

    //商业
    double monthMoney11 = [CalculateManager loanPrincipal:money11 withAnInterest:rate11 withRepaymentPeriods:limit];
    double allMoney11 = limit * monthMoney11;
    double allLiXiMoney11 = allMoney11 - money11;

    NSArray *array1 = @[@"",[NSString stringWithFormat:@"%.2f",(monthMoney01 + monthMoney11)*10000],[NSString stringWithFormat:@"%.0f",limit],[NSString stringWithFormat:@"%.2f",allLiXiMoney01 + allLiXiMoney11],[NSString stringWithFormat:@"%.2f",allMoney01 + allMoney11]];
    
    //详情
    NSMutableArray *dicArr01 = [CalculateManager getAllMonthsWithPrincipal:money01 withMonthsMoney:monthMoney01 withRate:rate01 withMonthsCounts:limit];
    NSMutableArray *dicArr11 = [CalculateManager getAllMonthsWithPrincipal:money11 withMonthsMoney:monthMoney11 withRate:rate11 withMonthsCounts:limit];

    NSMutableDictionary *oneDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",allMoney01 + allMoney11],@"allMoney",[NSString stringWithFormat:@"%.2f",allLiXiMoney01 + allLiXiMoney11],@"allLiXiMoney",[NSString stringWithFormat:@"%.2f",money01 + money11],@"money",[NSString stringWithFormat:@"%.0f",limit],@"months",dicArr01,@"MutableArray",dicArr11,@"MutableArray2",nil];
    [self.bigDictionary setObjectWithNullValidate:oneDict forKey:@"OneDictionary"];

    /*******等额本金****************/
    //公积金
    double monthBJMoney02 = money01/limit;//月供本金
    NSMutableArray *dicArr02 = [NSMutableArray array];
    NSMutableArray *dicArr12 = [NSMutableArray array];

    double allLiXiMoney02 = 0.0f;
    for (NSUInteger i = 0; i<limit; i++) {
        NSMutableArray *smallArrays01 = [NSMutableArray array];
        double remainMoney = money01 - monthBJMoney02*i;//剩余本金
        double monthLiXiMoney02 = remainMoney*rate01; //月供利息
        allLiXiMoney02 += monthLiXiMoney02;
        
        [smallArrays01 addObject:[NSString stringWithFormat:@"%.2f",monthBJMoney02 *10000]];
        [smallArrays01 addObject:[NSString stringWithFormat:@"%.2f",monthLiXiMoney02 *10000]];
        [smallArrays01 addObject:[NSString stringWithFormat:@"%.2f",(remainMoney -monthBJMoney02)*10000]];
        [dicArr02 addObject:smallArrays01];
    }
    double allMoney02 = allLiXiMoney02 + money01;
    
    //商业
    double monthBJMoney12 = money11/limit;//月还本金额
    
    double allLiXiMoney12 = 0.0f;
    for (NSUInteger i = 0; i<limit; i++) {
        
        NSMutableArray *smallArrays11 = [NSMutableArray array];

        double remainMoney = money11 - monthBJMoney12*i;//剩余本金
        double monthLiXiMoney12 = remainMoney*rate11;
        allLiXiMoney12 += monthLiXiMoney12;
        
        [smallArrays11 addObject:[NSString stringWithFormat:@"%.2f",monthBJMoney12 *10000]];
        [smallArrays11 addObject:[NSString stringWithFormat:@"%.2f",monthLiXiMoney12 *10000]];
        [smallArrays11 addObject:[NSString stringWithFormat:@"%.2f",(remainMoney -monthBJMoney12)*10000]];
        [dicArr12 addObject:smallArrays11];
    }
    double allMoney12 = allLiXiMoney12 + money11;

    NSArray *array2 = @[@"",[NSString stringWithFormat:@"%.0f",limit],[NSString stringWithFormat:@"%.2f",allLiXiMoney02 + allLiXiMoney12],[NSString stringWithFormat:@"%.2f",allMoney02 + allMoney12]];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:array1,array2, nil];
    [_dataSourceArrays addObject:arr2];
    [self  reloadTableViewWithAnimation];
    
    //添加详情
    NSMutableDictionary *twoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%.2f",allMoney02 + allMoney12],@"allMoney",[NSString stringWithFormat:@"%.2f",allLiXiMoney02 + allLiXiMoney12],@"allLiXiMoney",[NSString stringWithFormat:@"%.2f",money01 + money11],@"money",[NSString stringWithFormat:@"%.0f",limit],@"months",dicArr02,@"MutableArray",dicArr12,@"MutableArray2",nil];
    [self.bigDictionary setObjectWithNullValidate:twoDict forKey:@"TwoDictionary"];

}
- (void)rightBtnAction
{
    
}
- (void)reloadTableViewWithAnimation
{
    [_tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataSourceArrays[section];
    if (section == 0) {
        return [arr count];
    }
    return (_isBJ == NO)?[arr[0] count]:[arr[1] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    HouseViewCell *cell = (HouseViewCell *)[tableView dequeueReusableCellWithIdentifier:HOUSECELL];
    cell.textField.delegate = self;
    cell.delegate = self;
    cell.isBJ = _isBJ;
    [cell settingHouseCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
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
    if (section == 1) {
        return;
    }
    if (row == 0) {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"公积金贷款",@"商业贷款",@"组合贷款"] title:@"贷款类型"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            NSMutableArray *temArr = weakSelf.dataSourceArrays[section];
            [temArr replaceObjectAtIndex:row withObject:selectedStr];
            
            if ([selectedStr isEqualToString:@"公积金贷款"]) {
                
                if (temArr.count != 4) {
                    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:selectedStr,@"",@"",@"", nil];
                    [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                }
            }else if ([selectedStr isEqualToString:@"商业贷款"]){
                
                if (temArr.count != 5) {
                    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:selectedStr,@"",@"",@"",@"", nil];
                    [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                }
            }else {
                
                if (temArr.count != 7) {
                    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:selectedStr,@"",@"",@"",@"",@"",@"", nil];
                    [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                }
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if (row == 2){
        
        NSMutableArray *temArr = _dataSourceArrays[0];
        NSString *oneString = temArr[0];

        [self selectTimeLimit:row withType:oneString];
    }else if (row == 1){
        NSMutableArray *temArr = _dataSourceArrays[0];
        NSString *oneString = temArr[0];
        if ([oneString isEqualToString:@"组合贷款"]) {
            
            [self selectTimeLimit:row withType:oneString];
        }
    }
}
- (void)selectTimeLimit:(NSInteger)row withType:(NSString *)oneString
{WEAKSELF;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:@[@"5",@"10",@"15",@"20",@"25",@"30"] title:@"贷款期限"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr,NSString *type)
    {
        if ([oneString isEqualToString:@"公积金贷款"]) {
            NSString *rateString = ([selectedStr isEqualToString:@"5"])?FUNDARRAYS[0]:FUNDARRAYS[1];
            NSMutableArray *arr1 = weakSelf.dataSourceArrays[0];
            [arr1 replaceObjectAtIndex:row withObject:selectedStr];
            [arr1 replaceObjectAtIndex:3 withObject:rateString];
        }else if ([oneString isEqualToString:@"商业贷款"]){
            
            NSString *rateString = ([selectedStr isEqualToString:@"5"])?BUSINESSARRSYS[3]:BUSINESSARRSYS[4];
            NSMutableArray *arr1 = weakSelf.dataSourceArrays[0];
            [arr1 replaceObjectAtIndex:row withObject:selectedStr];
            [arr1 replaceObjectAtIndex:3 withObject:rateString];
        }else {
            NSString *rateString1 = ([selectedStr isEqualToString:@"5"])?FUNDARRAYS[0]:FUNDARRAYS[1];
            NSString *rateString2 = ([selectedStr isEqualToString:@"5"])?BUSINESSARRSYS[3]:BUSINESSARRSYS[4];

            NSMutableArray *arr1 = weakSelf.dataSourceArrays[0];
            [arr1 replaceObjectAtIndex:row withObject:selectedStr];
            [arr1 replaceObjectAtIndex:3 withObject:rateString1];
            [arr1 replaceObjectAtIndex:5 withObject:rateString2];

        }
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    };
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
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 64.f;
    }
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
#pragma mark - HouseViewDelegate
- (void)optionEvent:(NSInteger)segIndex withCell:(HouseViewCell *)cell
{
    if (segIndex == 1) {
        _isBJ = YES;
    }else {
        _isBJ = NO;
    }

//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self dismissKeyBoard];
    if (textField.text.length == 0) {
        return YES;
    }
    CaseTextField *text = (CaseTextField *)textField;
    NSInteger row = text.row;
    NSMutableArray *arr = _dataSourceArrays[0];
    NSString *oneString = arr[0];
    if ([oneString isEqualToString:@"商业贷款"]) {
        if (row == 4) {
            
            double txtNumber = [textField.text doubleValue];
            if (txtNumber >130) {
                textField.text = @"70";
                [arr replaceObjectAtIndex:4 withObject:@"130"];
            }
            if (txtNumber < 70) {
                textField.text = @"70";
                [arr replaceObjectAtIndex:4 withObject:@"70"];
            }
        }
    }else if ([oneString isEqualToString:@"组合贷款"]){
        if (row == 6) {
            
            double txtNumber = [textField.text doubleValue];
            if (txtNumber >130) {
                textField.text = @"70";
                [arr replaceObjectAtIndex:6 withObject:@"130"];
            }
            if (txtNumber < 70) {
                textField.text = @"70";
                [arr replaceObjectAtIndex:6 withObject:@"70"];
            }
        }
    }
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
        [_tableView registerClass:[HouseViewCell class] forCellReuseIdentifier:HOUSECELL];
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
- (NSMutableDictionary *)bigDictionary
{
    if (!_bigDictionary) {
       
        _bigDictionary = [NSMutableDictionary dictionary];
    }
    return _bigDictionary;
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
            
            NSMutableArray *arr1 = weakSelf.dataSourceArrays[0];
            NSString *oneString = arr1[0];
            HouseDetailVC *vc = [HouseDetailVC new];
            vc.bigDictionary = _bigDictionary;
            vc.isZH = [oneString isEqualToString:@"组合贷款"]?YES:NO;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }
    return _bottomView;
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
