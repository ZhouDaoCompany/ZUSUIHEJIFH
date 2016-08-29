//
//  ToolsViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsViewController.h"
#import "ToolCollectionViewCell.h"
#import "ToolsWedViewVC.h"
#import "TheContractData.h"
#import "LewReorderableLayout.h"

#import "LawyerFeesVC.h"
#import "OverdueViewController.h"
#import "CourtViewController.h"
#import "DivorceViewController.h"
#import "LiXiViewController.h"

#define toolWidth     [UIScreen mainScreen].bounds.size.width/2.f -0.5f
#define toolHeight    68
static NSString *const toolIdentifier = @"toolIdentifier";
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 1.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;

@interface ToolsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,LewReorderableLayoutDelegate, LewReorderableLayoutDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;

@end

@implementation ToolsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"工具"];
    [self.view addSubview:self.collectionView];
    [self loadDataFromTheLocal];
}
#pragma mark - 请求
- (void)loadDataFromTheLocal
{
    NSArray *arrays = [USER_D objectForKey:TOOLSTHESORT];
    if (arrays.count >0) {
        [self.dataSourceArrays removeAllObjects];
        [self.dataSourceArrays addObjectsFromArray:arrays];
    }
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSourceArrays count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCollectionViewCell * cell = (ToolCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:toolIdentifier forIndexPath:indexPath];
    
    if (self.dataSourceArrays.count >0) {
        [cell settingToolsUIWithName:self.dataSourceArrays[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",(long)indexPath.section,(long)indexPath.row);
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    NSString *titleString = _dataSourceArrays[indexPath.row];
    if ([titleString isEqualToString:@"裁决书逾期利息计算器"]) {
        
        OverdueViewController *overdueVC = [OverdueViewController new];
        [self.navigationController pushViewController:overdueVC animated:YES];
    }else if ([titleString isEqualToString:@"律师费计算器"]){
        
        LawyerFeesVC *vc = [LawyerFeesVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleString isEqualToString:@"法院受理费计算器"]){
        
        CourtViewController *vc = [CourtViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleString isEqualToString:@"离婚房产分割计算器"]){
        DivorceViewController *vc = [DivorceViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([titleString isEqualToString:@"利息计算器"]){
        LiXiViewController *vc = [LiXiViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(toolWidth, toolHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsHorizonMargin;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsSection;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row == 11)?NO:YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return (toIndexPath.row == 11)?NO:YES;
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *name = _dataSourceArrays[fromIndexPath.row];
    [_dataSourceArrays removeObjectAtIndex:fromIndexPath.row];
    [_dataSourceArrays insertObject:name atIndex:toIndexPath.row];
    
    [USER_D setObject:_dataSourceArrays forKey:TOOLSTHESORT];
    [USER_D synchronize];
}
#pragma mark - setter and getter
- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays =  [NSMutableArray arrayWithObjects:@"日期计算器",@"人身损害赔偿计算器",@"违约金计算器",@"利息计算器",@"律师费计算器",@"离婚房产分割计算器",@"经济赔偿金计算器",@"工伤赔偿计算器",@"房屋还贷计算器",@"法院受理费计算器",@"裁决书逾期利息计算器",@"", nil];
    }
    return _dataSourceArrays;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        LewReorderableLayout *layout = [[LewReorderableLayout alloc] init];
        layout.delegate = self;
        layout.dataSource = self;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-113.f) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:toolIdentifier];
    }
    return _collectionView;
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
