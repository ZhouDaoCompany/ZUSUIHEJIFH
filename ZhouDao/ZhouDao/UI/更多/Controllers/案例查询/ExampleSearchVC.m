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
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
#pragma mark - life cycle
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
        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:self.falseImgView];
        [windows sendSubviewToBack:self.falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
    }
    self.navigationController.navigationBarHidden = YES;
    
    WEAKSELF;
    self.collectionHeadView.searchBlock = ^(NSString *typeString){
        
        if ([typeString isEqualToString:@"高级"]) {
//            SeniorViewController *searchVC = [SeniorViewController new];
//            [AnimationTools makeAnimationFade:searchVC :weakSelf.navigationController];
        }else{
            OrdinaryVC *VC = [OrdinaryVC new];
            [AnimationTools makeAnimationFade:VC :weakSelf.navigationController];
        }
    };

    [self.view addSubview:self.collectionView];

    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    
    NSArray *arrays = [USER_D objectForKey:ExampleSearchStorage];
    if (arrays.count >0) {
        [self.dataSourceArr removeAllObjects];
        [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ExampleData *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [weakSelf.dataSourceArr addObject:model];
        }];
        [weakSelf.collectionView reloadData];
    }else{
        [MBProgressHUD showMBLoadingWithText:nil];
    }
    [self loadData];

}
- (void)loadData
{WEAKSELF;
    [NetWorkMangerTools loadCutInspectionRequestSuccess:^(NSArray *arr) {
        if (arr.count >0) {
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.dataSourceArr addObjectsFromArray:arr];
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
            [weakSelf.dataSourceArr removeAllObjects];
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
    return [self.dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GovCollectionViewCell * cell = (GovCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ExampleSearchIdentifer forIndexPath:indexPath];
    
    if (self.dataSourceArr.count >0) {
        [cell setExampleModel:self.dataSourceArr[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

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
        [headerView addSubview:self.collectionHeadView];//头部广告栏
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
#pragma mark - setter and getter
- (UIImageView *)falseImgView
{
    if (!_falseImgView) {
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
    }
    return _falseImgView;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64.f , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[GovCollectionViewCell class] forCellWithReuseIdentifier:ExampleSearchIdentifer];
        [_collectionView registerClass:[ExampleSearView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];
    }
    return _collectionView;
}
- (NSMutableArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}
- (ExampleSearView *)collectionHeadView
{
    if (!_collectionHeadView) {
        _collectionHeadView = [[ExampleSearView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 197.f)];
    }
    return _collectionHeadView;
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
