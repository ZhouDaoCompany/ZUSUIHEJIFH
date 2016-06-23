//
//  ExampleSearchVC.m
//  ZhouDao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ExampleSearchVC.h"
#import "ExampleSearView.h"
#import "GovCollectionViewCell.h"
#import "ExampleListVC.h"
//#import "SeniorViewController.h"//高级搜素
#import "OrdinaryVC.h"//普通搜索

static NSString *const HeaderIdentifier = @"headerid";
static NSString *const ExampleSearchIdentifer = @"ExampleSearchIdentifer";
#define govWidth     [UIScreen mainScreen].bounds.size.width/4.f -1.f
#define govHeight    93.5f
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 1.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;

@interface ExampleSearchVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;//案件类型
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) ExampleSearView *collectionHeadView;
@end

@implementation ExampleSearchVC
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [_falseImgView removeFromSuperview];
    _falseImgView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"案例查询"];
    if (_sType == SearchFromHome) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    }else{
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:_falseImgView];
        [windows sendSubviewToBack:_falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
    }
    self.navigationController.navigationBarHidden = YES;
    
    _dataSourceArr = [NSMutableArray array];
    _collectionHeadView = [[ExampleSearView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 197.f)];
    WEAKSELF;
    _collectionHeadView.searchBlock = ^(NSString *typeString){
        
        if ([typeString isEqualToString:@"高级"]) {
//            SeniorViewController *searchVC = [SeniorViewController new];
//            [AnimationTools makeAnimationFade:searchVC :weakSelf.navigationController];
        }else{
            OrdinaryVC *VC = [OrdinaryVC new];
            [AnimationTools makeAnimationFade:VC :weakSelf.navigationController];
        }
    };

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.f , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[GovCollectionViewCell class] forCellWithReuseIdentifier:ExampleSearchIdentifer];
    [self.collectionView registerClass:[ExampleSearView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
//    [self.collectionView.mj_header beginRefreshing];
    
    NSArray *arrays = [USER_D objectForKey:ExampleSearchStorage];
    if (arrays.count >0) {
        [_dataSourceArr removeAllObjects];
        [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ExampleData *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
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
    [NetWorkMangerTools loadCutInspectionRequestSuccess:^(NSArray *arr) {
        if (arr.count >0) {
            [_dataSourceArr removeAllObjects];
            [_dataSourceArr addObjectsFromArray:arr];
            [weakSelf.collectionView reloadData];
            NSMutableArray *arrays = [NSMutableArray array];
            [arr enumerateObjectsUsingBlock:^(ExampleData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
                [arrays addObject:data];
            }];
            [USER_D setObject:arrays forKey:ExampleSearchStorage];
            [USER_D synchronize];
        }
    } fail:^{
        NSArray *arrays = [USER_D objectForKey:ExampleSearchStorage];
        if (arrays.count >0) {
            [_dataSourceArr removeAllObjects];
            [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ExampleData *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
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
    GovCollectionViewCell * cell = (GovCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ExampleSearchIdentifer forIndexPath:indexPath];
    
    if (_dataSourceArr.count >0) {
        [cell setExampleModel:_dataSourceArr[indexPath.row]];
    }
    return cell;
}
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataSourceArr.count >0) {
        ExampleData *model = _dataSourceArr[indexPath.row];
        ExampleListVC *vc = [ExampleListVC new];
        vc.titString = [NSString stringWithFormat:@"%@案例",model.name];
        vc.idString = model.id;
        vc.exampleType = FromComType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        [headerView addSubview:_collectionHeadView];//头部广告栏
        return headerView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kMainScreenWidth, 197.f);
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(govWidth, govHeight);
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
#pragma mark -UIButtonEvent
- (void)leftBtnAction
{
    if (_sType == SearchFromHome) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
