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

static NSString *const PERSONALCELL = @"PersonalInjuryCellid";

@interface PersonalInjuryViewController ()<UITableViewDelegate, UITableViewDataSource,Disability_AlertViewPro,PersonalInjuryDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *calculateButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;

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
    PersonalComputingResultsVC *vc = [PersonalComputingResultsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PersonalInjuryDelegate

- (void)optionEventWithCell:(PersonalInjuryCell *)cell withSelecIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSMutableArray *arr1 = _dataSourceArrays[0];

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
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        NSMutableArray *arr1 = _dataSourceArrays[0];

        if (row == 4) {
            DisabilityType type = ([arr1[3] integerValue] == 0)?SelectOnly:DisabilityGradeType;
            
            Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:type withDelegate:self];
            [alertView show];
            
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
#pragma mark - setters and getters
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[PersonalInjuryCell class] forCellReuseIdentifier:PERSONALCELL];
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
