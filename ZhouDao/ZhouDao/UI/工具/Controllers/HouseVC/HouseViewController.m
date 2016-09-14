//
//  HouseViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

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
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self.dataSourceArrays addObject:arr1];
    [self.dataSourceArrays addObject:arr2];

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
        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
        [_dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
        [_tableView reloadData];
    }
}
- (void)rightBtnAction
{
    HouseDetailVC *vc = [HouseDetailVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)reloadTableViewWithAnimation
{WEAKSELF;
    
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.tableView reloadData];
    }];
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
    HouseViewCell *cell = (HouseViewCell *)[tableView dequeueReusableCellWithIdentifier:HOUSECELL];
    cell.textField.delegate = self;
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
    
    if (row == 0) {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"公积金贷款",@"商业贷款",@"组合贷款"] title:@"贷款类型"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            NSMutableArray *temArr = weakSelf.dataSourceArrays[section];
            [temArr replaceObjectAtIndex:row withObject:selectedStr];

            if ([selectedStr isEqualToString:@"组合贷款"]) {
                
                if (temArr.count !=7) {
                    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:selectedStr,@"",@"",@"",@"",temArr[temArr.count -2],[temArr lastObject], nil];
                    [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                }
            }else{
                if (temArr.count == 7) {
                    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:selectedStr,@"",@"",@"",temArr[temArr.count -2],[temArr lastObject], nil];
                    [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                }
            }
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };
 
    }else if (row == 1){
        
        if (![ _dataSourceArrays[section][0] isEqualToString:@"组合贷款"]) {
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"按贷款额度计算",@"按面积计算"] title:@"计算方式"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                NSMutableArray *temArr = weakSelf.dataSourceArrays[section];
                [temArr replaceObjectAtIndex:row withObject:selectedStr];
                
                if ([selectedStr isEqualToString:@"按贷款额度计算"]) {
                    if (temArr.count == 9) {
                        
                        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:temArr[0],selectedStr,@"",temArr[temArr.count -3],temArr[temArr.count -2],[temArr lastObject], nil];
                        [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                    }
                }else{
                    if (temArr.count == 6) {
                        NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:temArr[0],selectedStr,@"",@"",@"",@"",temArr[temArr.count -3],temArr[temArr.count -2],[temArr lastObject], nil];
                        [weakSelf.dataSourceArrays replaceObjectAtIndex:0 withObject:arr1];
                    }
                }
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
        
    }else if (row == [_dataSourceArrays[section] count] - 2){
       
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"1.1倍",@"1.2倍",@"5倍"] title:@"年利率 (%)"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
            [arr1 replaceObjectAtIndex:row withObject:selectedStr];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        };

    }else if ([_dataSourceArrays[section][0] isEqualToString:@"组合贷款"]){
        if (row == 2) {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"1.1倍",@"1.2倍",@"5倍"] title:@"年利率 (%)"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
    }else{
        
        if (row == [_dataSourceArrays[section] count] - 3) {
            
            ZHPickView *pickView = [[ZHPickView alloc] init];
            NSMutableArray *yearArr = [NSMutableArray array];
            for (NSUInteger i = 1; i<31; i++) {
                [yearArr addObject:[NSString stringWithFormat:@"%ld年",i]];
            }
            [pickView setDataViewWithItem:yearArr title:@"期限"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            };
        }else if ([_dataSourceArrays[section][0] isEqualToString:@"按面积计算"]) {
            
            if (row == 5) {
                ZHPickView *pickView = [[ZHPickView alloc] init];
                [pickView setDataViewWithItem:@[@"1成",@"2成",@"3成"] title:@"首付"];
                [pickView showPickView:self];
                pickView.block = ^(NSString *selectedStr,NSString *type)
                {
                    NSMutableArray *arr1 = weakSelf.dataSourceArrays[section];
                    [arr1 replaceObjectAtIndex:row withObject:selectedStr];
                    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                };
            }
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
- (void)optionEvent:(NSInteger)section withCell:(HouseViewCell *)cell
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
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
