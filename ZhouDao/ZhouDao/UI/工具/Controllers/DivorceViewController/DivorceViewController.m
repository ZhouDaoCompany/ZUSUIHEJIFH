//
//  DivorceViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DivorceViewController.h"
#import "DivorceViewCell.h"

static NSString *const DivorceCellID = @"DivorceCellID";

@interface DivorceViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;

@end

@implementation DivorceViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];
    
    [self setupNaviBarWithTitle:@"离婚房产分割计算"];
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
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }else {
        //计算
        NSMutableArray *arr = _dataSourceArrays[0];

        NSArray *arrays = [NSArray arrayWithObjects:@"请输入结婚时诉争房产价格",@"请输入离婚时诉争房产价格",@"请输入共同已还利息",@"请输入契税等其他费用",@"请输入共同还贷部分", nil];
        for (NSUInteger i = 0; i<arr.count ; i++) {
            NSString *str = arr[i];
            if (str.length == 0) {
                [JKPromptView showWithImageName:nil message:arrays[i]];
                return;
            }
        }
        float rate = [self getAppreciationRateWithArrays:arr];
        NSString *str1 = [NSString stringWithFormat:@"%.0f",rate*100];
        NSString *str2 = [NSString stringWithFormat:@"%f",[self valueAddedAmountAfterMarriage:rate withArrays:arr]];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",str1,str2, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];
    }
}
- (void)reloadTableViewWithAnimation
{WEAKSELF;
    
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - 诉争房产的升值率（%）
- (float)getAppreciationRateWithArrays:(NSMutableArray *)arr
{
    float getMarriedMoney = [arr[0] floatValue];//结婚时诉争房产价格（元）
    float divorceMoney = [arr[1] floatValue];//离婚时诉争房产价格（元）
    float interestMoney = [arr[2] floatValue];//共同已还利息（元）
    float deedTaxMoney = [arr[3] floatValue];//契税等其他费用（元）
    float rate = 0.0f;
    rate = divorceMoney/(getMarriedMoney + interestMoney + deedTaxMoney);
    return rate;
}
#pragma mark - 婚后增值金额（元）
- (float)valueAddedAmountAfterMarriage:(float)rate withArrays:(NSMutableArray *)arr
{
    float loanMoney = [arr[4] floatValue];//共同还贷部分（元）
    float addMoney = 0.0f;
    addMoney = loanMoney*rate;
    return addMoney;
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
    DivorceViewCell *cell = (DivorceViewCell *)[tableView dequeueReusableCellWithIdentifier:DivorceCellID];
    [cell settingOverdueCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
    cell.textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    
    return cell;
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
        [_tableView registerClass:[DivorceViewCell class] forCellReuseIdentifier:DivorceCellID];
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
