//
//  InjuryViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "InjuryViewController.h"
#import "InjuryViewCell.h"
#import "SelectCityViewController.h"
#import "Disability_AlertView.h"
#import "InjuryResultVC.h"
#define GETFloat(numbers) [NSString stringWithFormat:@"%.2f",numbers]

static NSString *const INJURYCELL = @"injurycellid";

@interface InjuryViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,Disability_AlertViewPro,CalculateShareDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (copy, nonatomic) NSString *idString;

@end

@implementation InjuryViewController

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
- (void)initUI {
    
    if ([PublicFunction ShareInstance].locCity.length > 0) {
        
        NSString *pathSource = [MYBUNDLE pathForResource:@"TheCityList" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSArray *keyArrays = [dictionary allKeys];
        NSString *locCity = [PublicFunction ShareInstance].locCity;
        for (NSString *keyString in keyArrays) {
            
            if ([locCity isEqualToString:keyString]) {
                
                self.idString = dictionary[keyString];
                [self.dataSourceArrays replaceObjectAtIndex:0 withObject:keyString];
                break;
            }
        }
    }
    
    [self setupNaviBarWithTitle:@"工伤赔偿计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
}
#pragma mark - event response
- (void)rightBtnAction {
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index {

    if (index >0) {
        [JKPromptView showWithImageName:nil message:LOCCALCULATESHARE];
        return;
        
    }else {//分享计算器
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,GSPCCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"工伤赔偿计算",@"工伤赔偿计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
    }
    DLog(@"分享的是第几个－－－%ld",index);
}

- (void)calculateAndResetBtnEvent:(UIButton *)btn { WEAKSELF;
    
    [self dismissKeyBoard];
    if (btn.tag == 3034) {
        _dataSourceArrays = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
        [UIView animateWithDuration:.25f animations:^{
            
            [weakSelf.tableView reloadData];
        }];
    }else {
        
        NSArray *alertArrays = @[@"请选择城市",@"请选择伤残等级",@"请输入月薪"];
        for (NSUInteger i = 0; i<_dataSourceArrays.count; i++) {
           
            NSString *tempString = _dataSourceArrays[i];
            if (tempString.length == 0) {
                [JKPromptView showWithImageName:nil message:alertArrays[i]];
                return;
            }
        }
        
        //计算
        
        [self calculationOfDisability];
    }
}
- (void)calculationOfDisability {
    NSMutableDictionary *detailDict = [NSMutableDictionary dictionary];
    
    NSDictionary *levelDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"一级",@"2",@"二级",@"3",@"三级",@"4",@"四级",@"5",@"五级",@"6",@"六级",@"7",@"七级",@"8",@"八级",@"9",@"九级",@"10",@"十级", nil];
    NSString *levelString = _dataSourceArrays[1];
    NSString *cityName = _dataSourceArrays[0];
    double wageMoney = [_dataSourceArrays[2] doubleValue];

    NSUInteger levelInter = [levelDict[levelString] integerValue];

    if (levelInter <5) {
        NSDictionary *blDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0.9",@"一级",@"0.85",@"二级",@"0.8",@"三级",@"0.75",@"四级", nil];
        double bl = [blDict[levelString] doubleValue];
        double months = 27 - (levelInter-1)*2;
        
        //伤残补偿金(元)，伤残津贴，一次性结算，
        double money1 = months * wageMoney;
        double money2 = bl *wageMoney;
        double money3 = money2 *12.f *20.f;
        double allMoney = money1;
        
        //信息
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"伤残补偿金(元)",@"title",GETFloat(money1),@"money", nil];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"伤残津贴",@"title",GETFloat(money2),@"money", nil];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"一次性结算",@"title",GETFloat(money3),@"money", nil];

        NSMutableArray *mutableArrays = [NSMutableArray arrayWithObjects:dict1,dict2,dict3, nil];
        
        [detailDict setObjectWithNullValidate:GETFloat(allMoney) forKey:@"money"];
        [detailDict setObjectWithNullValidate:mutableArrays forKey:@"mutableArrays"];

    }else if (levelInter >= 5 && levelInter <7){
        
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"gongshang.plist"];
        NSDictionary *bigDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSString *keyString = [NSString stringWithFormat:@"%@_%ld",_idString,levelInter];
        NSDictionary *useDict = bigDictionary[keyString];

        
        //医疗补偿金，就业补偿金，伤残补偿金，伤残津贴
        double money1 = 0.0f; double money2 = 0.0f;double money3 = 0.0f;double money4 = 0.0f;

        NSDictionary *blDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0.7",@"五级",@"0.6",@"六级", nil];
        double bl = [blDict[levelString] doubleValue];
        NSDictionary *hisamtDict = useDict[@"hisamt"];
        if ([hisamtDict[@"type"] integerValue] == 1) {
            
            money1 = [hisamtDict[@"month"] doubleValue] * wageMoney;
        }else if([hisamtDict[@"type"] integerValue] == 2){
            
            money1 = [hisamtDict[@"standard"] doubleValue] * [hisamtDict[@"month"] doubleValue];
        }else {
            
            money1 = [hisamtDict[@"fixed"] doubleValue];
        }
        
        NSDictionary *workamtDict = useDict[@"workamt"];
        if ([workamtDict[@"type"] integerValue] == 1) {
            
            money2 = [workamtDict[@"month"] doubleValue] * wageMoney;
        }else if([workamtDict[@"type"] integerValue] == 2){
            
            money2 = [workamtDict[@"standard"] doubleValue] * [workamtDict[@"month"] doubleValue];
        }else {
            
            money2 = [workamtDict[@"fixed"] doubleValue];
        }

        money3 = [useDict[@"injuryamt"] doubleValue] *wageMoney;

        money4 = wageMoney *bl;

        double allMoney = money1 + money2 + money3;
        
        //信息
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"医疗补偿金",@"title",GETFloat(money1),@"money", nil];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"就业补偿金",@"title",GETFloat(money2),@"money", nil];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"伤残补偿金",@"title",GETFloat(money3),@"money", nil];
        NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"伤残津贴",@"title",GETFloat(money4),@"money", nil];

        NSMutableArray *mutableArrays = [NSMutableArray arrayWithObjects:dict1,dict2,dict3,dict4, nil];
        
        [detailDict setObjectWithNullValidate:GETFloat(allMoney) forKey:@"money"];
        [detailDict setObjectWithNullValidate:mutableArrays forKey:@"mutableArrays"];
    }else{
        NSString *pathSource = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"gongshang.plist"];
        NSDictionary *bigDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];
        NSString *keyString = [NSString stringWithFormat:@"%@_%ld",_idString,levelInter];
        NSDictionary *useDict = bigDictionary[keyString];
        
        //医疗补偿金，就业补偿金，伤残补偿金
        double money1 = 0.0f; double money2 = 0.0f; double money3 = 0.0f;
        NSDictionary *hisamtDict = useDict[@"hisamt"];
        if ([hisamtDict[@"type"] integerValue] == 1) {
            
            money1 = [hisamtDict[@"month"] doubleValue] * wageMoney;
        }else if([hisamtDict[@"type"] integerValue] == 2){
            
            money1 = [hisamtDict[@"standard"] doubleValue] * [hisamtDict[@"month"] doubleValue];
        }else {
            
            money1 = [hisamtDict[@"fixed"] doubleValue];
        }

        NSDictionary *workamtDict = useDict[@"workamt"];
        if ([workamtDict[@"type"] integerValue] == 1) {
            
            money2 = [workamtDict[@"month"] doubleValue] * wageMoney;
        }else if([workamtDict[@"type"] integerValue] == 2){
            
            money2 = [workamtDict[@"standard"] doubleValue] * [workamtDict[@"month"] doubleValue];
        }else {
            
            money2 = [workamtDict[@"fixed"] doubleValue];
        }

        
        money3 = [useDict[@"injuryamt"] doubleValue] *wageMoney;
        
        double allMoney = money1 + money2 + money3;

        //信息
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"医疗补偿金",@"title",GETFloat(money1),@"money", nil];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"就业补偿金",@"title",GETFloat(money2),@"money", nil];
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"伤残补偿金",@"title",GETFloat(money3),@"money", nil];
        NSMutableArray *mutableArrays = [NSMutableArray arrayWithObjects:dict1,dict2,dict3, nil];
        
        [detailDict setObjectWithNullValidate:GETFloat(allMoney) forKey:@"money"];
        [detailDict setObjectWithNullValidate:mutableArrays forKey:@"mutableArrays"];
    }
    
    [detailDict setObjectWithNullValidate:cityName forKey:@"city"];
    [detailDict setObjectWithNullValidate:levelString forKey:@"level"];
    [detailDict setObjectWithNullValidate:GETFloat(wageMoney) forKey:@"gongzi"];
    
    InjuryResultVC *vc = [InjuryResultVC new];
    vc.detailDictionary = detailDict;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - Disability_AlertViewPro
- (void)selectCaseType:(NSString *)caseString
{
    [_dataSourceArrays replaceObjectAtIndex:1 withObject:caseString];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    InjuryViewCell *cell = (InjuryViewCell *)[tableView dequeueReusableCellWithIdentifier:INJURYCELL];
    cell.textField.delegate = self;
    [cell settingInjuryViewCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:self.dataSourceArrays];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { WEAKSELF;
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        SelectCityViewController *cityVC = [SelectCityViewController new];
        cityVC.type = InjuryType;
        cityVC.citySelectBlock = ^(NSString *name, NSString *idString){
            
            weakSelf.idString = idString;
            [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:name];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self  presentViewController:cityVC animated:YES completion:^{
        }];
    }else if (row == 1){
        
        Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:SelectOnly withSource:nil withDelegate:self];
        [alertView show];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80.f;
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
    [_dataSourceArrays replaceObjectAtIndex:row withObject:textField.text];
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
        [_tableView registerClass:[InjuryViewCell class] forCellReuseIdentifier:INJURYCELL];
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];
    }
    return _tableView;
}
- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
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
