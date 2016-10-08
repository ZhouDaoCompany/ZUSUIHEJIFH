//
//  InjuryResultVC.m
//  ZhouDao
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "InjuryResultVC.h"
#import "InjuryHeadView.h"
#import "ParallaxHeaderView.h"
#import "InjuryViewCell.h"

static NSString *const INJURYRESULTCELL = @"injurycellid";

@interface InjuryResultVC ()<UITableViewDataSource,UITableViewDelegate,CalculateShareDelegate>


@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;

@end

@implementation InjuryResultVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"计算结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];

    self.dataSourceArrays = _detailDictionary[@"mutableArrays"];
    
    [self.view addSubview:self.tableView];
}
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
        
        NSMutableDictionary *shareDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"share-gongshangpeichang",@"type", nil];

        NSMutableArray *resultArr = [NSMutableArray arrayWithObjects:_detailDictionary[@"money"],_detailDictionary[@"city"],_detailDictionary[@"level"],_detailDictionary[@"gongzi"], nil];
        for (NSUInteger i = 0; i<_dataSourceArrays.count; i++) {
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
            InjuryViewCell *cell = (InjuryViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
            DLog(@"999--:%@",cell.titleLab.text);
            
            NSString *tempString = [NSString stringWithFormat:@"%@-%@",cell.titleLab.text,_dataSourceArrays[i]];
            [resultArr addObject:tempString];
        }
        [shareDict setObject:resultArr forKey:@"results"];
        [shareDict setObject:[NSArray array] forKey:@"conditions"];

        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            NSArray *arrays;
            if (index == 1) {
                
                arrays = [NSArray arrayWithObjects:@"工伤赔偿计算",@"工伤赔偿计算结果",urlString,@"", nil];
            }else {
                arrays = [NSArray arrayWithObjects:@"工伤赔偿计算",@"工伤赔偿计算结果word",[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString],@"", nil];
            }

            [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            }];
            
            
        } fail:^{
            
        }];
        
    }else {//分享计算器
        NSString *calculateUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,GSPCCulate];
        NSArray *arrays = [NSArray arrayWithObjects:@"工伤赔偿计算",@"工伤赔偿计算器",calculateUrl,@"", nil];
        [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
            
        }];
        
    }
    DLog(@"分享的是第几个－－－%ld",index);
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    InjuryViewCell *cell = (InjuryViewCell *)[tableView dequeueReusableCellWithIdentifier:INJURYRESULTCELL];
    
    if (_dataSourceArrays.count >0) {
        NSDictionary *dict = _dataSourceArrays[indexPath.row];
        [cell settingUIDetailWithDictionary:dict];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0)?[InjuryHeadView instancePersonalHeadViewWithDictionary:_detailDictionary]:nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark - setter and getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[InjuryViewCell class] forCellReuseIdentifier:INJURYRESULTCELL];
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 145)] forSize:CGSizeMake(kMainScreenWidth, 1)];
        _tableView.tableHeaderView = _headerView;
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
