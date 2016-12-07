//
//  TemplateViewController.m
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TemplateViewController.h"
#import "ToolCollectionViewCell.h"
#import "SelectTemplateVC.h"
#import "TheContractData.h"
#import "OrdinaryVC.h"

#define templateWidth     [UIScreen mainScreen].bounds.size.width/2.f -0.5f
#define templateHeight    68
static NSString *const templateIdentifier = @"toolIdentifier";
static float const kCollectionViewToLeftMargin                = 0.f;
static float const kCollectionViewToTopMargin                 = 0.f;
static float const kCollectionViewToRightMargin               = 0.f;
static float const kCollectionViewToBottomtMargin             = 0.f;
static float const kCollectionViewCellsHorizonMargin          = 1.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 1.f;//每行之间的距离;


@interface TemplateViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *nameArrays;
@property (nonatomic, strong) NSMutableArray *idArrays;

@property (nonatomic, strong) UIImageView *falseImgView;

@end

@implementation TemplateViewController
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
- (void)initUI
{
    [self setupNaviBarWithTitle:@"合同模版"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Esearch_SouSuo"];

    //假的截屏
    UIWindow *windows = [QZManager getWindow];
    [windows addSubview:self.falseImgView];
    [windows sendSubviewToBack:self.falseImgView];
    [AnimationTools makeAnimationBottom:self.view];
    self.navigationController.navigationBarHidden = YES;
    
    _dataSourceArr = [NSMutableArray array];
    _nameArrays = [NSMutableArray array];
    _idArrays = [NSMutableArray array];
    /***************************分割线*****************************/
    [self.view addSubview:self.collectionView];
    
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];

    [self loadData];
}
- (void)loadData
{WEAKSELF;
    [NetWorkMangerTools theContractFirstListRequestSuccess:^(NSArray *arrays, NSArray *nameArr, NSArray *idArrays) {
        
        if (arrays.count>0) {
            [weakSelf.dataSourceArr removeAllObjects];
            [weakSelf.nameArrays removeAllObjects];
            [weakSelf.idArrays removeAllObjects];
            [weakSelf.dataSourceArr addObjectsFromArray:arrays];
        }
        [weakSelf.nameArrays addObjectsFromArray:nameArr];
        [weakSelf.idArrays addObjectsFromArray:idArrays];
        [weakSelf.collectionView reloadData];
    } fail:^{
    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataSourceArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToolCollectionViewCell * cell = (ToolCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:templateIdentifier forIndexPath:indexPath];
    if (_dataSourceArr.count >0) {
        if ([_dataSourceArr[indexPath.row] isKindOfClass:[TheContractData class]]) {
            [cell setModel:_dataSourceArr[indexPath.row]];
        }else{
            cell.iconImgView.hidden = YES;
            cell.titleLab.hidden = YES;
        }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",(long)indexPath.section,(long)indexPath.row);
    if ([_dataSourceArr[indexPath.row] isKindOfClass:[TheContractData class]]) {
        
        TheContractData *model = _dataSourceArr[indexPath.row];
        SelectTemplateVC *selectlVC = [[SelectTemplateVC alloc] initWithFirstArrays:_nameArrays withCidArrays:_idArrays withTheContractData:model withTemplateType:GeneralSelectType];
        [self.navigationController  pushViewController:selectlVC animated:YES];
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
    return CGSizeMake(templateWidth, templateHeight);
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
- (void)leftBtnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBtnAction {
    
    //搜索合同模版
    OrdinaryVC *vc = [[OrdinaryVC alloc] initWithOrdinarySearchType:ContractSearchType];
    [AnimationTools makeAnimationFade:vc :self.navigationController];
}
#pragma mark - setter and getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
        //layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:templateIdentifier];
    }
    return _collectionView;
}
- (UIImageView *)falseImgView {
    if (!_falseImgView) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
    }
    return _falseImgView;
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
