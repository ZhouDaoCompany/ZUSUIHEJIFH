//
//  PersonalInjuryViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PersonalInjuryViewController.h"
#import "PersonalInjuryCell.h"
#import "Disability_AlertView.h"
#import "PersonalComputingResultsVC.h"
#import "SelectProvinceVC.h"

static NSString *const PERSONALCELL = @"PersonalInjuryCellid";

@interface PersonalInjuryViewController ()<UITableViewDelegate, UITableViewDataSource,Disability_AlertViewPro,PersonalInjuryDelegate>
{
    BOOL _flag[3];
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) NSMutableDictionary *cityDictionnary;//城镇
@property (strong, nonatomic) NSMutableDictionary *ruralDictionnary;//农村

@end

@implementation PersonalInjuryViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"0",@"0",@"0",@"", nil];
    [self.dataSourceArrays addObject:arr1];

    [self setupNaviBarWithTitle:@"人身损害赔偿计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self.view addSubview:self.tableView];
}
#pragma mark - event response

- (void)calculateAndResetBtnEvent:(UIButton *)btn
{
    if (btn.tag == 3089 ) {
        
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"0",@"0",@"0",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadData];
    }else {
       
        NSMutableArray *arr1 = _dataSourceArrays[0];
        
        if ([arr1[4] isKindOfClass:[NSString class]]) {
            for (NSUInteger i = 0; i<arr1.count; i++) {
                NSString *valueString = arr1[i];
                if (valueString.length == 0) {
                    NSString *alertString = (i == 0)?@"请选择地区":@"请选择伤残等级";
                    [JKPromptView showWithImageName:nil message:alertString];
                    return;
                }
            }
        }
        
        [self formulaToCalculateWithArrays:arr1];
    }
}
#pragma mark - formula to calculate
- (void)formulaToCalculateWithArrays:(NSMutableArray *)arrays
{
    NSString *name = arrays[0];
    double money = 0.0f;
    double allMoney = 0.0f;
    money = (_flag[0] == NO)?[self.cityDictionnary[name] doubleValue]:[self.ruralDictionnary[name] doubleValue];
    if (_flag[1] == YES) {
        
        allMoney = money *20;
    }else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"一级",@"0.9",@"二级",@"0.8",@"三级",@"0.7",@"四级",@"0.6",@"五级",@"0.5",@"六级",@"0.4",@"七级",@"0.3",@"八级",@"0.2",@"九级",@"0.1",@"十级", nil];

        if (_flag[2] == NO) {
            
            allMoney = money *[dict[arrays[4]] doubleValue] *20;
        }else{
            
            NSArray *cendArrays = arrays[4];
            //从小到大排序
            [cendArrays sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *objcDict1, NSDictionary *objcDict2) {
                if ([objcDict1[@"row"] intValue] < [objcDict2[@"row"] intValue])
                {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }];
            
            __block double disabilityLevel = 0.0f;//伤残等级
            [cendArrays enumerateObjectsUsingBlock:^(NSDictionary *levelDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *levelString = levelDict[@"level"];
                double several = [levelDict[@"several"] doubleValue];
                if (idx == 0) {
                    disabilityLevel += [dict[levelString] doubleValue] + [dict[levelString] doubleValue] * (several - 1.f) *0.1f;
                }else {
                    disabilityLevel +=  [dict[levelString] doubleValue] *several *0.1f;
                }
            }];
            
            if (disabilityLevel >1.f) {
                disabilityLevel = 1.f;
            }
            allMoney = money *disabilityLevel *20;
            DLog(@"cendArrays--------%@",cendArrays);
        }
    }
    
    PersonalComputingResultsVC *vc = [PersonalComputingResultsVC new];
    vc.isDie = _flag[1];
    vc.hkString = (_flag[0] == NO)?@"城镇":@"农村";
    vc.cityString = arrays[0];
    vc.moneyString = [NSString stringWithFormat:@"%.2f",allMoney];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - PersonalInjuryDelegate

