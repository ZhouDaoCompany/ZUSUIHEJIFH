//
//  ToolsViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ToolsViewController.h"
#import "ToolCollectionViewCell.h"
#import "ToolsWedViewVC.h"
#import "TheContractData.h"
#define toolWidth     [UIScreen mainScreen].bounds.size.width/2.f -0.5f
#define toolHeight    68
static NSString *const toolIdentifier = @"toolIdentifier";
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 1.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;

@interface ToolsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@end

@implementation ToolsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
- (void)initView
{
    [self setupNaviBarWithTitle:@"工具"];
    
    _dataSourceArr = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
    //layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    //self.collectionView.bounces = NO;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:toolIdentifier];
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    
    NSArray *arrays = [USER_D objectForKey:ToolsStorage];
    if (arrays.count >0) {
        [weakSelf.dataSourceArr removeAllObjects];
        [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [weakSelf.dataSourceArr addObject:model];
        }];
        [weakSelf.collectionView reloadData];
    }else{
        [SVProgressHUD show];
    }
    [self loadData];
}
- (void)loadData
{WEAKSELF;
    [NetWorkMangerTools toolsClassRequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataSourceArr removeAllObjects];
        [weakSelf.dataSourceArr addObjectsFromArray:arr];
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
            [weakSelf.dataSourceArr removeAllObjects];
            [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BasicModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [weakSelf.dataSourceArr addObject:model];
            }];
            [weakSelf.collectionView reloadData];
        }
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCollectionViewCell * cell = (ToolCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:toolIdentifier forIndexPath:indexPath];
    
    if (_dataSourceArr.count >0) {
        if ([_dataSourceArr[indexPath.row] isKindOfClass:[BasicModel class]]) {
            [cell setBasicModel:_dataSourceArr[indexPath.row]];
        }else{
            cell.iconImgView.hidden = YES;
            cell.titleLab.hidden = YES;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",(long)indexPath.section,(long)indexPath.row);
    if ([_dataSourceArr[indexPath.row] isKindOfClass:[BasicModel class]]) {
        BasicModel *model = _dataSourceArr[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",kProjectBaseUrl,api_tools,model.py];
        [NetWorkMangerTools apiToolsWith:url RequestSuccess:^(NSString *htmlString) {
            ToolsWedViewVC *vc = [ToolsWedViewVC new];
            vc.url = htmlString;
            vc.tType = FromToolsType;
            vc.navTitle = model.title;
            vc.introContent = model.content;
            [weakSelf.navigationController  pushViewController:vc animated:YES];
        }];
        [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
//        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
