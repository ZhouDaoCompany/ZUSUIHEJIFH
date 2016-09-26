//
//  PersonalComputingResultsVC.m
//  ZhouDao
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PersonalComputingResultsVC.h"
#import "ParallaxHeaderView.h"
#import "PersonalHeadView.h"
#import "PersonalInjuryCell.h"
#import "Disability_AlertView.h"

static NSString *const PERSONALRESULTCELL = @"PersonalComputingResultsCellid";

@interface PersonalComputingResultsVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,PersonalHeadViewDelegate,Disability_AlertViewPro>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSourcesArrays;
@property (nonatomic, copy) NSString *allMoneyString;

@end

@implementation PersonalComputingResultsVC
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
    [self setupNaviBarWithTitle:@"计算结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _allMoneyString = _moneyString;
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:_allMoneyString, nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self.dataSourcesArrays addObject:arr1];
    [self.dataSourcesArrays addObject:arr2];

    [self.view addSubview:self.tableView];
//    [_headerView addSubview:[PersonalHeadView instancePersonalHeadViewWithTotalMoney:@"1763514.00" withArea:@"上海" withHK:@"城镇" withItem:@"六级" withGrade:@"六级"]];

}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        [(ParallaxHeaderView*)_tableView.tableHeaderView  layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSourcesArrays count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = _dataSourcesArrays[section];
    return [arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    PersonalInjuryCell *cell = (PersonalInjuryCell *)[tableView dequeueReusableCellWithIdentifier:PERSONALRESULTCELL];
    cell.textField.delegate = self;
    if (_dataSourcesArrays.count >0) {
        [cell settingDetailViewUIWithSection:indexPath.section withRow:indexPath.row WithMutableArrays:_dataSourcesArrays];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:cell.textField];

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0)?[PersonalHeadView instancePersonalHeadViewWithTotalMoney:_allMoneyString withDictionary:_detailDictionary withDelegate:self]:nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0)?145.f:10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark - PersonalHeadViewDelegate
- (void)clickGradeEvent
{
    NSArray *array = _detailDictionary[@"grade"];
    Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:CheckNoEdit withSource:array withDelegate:self];
    [alertView show];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyBoard];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self dismissKeyBoard];
    NSMutableArray *arr = _dataSourcesArrays[1];
    double money = 0.0f;
    for (NSUInteger i = 0; i<arr.count; i++) {
        NSString *valueString = arr[i];
        if (valueString.length >0) {
            money += [valueString doubleValue];
        }
    }
    _allMoneyString = [NSString stringWithFormat:@"%.2f",[_moneyString doubleValue] + money];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
    
    NSMutableArray *arr = _dataSourcesArrays[section];
    [arr replaceObjectAtIndex:row withObject:textField.text];
}

#pragma mark - setter and getter
-(UITableView *)tableView{WEAKSELF;
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[PersonalInjuryCell class] forCellReuseIdentifier:PERSONALRESULTCELL];
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 145)] forSize:CGSizeMake(kMainScreenWidth, 1)];
        _tableView.tableHeaderView = _headerView;
    }
    return _tableView;
}
- (NSMutableArray *)dataSourcesArrays
{
    if (!_dataSourcesArrays) {
        
        _dataSourcesArrays = [NSMutableArray array];
    }
    return _dataSourcesArrays;
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
