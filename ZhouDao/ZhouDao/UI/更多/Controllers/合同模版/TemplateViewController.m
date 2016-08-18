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
- (void)initUI
{
    [self setupNaviBarWithTitle:@"合同模版"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
//    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"law_contentSearch"];

    //假的截屏
    _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
    _falseImgView.image = [QZManager capture];
    UIWindow *windows = [QZManager getWindow];
    [windows addSubview:_falseImgView];
    [windows sendSubviewToBack:_falseImgView];
    [AnimationTools makeAnimationBottom:self.view];
    self.navigationController.navigationBarHidden = YES;
    
    _dataSourceArr = [NSMutableArray array];
    _nameArrays = [NSMutableArray array];
    _idArrays = [NSMutableArray array];
    /***************************分割线*****************************/
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , kMainScreenWidth ,kMainScreenHeight-64.f) collectionViewLayout:layout];
    //layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:templateIdentifier];
    WEAKSELF;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf loadData];
    }];
    NSArray *arrays = [USER_D objectForKey:TemplateStorage];
    if (arrays.count >0) {
        [weakSelf.dataSourceArr removeAllObjects];
        NSArray *nameArr = [USER_D objectForKey:@"nameArr"];
        NSArray *idArrays = [USER_D objectForKey:@"idArrays"];
        [_nameArrays addObjectsFromArray:nameArr];
        [_idArrays addObjectsFromArray:idArrays];
        [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TheContractData *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
            [weakSelf.dataSourceArr addObject:model];
        }];
        [weakSelf.collectionView reloadData];
    }
    /**
     *  加载新数据
     */
    [self loadData];
//    [self.collectionView.mj_header beginRefreshing];
}
- (void)loadData
{WEAKSELF;
    [NetWorkMangerTools theContractFirstListRequestSuccess:^(NSArray *arrays, NSArray *nameArr, NSArray *idArrays) {
        
        if (arrays.count>0) {
            [_dataSourceArr removeAllObjects];
            [_nameArrays removeAllObjects];
            [_idArrays removeAllObjects];
            [_dataSourceArr addObjectsFromArray:arrays];
        }
        [_nameArrays addObjectsFromArray:nameArr];
        [_idArrays addObjectsFromArray:idArrays];
        [weakSelf.collectionView reloadData];
        NSMutableArray *arr = [NSMutableArray array];
        [arrays enumerateObjectsUsingBlock:^(TheContractData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
            [arr addObject:data];
        }];
        [USER_D setObject:arr forKey:TemplateStorage];
        [USER_D setObject:nameArr forKey:@"nameArr"];
        [USER_D setObject:idArrays forKey:@"idArrays"];

        [USER_D synchronize];
    } fail:^{
        NSArray *arrays = [USER_D objectForKey:TemplateStorage];
        if (arrays.count >0) {
            [weakSelf.dataSourceArr removeAllObjects];
            [arrays enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TheContractData *model = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
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
        SelectTemplateVC *selectlVC = [SelectTemplateVC new];
        selectlVC.firstArrays = _nameArrays;
        selectlVC.cidArrays = _idArrays;
        selectlVC.model = model;
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
- (void)leftBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
