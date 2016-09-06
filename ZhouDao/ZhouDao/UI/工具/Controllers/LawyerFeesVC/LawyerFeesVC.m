//
//  LawyerFeesVC.m
//  ZhouDao
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawyerFeesVC.h"
#import "LawyerFeesCell.h"
#import "SelectProvinceVC.h"
#import "ZHPickView.h"
#import "ToolsIntroduceVC.h"
#import "LayerFeesModel.h"
#import "AllProportionModel.h"

static NSString *const LawyerFeesCellID = @"LawyerFeesidentifer";

@interface LawyerFeesVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,LawyerFeesCellPro>
{
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) NSDictionary *areasDictionary;
@property (copy, nonatomic)   NSString *isInterval;//是否是百分比区间
@end

@implementation LawyerFeesVC
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
{WEAKSELF;
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"是",@"", nil];
    [self.dataSourceArrays addObject:arr1];
    
    [self setupNaviBarWithTitle:@"律师费计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    [_tableView setTableFooterView:self.bottomLabel];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"lawerFees" ofType:@"txt"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xizang" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _areasDictionary = dict[@"area"];
    _isInterval = _areasDictionary[@"isInterval"];
    [_bottomLabel whenCancelTapped:^{
        
        DLog(@"点击跳转");
        if (weakSelf.bottomLabel.text.length >0) {
            ToolsIntroduceVC *vc = [ToolsIntroduceVC new];
            vc.introContent = weakSelf.areasDictionary[@"text"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
#pragma mark - event response
- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    [self dismissKeyBoard];
    
    if (btn.tag == 3033) {
        [self showLaywerFees];
    }else {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"",@"",@"是",@"", nil];
        _bottomLabel.text = @"";
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr];
        if (_dataSourceArrays.count == 2) {
            [_dataSourceArrays removeObjectAtIndex:1];
        }
        [self reloadTableViewWithAnimation];
    }
}
- (void)reloadTableViewWithAnimation
{WEAKSELF;
    
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView reloadData];
    }];
}
- (void)showLaywerFees
{
    NSMutableArray *arr = _dataSourceArrays[0];
    NSString *proString = arr[0];
    NSString *caseString = arr[1];
    
    if (proString.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您选择地区"];
        return;
    }
    if (_dataSourceArrays.count == 2) {
        [_dataSourceArrays removeObjectAtIndex:1];
    }
    if ([caseString isEqualToString:@"刑事案件"]) {
        
        NSDictionary *xs1Dixt = _areasDictionary[@"xs1"];
        NSString *stage = xs1Dixt[@"stage"];
        NSArray *stageArrays = [stage componentsSeparatedByString:@","];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"", nil];
        [arr2 addObjectsFromArray:stageArrays];
        [_dataSourceArrays addObject:arr2];
        
        [self reloadTableViewWithAnimation];
    }
    if ([caseString isEqualToString:@"行政案件"]) {
        NSString *isMoney = arr[2];
        if ([isMoney isEqualToString:@"是"]) {
            
            LayerFeesModel *model = [[LayerFeesModel alloc] initWithDictionary:_areasDictionary[@"xz1"]];
            
            if ([_isInterval isEqualToString:@"1"]) {
                //1 是百分比  2百分比区间计算
                [self calaulateWithMSAndXZCaseWith:model];
            }else {
                [self percentageRangeCalculationWith:model];
            }

        }else {
            
            NSDictionary *xz2Dixt = _areasDictionary[@"xz2"];
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",xz2Dixt[@"fees"], nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
        }
    }
    if ([caseString isEqualToString:@"民事案件"]) {
        NSString *isMoney = arr[2];
        if ([isMoney isEqualToString:@"是"]) {
            
            LayerFeesModel *model = [[LayerFeesModel alloc] initWithDictionary:_areasDictionary[@"ms1"]];
            if ([_isInterval isEqualToString:@"1"]) {
                [self calaulateWithMSAndXZCaseWith:model];
            }else {
                [self percentageRangeCalculationWith:model];
            }
            
        }else {
            NSDictionary *ms2Dixt = _areasDictionary[@"ms2"];
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",ms2Dixt[@"fees"], nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
        }
    }
}
#pragma mark - 百分比区间
- (void)percentageRangeCalculationWith:(LayerFeesModel *)model
{
    NSMutableArray *arr = _dataSourceArrays[0];
    NSString *moneyString  =arr[3];
    if (moneyString.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您输入金额"];
        return;
    }
    __block NSUInteger index = model.allMoney.count;
    [model.allMoney enumerateObjectsUsingBlock:^(NSString *objMoney, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (([moneyString floatValue] - [objMoney floatValue]) <= 0) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == 0) {
        
        AllProportionModel *perModel = model.allPer[0];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",perModel.con, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];
    }else if (index > model.allMoney.count - 1){
        //最后一位是百分比还是说明 1是说明  2是
        
        AllProportionModel *perModel = model.allPer[model.allPer.count -1];
        if ([perModel.type isEqualToString:@"1"]) {
            //eg:大于多少自行协商
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",perModel.con, nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
        }else {
            float lastMoneyMax = 0.0f;
            float lastMoneyMin = 0.0f;

            for (NSInteger i =0; i< index; i++) {
                NSArray *array = [model.allPerMoney[i] componentsSeparatedByString:@","];

                lastMoneyMin = lastMoneyMin + [array[0] floatValue];
                lastMoneyMax = lastMoneyMax + [array[1] floatValue];
            }
            lastMoneyMin = lastMoneyMin + ([moneyString floatValue] - [model.allMoney[index - 1] floatValue])*[perModel.conMin floatValue];
            lastMoneyMax = lastMoneyMax + ([moneyString floatValue] - [model.allMoney[index - 1] floatValue])*[perModel.conMax floatValue];
            
            NSString *lastMoneyString = [NSString stringWithFormat:@"%.2f ~ %.2f元",lastMoneyMin,lastMoneyMax];
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
        }
        
    }else {
        float lastMoneyMax = 0.0f;
        float lastMoneyMin = 0.0f;
        
        for (NSInteger i =0; i< index; i++) {
            NSArray *array = [model.allPerMoney[i] componentsSeparatedByString:@","];
            
            lastMoneyMin = lastMoneyMin + [array[0] floatValue];
            lastMoneyMax = lastMoneyMax + [array[1] floatValue];
        }
        AllProportionModel *perModel = model.allPer[index];

        if ([moneyString floatValue] > [model.allMoney[index-1] floatValue]) {
            
            lastMoneyMin = lastMoneyMin + ([moneyString floatValue] - [model.allMoney[index - 1] floatValue])*[perModel.conMin floatValue];
            lastMoneyMax = lastMoneyMax + ([moneyString floatValue] - [model.allMoney[index - 1] floatValue])*[perModel.conMax floatValue];
        }
        NSString *lastMoneyString = [NSString stringWithFormat:@"%.2f ~ %.2f元",lastMoneyMin,lastMoneyMax];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];

    }
}
#pragma mark - 非百分比区间
- (void)calaulateWithMSAndXZCaseWith:(LayerFeesModel *)model
{
    NSMutableArray *arr = _dataSourceArrays[0];
    NSString *moneyString  =arr[3];
    if (moneyString.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您输入金额"];
        return;
    }
    
    __block NSUInteger index = model.allMoney.count;
    [model.allMoney enumerateObjectsUsingBlock:^(NSString *objMoney, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (([moneyString floatValue] - [objMoney floatValue]) <= 0) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == 0) {
        AllProportionModel *perModel = model.allPer[0];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",perModel.con, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];
        
    }else if (index > model.allMoney.count - 1){
        //最后一位是百分比还是说明 1是说明  2是
        AllProportionModel *perModel = model.allPer[model.allPer.count -1];
        if ([perModel.type isEqualToString:@"1"]) {
            
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",perModel.con, nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
            
        }else {
            float lastMoney = 0.0f;
            for (NSInteger i =0; i< index; i++) {
                lastMoney = lastMoney + [model.allPerMoney[i] floatValue];
            }
            lastMoney = lastMoney + ([moneyString floatValue] - [model.allMoney[index - 1] floatValue])*[perModel.con floatValue];
            
            NSString *lastMoneyString = [NSString stringWithFormat:@"%.2f元",lastMoney];
            NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
            [_dataSourceArrays addObject:arr2];
            [self reloadTableViewWithAnimation];
        }
        
    }else {
        
        float lastMoney = 0.0f;
        for (NSInteger i =0; i< index; i++) {
            lastMoney = lastMoney + [model.allPerMoney[i] floatValue];
        }
        AllProportionModel *perModel = model.allPer[index];
        
        if ([moneyString floatValue] > [model.allMoney[index-1] floatValue]) {
            
            lastMoney  = lastMoney + ([moneyString floatValue] - [model.allMoney[index-1] floatValue])*[perModel.con floatValue];
        }
        NSString *lastMoneyString = [NSString stringWithFormat:@"%.2f元",lastMoney];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];
    }
}

