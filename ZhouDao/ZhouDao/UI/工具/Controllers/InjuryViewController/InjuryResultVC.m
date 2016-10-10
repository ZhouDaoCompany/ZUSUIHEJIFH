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
#import "TaskModel.h"
#import "ReadViewController.h"
#import "ToolsIntroduceVC.h"

static NSString *const INJURYRESULTCELL = @"injurycellid";

@interface InjuryResultVC ()<UITableViewDataSource,UITableViewDelegate,CalculateShareDelegate>


@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSourceArrays;
@property (strong, nonatomic) UILabel *bottomLabel;

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
    
    
    NSString *pathSource = [[NSBundle mainBundle] pathForResource:@"Areas" ofType:@"plist"];
    NSDictionary *areasDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource];

    NSArray *proviceArr = [areasDictionary allKeys];
    NSString *keyString = @"";
    for (NSUInteger i = 0; i < proviceArr.count; i++) {
        
        keyString = proviceArr[i];
        NSArray *tempArr = areasDictionary[keyString];
        NSArray *cityArr = [[tempArr objectAtIndex:0] allKeys];
        
        for (NSString *cityString in cityArr) {
            
            if ([_detailDictionary[@"city"] isEqualToString:cityString]) {
                
                break;
            }
        }
    }
    NSString *pathSource1 = [[NSBundle mainBundle] pathForResource:@"InjuryInductrial" ofType:@"plist"];
    NSDictionary *bigDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource1];

    __block NSString *contentText = bigDictionary[keyString];
    
    [_tableView setTableFooterView:self.bottomLabel];
    WEAKSELF;
    [_bottomLabel whenCancelTapped:^{
        
        DLog(@"点击跳转");
        if (weakSelf.bottomLabel.text.length >0) {
            ToolsIntroduceVC *vc = [ToolsIntroduceVC new];
            vc.introContent = contentText;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];

}
#pragma mark - event response
- (void)rightBtnAction
{
    CalculateShareView *shareView = [[CalculateShareView alloc] initWithDelegate:self];
    [shareView show];
}
#pragma mark - CalculateShareDelegate
- (void)clickIsWhichOne:(NSInteger)index
{WEAKSELF;
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
        [shareDict setObject:[NSArray arrayWithObjects:@"", nil] forKey:@"conditions"];

        [NetWorkMangerTools shareTheResultsWithDictionary:shareDict RequestSuccess:^(NSString *urlString, NSString *idString) {
            
            if (index == 1) {
                
                NSArray *arrays = [NSArray arrayWithObjects:@"工伤赔偿计算",@"工伤赔偿计算结果",urlString,@"", nil];
                [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                }];

            }else {
                NSString *wordString = [[NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,TOOLSWORDSHAREURL,idString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                TaskModel *model = [TaskModel model];
                model.name=[NSString stringWithFormat:@"工伤赔偿计算结果Word%@.docx",idString];
                model.url= wordString;
                model.content = @"工伤赔偿计算结果Word";
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
- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(00c8aa);
        _bottomLabel.font = Font_12;
        _bottomLabel.text = [NSString stringWithFormat:@"%@工伤赔偿金计算依据，供您参考",_detailDictionary[@"city"]];
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
