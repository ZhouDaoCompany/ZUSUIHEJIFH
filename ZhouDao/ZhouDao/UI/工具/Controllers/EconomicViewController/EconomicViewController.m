//
//  EconomicViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "EconomicViewController.h"
#import "EconomicViewCell.h"
#import "ZHPickView.h"
#import "SelectCityViewController.h"

static NSString *const ECONOMICCellID = @"ECONOMICCellID";

@interface EconomicViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,CalculateShareDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSString *startTime;//开始时间戳
@property (copy, nonatomic) NSString *endTime;//结束时间戳

@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) UIView *bottomView;
@property (copy, nonatomic) NSString *averageMoney;//各市平均工资
@end

@implementation EconomicViewController

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
    
    [self setupNaviBarWithTitle:@"经济补偿金计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    
}
#pragma mark -
#pragma mark - event response
- (void)rightBtnAction
{
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index
{
    if (index >0) {
        if (_dataSourceArrays.count == 1) {
            
            [JKPromptView showWithImageName:nil message:@"请您计算后再来分享"];
            return;
        }
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-jingjibuchang",@"type", nil];
        for (NSUInteger i = 0; i<_dataSourceArrays.count; i++) {
            
            NSMutableArray *arrays = [_dataSourceArrays[i] mutableCopy];
            [arrays removeObject:@""];
            NSString *keyString = (i == 0)?@"conditions":@"results";
            [shareDict setObject:arrays forKey:keyString];
        }
        
        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            NSArray *arrays;
            if (index == 1) {
                 arrays = [NSArray arrayWithObjects:@"经济补偿计算",@"经济补偿计算结果",urlString,@"", nil];
            }else {
                 arrays = [NSArray arrayWithObjects:@"经济补偿计算",@"经济补偿计算结果word",[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString],@"", nil];
            }

            [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            }];
            
        } fail:^{
            
        }];
        
    }else {//分享计算器
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,JJBCCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"经济补偿计算",@"经济补偿计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
}

- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    
    if (btn.tag == 3038) {
        
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
        NSArray *alertArrays = @[@"请选择开始日期",@"请选择结束日期",@"请填写平均工资",@"请选择工作城市"];
        
        for (NSUInteger i = 0; i<alertArrays.count; i++) {
            NSString *tempString = arr1[i];
            if (tempString.length == 0) {
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
        
        [self theAmountOfCompensation:arr1];
        _tableView.tableFooterView = self.bottomView;

        [JKPromptView showWithImageName:nil message:@"平均工资低于当地最低工资标准时 \n 请输入当地最低工资标准."];

    }
    
}

- (void)theAmountOfCompensation:(NSMutableArray *)arrys
{WEAKSELF;
    NSDate *date1 = [QZManager timeStampChangeNSDate:[_startTime doubleValue]];
    NSDate *date2 = [QZManager timeStampChangeNSDate:[_endTime doubleValue]];

    [self calculateYearsWithMonthsFromDate:date1 toDate:date2 withProvince:arrys[3]withWage:arrys[2] Success:^(NSString *money, NSString *months) {
        
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",money,months, nil];
        [weakSelf.dataSourceArrays addObject:arr2];
        [weakSelf.tableView reloadData];
    }];
}
- (void)calculateYearsWithMonthsFromDate:(NSDate *)date1 toDate:(NSDate *)date2 withProvince:(NSString *)province withWage:(NSString *)wage Success:(void(^)(NSString *money,NSString *months))success
{
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSUInteger years = [components year];
    NSUInteger months = [components month];
    double money = 0.0f;
    double counts = years;
    if (months >6) {
        counts +=1;
    }else {
        counts +=.5f;
    }
    if (counts >12) {
        counts = 12.f;
    }
    
    double averayeMoney = ([wage doubleValue] >= [_averageMoney doubleValue] *3)?[_averageMoney doubleValue] *3: [_averageMoney doubleValue];
    money = averayeMoney * counts;
    NSString *moneyString = [NSString stringWithFormat:@"%.2f",money];
    NSString *monthsString = [NSString stringWithFormat:@"%.2f",counts];

    success(moneyString, monthsString);
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
    EconomicViewCell *cell = (EconomicViewCell *)[tableView dequeueReusableCellWithIdentifier:ECONOMICCellID];
    [cell settingEconomicCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    cell.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
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
        }else if (row == 3){
            
            SelectCityViewController *cityVC = [SelectCityViewController new];
            cityVC.type = EconomicType;
            cityVC.citySelectBlock = ^(NSString *name, NSString *idString){
                
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                weakSelf.averageMoney = idString;
                [arr1 replaceObjectAtIndex:row withObject:name];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self  presentViewController:cityVC animated:YES completion:^{
            }];
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
        [_tableView registerClass:[EconomicViewCell class] forCellReuseIdentifier:ECONOMICCellID];
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
        _calculateButton.tag = 3037;
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
        _resetButton.tag = 3038;
        [_resetButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
- (UIView *)bottomView
{
    if (!_bottomView) {WEAKSELF;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 75.f)];
        _bottomView.backgroundColor = [UIColor clearColor];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, kMainScreenWidth-10, 40)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = hexColor(00c8aa);
        label2.font = Font_12;
        label2.text = @"根据《劳动合同法》计算，本计算器的补偿标准仅适用于2008年 1月1日以后订立的劳动合同，供您参考。";
        [_bottomView addSubview:label2];
        [label2 whenCancelTapped:^{
            
            
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
