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
#import "TaskModel.h"
#import "ReadViewController.h"

static NSString *const LawyerFeesCellID = @"LawyerFeesidentifer";

@interface LawyerFeesVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,LawyerFeesCellPro,CalculateShareDelegate>
{
    
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) NSDictionary *areasDictionary;
@property (strong, nonatomic) NSDictionary *bigDictionary;

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
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI { WEAKSELF;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"lawyerfees.plist"];
    //    NSData *data = [NSData dataWithContentsOfFile:path];
    //    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.bigDictionary= [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"是",@"", nil];

    if ([PublicFunction ShareInstance].locProv.length > 0) {
        
        NSString *province = [PublicFunction ShareInstance].locProv;
        if (_bigDictionary) {
            self.areasDictionary = _bigDictionary[province];
            self.isInterval = _areasDictionary[@"isInterval"];
            self.bottomLabel.text = [NSString stringWithFormat:@"根据《%@诉讼费用交纳办法》计算，供您参考",province];
            [arr1 replaceObjectAtIndex:0 withObject:province];
        }
    }
    
    [self.dataSourceArrays addObject:arr1];
    
    [self setupNaviBarWithTitle:@"律师费计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
    [_tableView setTableFooterView:self.bottomLabel];

    [_bottomLabel whenCancelTapped:^{
        
        DLog(@"点击跳转");
        if (weakSelf.bottomLabel.text.length >0) {
            ToolsIntroduceVC *vc = [ToolsIntroduceVC new];
            vc.introContent = weakSelf.areasDictionary[@"text"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
#pragma mark - event response
- (void)rightBtnAction {
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
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-lvshifei",@"type", nil];
        for (NSUInteger i = 0; i<_dataSourceArrays.count; i++) {
            
            NSMutableArray *arrays = _dataSourceArrays[i];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSUInteger j = 0; j<arrays.count; j++) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:i];
                LawyerFeesCell *cell = (LawyerFeesCell *)[_tableView cellForRowAtIndexPath:indexPath];
                DLog(@"999--:%@",cell.titleLab.text);

                NSString *tempString = [NSString stringWithFormat:@"%@-%@",cell.titleLab.text,arrays[j]];
                if (![cell.titleLab.text isEqualToString:@"计算结果"]) {
                    
                    [arr addObject:tempString];
                }
            }
            NSString *keyString = (i == 0)?@"conditions":@"results";
            [shareDict setObject:arr forKey:keyString];
        }
        
        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            if (index == 1) {
                
                 NSArray *arrays = [NSArray arrayWithObjects:@"律师费计算",@"律师费计算结果",urlString,@"", nil];
                
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];

            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"律师费计算结果Word%@.docx",idString];
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
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,LVSFCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"律师费计算",@"律师费计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
}
- (void)calculateAndResetBtnEvent:(UIButton *)btn {
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
{
    [_tableView reloadData];
}
- (void)showLaywerFees
{
    NSMutableArray *arr = _dataSourceArrays[0];
    NSString *proString = arr[0];
    NSString *caseString = arr[1];
    
    if (proString.length == 0) {
        [JKPromptView showWithImageName:nil message:LOCSELECTAREA];
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
            
            
            if ([proString isEqualToString:@"新疆维吾尔自治区"]) {
                
                [self xinJiangEventWithArrays:arr];
                
            }else {
                
                LayerFeesModel *model = [[LayerFeesModel alloc] initWithDictionary:_areasDictionary[@"xz1"]];
                
                if ([_isInterval isEqualToString:@"1"]) {
                    //1 是百分比  2百分比区间计算
                    [self calaulateWithMSAndXZCaseWith:model];
                }else {
                    [self percentageRangeCalculationWith:model];
                }

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
            
            if ([proString isEqualToString:@"新疆维吾尔自治区"]) {
                
                [self xinJiangEventWithArrays:arr];
                
            }else {
               
                LayerFeesModel *model = [[LayerFeesModel alloc] initWithDictionary:_areasDictionary[@"ms1"]];
                if ([_isInterval isEqualToString:@"1"]) {
                    [self calaulateWithMSAndXZCaseWith:model];
                }else {
                    [self percentageRangeCalculationWith:model];
                }

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
        [JKPromptView showWithImageName:nil message:LOCSETMONEY];
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
            
            NSString *lastMoneyString =  [NSString stringWithFormat:@"%@ ~ %@元",[QZManager getNewAmountSegmentationWithNumber:lastMoneyMin withDecimal:NO],[QZManager getNewAmountSegmentationWithNumber:lastMoneyMax withDecimal:NO]];
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
        NSString *lastMoneyString = [NSString stringWithFormat:@"%@ ~ %@元",[QZManager getNewAmountSegmentationWithNumber:lastMoneyMin withDecimal:NO],[QZManager getNewAmountSegmentationWithNumber:lastMoneyMax withDecimal:NO]];
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
        [JKPromptView showWithImageName:nil message:LOCSETMONEY];
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
            
            NSString *lastMoneyString = [NSString stringWithFormat:@"%@元",[QZManager getNewAmountSegmentationWithNumber:lastMoney  withDecimal:NO]];
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
        NSString *lastMoneyString = [NSString stringWithFormat:@"%@元",[QZManager getNewAmountSegmentationWithNumber:lastMoney withDecimal:NO]];
        NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
        [_dataSourceArrays addObject:arr2];
        [self reloadTableViewWithAnimation];
    }
}

#pragma mark - 新疆单独算
- (void)xinJiangEventWithArrays:(NSMutableArray *)arrays {
    double money = [arrays[3] doubleValue];
    NSString *lastMoneyString = @"";
    if (money <= 10000.f) {
        
        lastMoneyString = @"500—800元";
    }else if (money> 10000.f && money <= 100000.f){
        
        double mm = (money * 0.05f) + 300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }else if (money> 100000.f && money <= 500000.f){
        
        double mm = (money * 0.04f) + 1300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }else if (money> 500000.f && money <= 1000000.f){
        
        double mm = (money * 0.03f) + 6300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }else if (money> 1000000.f && money <= 5000000.f){
        
        double mm = (money * 0.02f) + 16300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }else if (money> 5000000.f && money <= 10000000.f){
        
        double mm = (money * 0.01f) + 66300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }else {
        
        double mm = (money * 0.005f) + 116300.f;
        lastMoneyString = [NSString stringWithFormat:@"%.0f",mm];
    }
    
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",lastMoneyString, nil];
    [_dataSourceArrays addObject:arr2];
    [self reloadTableViewWithAnimation];

}

#pragma mark - LawyerFeesCellPro
- (void)aboutProperty:(NSInteger)index {
    NSMutableArray *arr1 = _dataSourceArrays[0];
    if (index == 1) {
        [arr1 replaceObjectAtIndex:2 withObject:@"否"];
        [arr1 removeObjectAtIndex:3];
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        if (arr1.count == 3) {
            [arr1 addObject:@""];
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [arr1 replaceObjectAtIndex:2 withObject:@"是"];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArrays.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = self.dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (row == 0) {
            SelectProvinceVC *selectVC = [[SelectProvinceVC alloc] initWithSelectType:FromOther withIsHaveNoGAT:YES];
            selectVC.selectBlock = ^(NSString *province){
                
                weakSelf.areasDictionary = weakSelf.bigDictionary[province];
                weakSelf.isInterval = weakSelf.areasDictionary[@"isInterval"];

                weakSelf.bottomLabel.text = [NSString stringWithFormat:@"根据《%@诉讼费用交纳办法》计算，供您参考",province];
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:province];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            };
            [self presentViewController:selectVC animated:YES completion:nil];
        }else if(row == 1){
            
            __block NSMutableArray *arr1 = _dataSourceArrays[section];
            NSString *lastString = arr1[row];
            ZHPickView *pickView = [[ZHPickView alloc] initWithSelectString:lastString];
            [pickView setDataViewWithItem:@[@"民事案件",@"刑事案件",@"行政案件"] title:@"案件类型"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type) {
                
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
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
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
