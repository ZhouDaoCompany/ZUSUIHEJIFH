//
//  GovermentVC.m
//  ZhouDao
//
//  Created by cqz on 16/4/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovermentVC.h"
#import "GovCollectionViewCell.h"
#import "GovData.h"
#import "GovernmentListVC.h"
#import "SelectProvinceVC.h"

#define govWidth     [UIScreen mainScreen].bounds.size.width/4.f -1.f
#define govHeight    93.5f
static NSString *const headerIdentifier = @"header";
static NSString *const govIdentifier = @"govIdentifier";
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 1.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;

@interface GovermentVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasourceArr;
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic, strong) UIImageView *collectionHeadView;
@property (nonatomic, copy) NSString *showLocal;
@property (nonatomic, copy) NSString *provString;

@end

@implementation GovermentVC
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)initView
{
    [self setupNaviBarWithTitle:@"司法机关"];
    
    if ([PublicFunction ShareInstance].locProv.length >0) {
        _provString = [PublicFunction ShareInstance].locProv;
        if ([QZManager isString:_provString withContainsStr:@"内蒙古"]== YES || [QZManager isString:_provString withContainsStr:@"黑龙江"]== YES) {
            _showLocal = [_provString  substringToIndex:3];
        } else {
            _showLocal = [_provString  substringToIndex:2];
        }
    }else {
        _provString = @"上海";
        _showLocal =  @"上海";
    }
    
    [self setupNaviBarWithBtn:NaviRightBtn title:_showLocal img:@"gov_SelectLoc"];
    self.rightBtn.titleLabel.font = Font_15;

    if (_Govtype == GovFromHome) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    }else{

        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:self.falseImgView];
        [windows sendSubviewToBack:self.falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
    }
    self.navigationController.navigationBarHidden = YES;

    [self.view addSubview:self.collectionView];

    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    
    NSArray *arrays = [USER_D objectForKey:GovermentStorage];
    if (arrays.count >0) {
        [self.datasourceArr removeAllObjects];
        [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            GovData *model = [[GovData alloc] initWithDictionary:obj];
            [weakSelf.datasourceArr addObject:model];
        }];
        [weakSelf.collectionView reloadData];
    }
    [self loadData];

    
//    [self.collectionView.mj_header beginRefreshing];
}
- (void)loadData
{WEAKSELF;
    [NetWorkMangerTools goverMentFirstClassListRequestSuccess:^(NSArray *arr) {
        
        if (arr.count>0) {
            [weakSelf.datasourceArr removeAllObjects];
            [arr enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GovData *model = [[GovData alloc] initWithDictionary:obj];
                [weakSelf.datasourceArr addObject:model];
            }];
        }
        [USER_D setObject:arr forKey:GovermentStorage];
        [USER_D synchronize];
        [weakSelf.collectionView reloadData];
    } fail:^{
        NSArray *arrays = [USER_D objectForKey:GovermentStorage];
        if (arrays.count >0) {
            [weakSelf.datasourceArr removeAllObjects];
            [arrays enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GovData *model = [[GovData alloc] initWithDictionary:obj];
                [weakSelf.datasourceArr addObject:model];
            }];
            [weakSelf.collectionView reloadData];
        }
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.datasourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GovCollectionViewCell * cell = (GovCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:govIdentifier forIndexPath:indexPath];
    if (self.datasourceArr.count >0) {
        [cell setDataModel:_datasourceArr[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    GovernmentListVC *vc = [GovernmentListVC new];
    GovData *model = _datasourceArr[indexPath.row];
    vc.nameString = model.ctname;
    vc.prov = _provString;
    vc.showLocal = _showLocal;
    vc.localBlock = ^(NSString *prov, NSString *local){
        
        weakSelf.provString = prov;
        weakSelf.showLocal  = local;
        [weakSelf.rightBtn setTitle:local forState:0];
    };
    [self.navigationController pushViewController:vc animated:YES];
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",(long)indexPath.section,indexPath.row);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                                UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [headerView addSubview:self.collectionHeadView];//头部广告栏
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kMainScreenWidth, 150.f);
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
    if (_Govtype == GovFromHome) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)rightBtnAction
{WEAKSELF;
    SelectProvinceVC *selectVC = [SelectProvinceVC new];
    selectVC.selectBlock = ^(NSString *province, NSString *local){
        
        weakSelf.showLocal = local;
        weakSelf.provString = province;
        [weakSelf.rightBtn setTitle:local forState:0];
    };
    [self presentViewController:selectVC animated:YES completion:nil];
}
#pragma amrk - setter and getter
- (NSMutableArray *)datasourceArr
{
    if (!_datasourceArr) {
        _datasourceArr = [NSMutableArray array];
    }
    return _datasourceArr;
}
- (UIImageView *)falseImgView
{
    if (!_falseImgView) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
    }
    return _falseImgView;
}
- (UIImageView *)collectionHeadView
{
    if (!_collectionHeadView) {
        _collectionHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 150.f)];
        _collectionHeadView.image = [UIImage imageNamed:@"laws_GovSearch.jpg"];
    }
    return _collectionHeadView;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
        //    layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 150);
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //self.collectionView.bounces = NO;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[GovCollectionViewCell class] forCellWithReuseIdentifier:govIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
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