- (void)optionEventWithCell:(PersonalInjuryCell *)cell withSelecIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSMutableArray *arr1 = _dataSourceArrays[0];

    _flag[row - 1] = (index == 0)?YES:NO;
    if (row == 2) {
        if (index == 0) {
            if (arr1.count == 3) {
                [arr1 addObject:@"0"];
                [arr1 addObject:@""];
                [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }else {
            
            if (arr1.count == 5) {
                [arr1 removeObjectAtIndex:3];
                [arr1 removeObjectAtIndex:3];
                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }

    }else{
        [arr1 replaceObjectAtIndex:row withObject:[NSString stringWithFormat:@"%ld",index]];
        
        if (row == 3) {
            
            if (index == 0) {
                
                if ([arr1[4] isKindOfClass:[NSArray class]]) {
                    [arr1 replaceObjectAtIndex:4 withObject:@""];
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }else{
                
                if ([arr1[4] isKindOfClass:[NSString class]]) {
                    [arr1 replaceObjectAtIndex:4 withObject:[NSArray array]];
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }
}
#pragma mark - Disability_AlertViewPro
- (void)selectCaseType:(NSString *)caseString
{
    NSMutableArray *arr1 = _dataSourceArrays[0];
    [arr1 replaceObjectAtIndex:4 withObject:caseString];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)selectDisableGrade:(NSArray *)gradeArrays
{
    NSMutableArray *arr1 = _dataSourceArrays[0];
    [arr1 replaceObjectAtIndex:4 withObject:gradeArrays];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSourceArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = self.dataSourceArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PersonalInjuryCell *cell = (PersonalInjuryCell *)[tableView dequeueReusableCellWithIdentifier:PERSONALCELL];
    [cell settingPersonalCellUIWithSection:indexPath.section withRow:indexPath.row withNSMutableArray:_dataSourceArrays withDelegate:self];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSInteger row = indexPath.row;
    
    if (row == 0){
        
        SelectProvinceVC *selectVC = [SelectProvinceVC new];
        selectVC.isNoTW = YES;
        selectVC.selectBlock = ^(NSString *string,NSString *str){
            
            NSMutableArray *arr1 = weakSelf.dataSourceArrays[0];
            [arr1 replaceObjectAtIndex:row withObject:string];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self presentViewController:selectVC animated:YES completion:nil];
    }else if (row == 4){
        NSMutableArray *arr1 = _dataSourceArrays[0];

        DisabilityType type = ([arr1[3] integerValue] == 0)?SelectOnly:DisabilityGradeType;
        
        NSArray *array = ([arr1[3] integerValue] == 0)?nil:arr1[4];
        Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:type withSource:array withDelegate:self];
        [alertView show];
        
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
//    if (indexPath.section == 0 && indexPath.row == 4) {
//        NSMutableArray *arr1 = _dataSourceArrays[0];
//        if ([arr1[4] isKindOfClass:[NSArray class]]) {
//            NSArray *array = arr1[4];
//            float height = [array count]*25 + 5.f;
//            return (height > 45.f)?height:45.f;
//        }
//    }
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
#pragma mark - setters and getters
-(UITableView *)tableView{WEAKSELF;
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[PersonalInjuryCell class] forCellReuseIdentifier:PERSONALCELL];
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
- (NSMutableDictionary *)cityDictionnary
{
    if (!_cityDictionnary) {
        _cityDictionnary = CITYDICTIONARY;
    }
    return _cityDictionnary;
}
- (NSMutableDictionary *)ruralDictionnary{
    if (!_ruralDictionnary) {
        _ruralDictionnary = RURALDICTIONARY;
    }
    return _ruralDictionnary;
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
        _calculateButton.tag = 3088;
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
        _resetButton.tag = 3089;
        [_resetButton addTarget:self action:@selector(calculateAndResetBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
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
