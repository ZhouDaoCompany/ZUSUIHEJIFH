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
#import "BaseRightBtn.h"
#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"

#define govWidth     [UIScreen mainScreen].bounds.size.width/4.f -1.f
#define govHeight    93.5f
static NSString *const headerIdentifier = @"header";
static NSString *const govIdentifier = @"govIdentifier";
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
//每个item之间的距离;
static float const kCollectionViewCellsHorizonMargin          = 1.f;

static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;

@interface GovermentVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasourceArr;
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic, strong) UIImageView *collectionHeadView;
@property (nonatomic, strong) ProvinceModel *proModel;
@property (nonatomic, strong) BaseRightBtn *baseRightButton;
@property (nonatomic, copy)   NSString *showLocal;

@end

@implementation GovermentVC

- (void)dealloc {
    
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)initView { WEAKSELF;
    [self setupNaviBarWithTitle:@"司法机关"];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@",PLISTCachePath,@"provincescity.plist"];
    NSDictionary *bigDoctionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *proArrays = bigDoctionary[@"province"];
    __block NSMutableArray *pcaSourceArrays = [NSMutableArray array];
    [proArrays enumerateObjectsUsingBlock:^(NSDictionary *objDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProvinceModel *proModel = [[ProvinceModel alloc] initWithDictionary:objDictionary];
        [pcaSourceArrays addObject:proModel];
    }];

    if ([PublicFunction ShareInstance].locProv.length >0) {

        NSString *showName = [PublicFunction ShareInstance].locProv;
        for (NSUInteger i = 0; i < [pcaSourceArrays count]; i++) {
            
            ProvinceModel *model = pcaSourceArrays[i];
            if ([model.name isEqualToString:[PublicFunction ShareInstance].locProv]) {
                
                _proModel = model;
                break;
            }
        }

        if ([QZManager isString:showName withContainsStr:@"内蒙古"] || [QZManager isString:showName withContainsStr:@"黑龙江"]) {
            _showLocal = [showName  substringToIndex:3];
        } else {
            _showLocal = [showName  substringToIndex:2];
        }
    }else {
        
        for (NSUInteger i = 0; i < [pcaSourceArrays count]; i++) {
            
            ProvinceModel *model = pcaSourceArrays[i];
            if ([model.name isEqualToString:@"上海"]) {
                _proModel = model;
                break;
            }
        }
        _showLocal =  @"上海";
    }
    [self.view addSubview:self.baseRightButton];
    
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

    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    
    [self loadData];
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
        [weakSelf.collectionView reloadData];
    } fail:^{
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
    GovData *model = _datasourceArr[indexPath.row];

    GovernmentListVC *vc = [[GovernmentListVC alloc] initWithCTName:model.ctname
                                                       withShowName:_showLocal
                                                  withProvinceModel:_proModel];
    vc.localBlock = ^(ProvinceModel *proModel, NSString *showName){
        
        weakSelf.proModel = proModel;
        weakSelf.showLocal  = showName;
        [weakSelf.baseRightButton setTitle:showName forState:0];
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
- (void)baseRightBtnAction
{WEAKSELF;
    SelectProvinceVC *selectVC = [[SelectProvinceVC alloc] initWithSelectType:FromGoverment withIsHaveNoGAT:NO];
    selectVC.provinceBlock = ^(NSString *showName, ProvinceModel *proModel){
        
        weakSelf.showLocal = showName;
        weakSelf.proModel = proModel;
        [weakSelf.baseRightButton setTitle:showName forState:0];
    };
    [self presentViewController:selectVC animated:YES completion:nil];
}
#pragma amrk - setter and getter
- (BaseRightBtn *)baseRightButton
{
    if (!_baseRightButton) {
        CGRect frame = CGRectMake(kMainScreenWidth - 70, 20, 70, 44);
        _baseRightButton = [BaseRightBtn buttonWithType:UIButtonTypeCustom];
        _baseRightButton.frame = frame;
        _baseRightButton.backgroundColor = [UIColor clearColor];
        [_baseRightButton addTarget:self
                          action:@selector(baseRightBtnAction)
                forControlEvents:UIControlEventTouchUpInside];
        [_baseRightButton setTitle:_showLocal forState:0];
        [_baseRightButton setImage:kGetImage(@"gov_SelectLoc") forState:0];
    }
    return _baseRightButton;
}

- (NSMutableArray *)datasourceArr {
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