#pragma mark - LawyerFeesCellPro
- (void)aboutProperty:(NSInteger)index
{
    NSMutableArray *arr1 = _dataSourceArrays[0];
    if (index == 1) {
        [arr1 replaceObjectAtIndex:2 withObject:@"否"];
        [arr1 removeObjectAtIndex:3];
        [self reloadTableViewWithAnimation];
    }else {
        if (arr1.count == 3) {
            [arr1 addObject:@""];
            [self reloadTableViewWithAnimation];
        }
        [arr1 replaceObjectAtIndex:2 withObject:@"是"];
    }
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
    LawyerFeesCell *cell = (LawyerFeesCell *)[tableView dequeueReusableCellWithIdentifier:LawyerFeesCellID];
    cell.delegate = self;
    cell.textField.delegate = self;
    [cell settingUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays];
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
        if (row == 0) {
            SelectProvinceVC *selectVC = [SelectProvinceVC new];
            selectVC.selectBlock = ^(NSString *province, NSString *local){

//                上海
                weakSelf.bottomLabel.text = [NSString stringWithFormat:@"根据《%@诉讼费用交纳办法》计算，供您参考",province];
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:province];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            };
            [self presentViewController:selectVC animated:YES completion:nil];
        }else if(row == 1){
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"民事案件",@"刑事案件",@"行政案件"] title:@"案件类型"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                if ([selectedStr isEqualToString:@"刑事案件"]) {
                    if (arr1.count == 4) {
                        [arr1 removeObjectAtIndex:3];
                    }
                    [arr1 removeObjectAtIndex:2];
                }else {
                    if (arr1.count == 2) {
                        [arr1 addObject:@"是"];
                        [arr1 addObject:@""];
                    }
                }
                [weakSelf.tableView reloadData];
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[LawyerFeesCell class] forCellReuseIdentifier:LawyerFeesCellID];
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
- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-10, 30)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(00c8aa);
        _bottomLabel.font = Font_12;
    }
    return _bottomLabel;
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
