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
    [self loadData];
}
#pragma mark - 请求
- (void)loadData
{WEAKSELF;
    
    NSArray *arrays = [USER_D objectForKey:ToolsStorage];
    if (arrays.count >0) {
        [weakSelf.dataSourceArrays removeAllObjects];
        [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [weakSelf.dataSourceArrays addObject:model];
        }];
        [weakSelf.collectionView reloadData];
    }else{
        [MBProgressHUD showMBLoadingWithText:nil];
    }
    
    [NetWorkMangerTools toolsClassRequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArrays removeAllObjects];
        [weakSelf.dataSourceArrays addObjectsFromArray:arr];
        [weakSelf.collectionView reloadData];
        NSMutableArray *arrays = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(BasicModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
            [arrays addObject:data];
        }];
        [USER_D setObject:arrays forKey:ToolsStorage];
        [USER_D synchronize];
    } fail:^{
        NSArray *arrays = [USER_D objectForKey:ToolsStorage];
        if (arrays.count >0) {
            [weakSelf.dataSourceArrays removeAllObjects];
            [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [weakSelf.dataSourceArrays addObject:model];
            }];
            [weakSelf.collectionView reloadData];
        }
    }];
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
        if ([self.dataSourceArrays[indexPath.row] isKindOfClass:[BasicModel class]]) {
            [cell setBasicModel:self.dataSourceArrays[indexPath.row]];
        }else{
            [cell theNewCalculatorWithName:@"律师费计算"];
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",(long)indexPath.section,(long)indexPath.row);
    
    if (indexPath.row <7) {
        if ([_dataSourceArrays[indexPath.row] isKindOfClass:[BasicModel class]]) {
            
            [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
            BasicModel *model = _dataSourceArrays[indexPath.row];
            ToolsWedViewVC *vc = [ToolsWedViewVC new];
            vc.url = [NSString stringWithFormat:@"ToolsCalculate_%@",model.py];;
            vc.tType = FromToolsType;
            vc.navTitle = model.title;
            vc.imgUrlString = model.app_icon;
            vc.introContent = model.content;
            [weakSelf.navigationController  pushViewController:vc animated:YES];
        }
    }else {
        
        LawyerFeesVC *vc = [LawyerFeesVC new];
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
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if ([_dataSourceArrays[fromIndexPath.row] isKindOfClass:[BasicModel class]]) {
        
        BasicModel *model = _dataSourceArrays[fromIndexPath.row];
        [_dataSourceArrays removeObjectAtIndex:fromIndexPath.item];
        [_dataSourceArrays insertObject:model atIndex:toIndexPath.item];
    }else {
        NSString *name = _dataSourceArrays[fromIndexPath.row];
        [_dataSourceArrays removeObjectAtIndex:fromIndexPath.row];
        [_dataSourceArrays insertObject:name atIndex:toIndexPath.row];
    }
}
#pragma mark - setter and getter
- (NSMutableArray *)dataSourceArrays
{
    if (!_dataSourceArrays) {
        _dataSourceArrays = [NSMutableArray array];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:toolIdentifier];
        WEAKSELF;
       _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf loadData];
        }];
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
