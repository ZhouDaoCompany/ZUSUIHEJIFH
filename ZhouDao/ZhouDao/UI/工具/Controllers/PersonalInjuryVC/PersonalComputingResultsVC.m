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
#import "TaskModel.h"
#import "ReadViewController.h"
#import "ToolsIntroduceVC.h"

static NSString *const PERSONALRESULTCELL = @"PersonalComputingResultsCellid";

@interface PersonalComputingResultsVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,PersonalHeadViewDelegate,Disability_AlertViewPro,CalculateShareDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSourcesArrays;
@property (nonatomic, copy) NSString *allMoneyString;
@property (copy, nonatomic) UIView *bottomView;

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
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];

    _allMoneyString = _moneyString;
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:_moneyString, nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self.dataSourcesArrays addObject:arr1];
    [self.dataSourcesArrays addObject:arr2];

    [self.view addSubview:self.tableView];
    
    [_tableView setTableFooterView:self.bottomView];

    NSString *pathSource1 = [MYBUNDLE pathForResource:@"CalculationBasis" ofType:@"plist"];
    NSDictionary *bigDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource1];

    __block NSString *contentText = bigDictionary[@"人身损害赔偿计算器"];

    WEAKSELF;
    [_bottomView whenCancelTapped:^{
        
        ToolsIntroduceVC *vc = [ToolsIntroduceVC new];
        vc.introContent = contentText;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f)];
        _bottomView.backgroundColor = [UIColor clearColor];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kMainScreenWidth-20, 40)];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.numberOfLines = 0;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = hexColor(00c8aa);
        label2.font = Font_12;
        label2.text = @"根据《最高人民法院关于审理人身损害赔偿案件适用法律若干问题的解释》等相关法律法规的规定";
        [_bottomView addSubview:label2];
    }
    return _bottomView;
}

#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}

#pragma mark - 分享
- (void)rightBtnAction
{
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index
{WEAKSELF;
    if (index >0) {
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-renshensunhaipeichangjieguo",@"type", nil];
        
        NSString *item = _detailDictionary[@"item"];
        NSMutableString *levelString = [[NSMutableString alloc] init];
        NSString *itemString = @"";
        if (_detailDictionary.count == 2) {
            
            itemString = @"死亡";
            [levelString setString:@"一级"];
        }else {
            
            if ([item isEqualToString:@"单级"]) {
                
                itemString = @"单级";
                [levelString setString:_detailDictionary[@"grade"]];
            }else {
                
                itemString = @"多级";

                NSArray *levelArr = _detailDictionary[@"grade"];
                
                for (NSDictionary *dict in levelArr) {
                    
                    [levelString appendString:[NSString stringWithFormat:@"%@级:%@处 ",dict[@"level"],dict[@"several"]]];
                }
            }

        }

        NSMutableArray *resultArr = [NSMutableArray arrayWithObjects:_allMoneyString,_detailDictionary[@"area"],_detailDictionary[@"hk"],itemString,levelString,_moneyString, nil];

        NSMutableArray *arr2 = _dataSourcesArrays[1];

        for (NSUInteger i = 0; i<arr2.count; i++) {
            
            [resultArr addObject:arr2[i]];
        }
        [shareDict setObject:resultArr forKey:@"results"];
        [shareDict setObject:[NSArray arrayWithObjects:@"", nil] forKey:@"conditions"];
        
        
        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            if (index == 1) {
                
                NSArray *arrays = [NSArray arrayWithObjects:@"人身损害赔偿计算",@"人身损害赔偿计算结果",urlString,@"", nil];
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];

            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"人身损害赔偿计算结果Word%@.docx",idString];
                model.url= wordString;
                model.content = @"人身损害赔偿计算结果Word";
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
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,RSSHCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"人身损害赔偿计算",@"人身损害赔偿计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
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
