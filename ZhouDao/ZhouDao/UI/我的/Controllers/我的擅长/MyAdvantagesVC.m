//
//  MyAdvantagesVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyAdvantagesVC.h"
#import "ChannelCollectionCell.h"
#import "SelectReusableView.h"
#import "AllReusableView.h"
#import "commonReusableView.h"
#import "AdvantagesModel.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define cellWidth (SCREENWIDTH-45)/4.f
#define KCellIdentifier @"identifier"
static NSString *const selectIdentifier = @"selectIdentifier";
static NSString *const allIdentifier = @"allIdentifier";
static NSString *const commenIdentifier = @"commenIdentifier";

static float const kCollectionViewToLeftMargin                = 15.f;
static float const kCollectionViewToTopMargin                 = 5.f;
static float const kCollectionViewToRightMargin               = 15.f;
static float const kCollectionViewToBottomtMargin             = 5.f;
static float const kCollectionViewCellsHorizonMargin          = 5.f;//每个item之间的距离;

@interface MyAdvantagesVC ()<UICollectionViewDataSource,UICollectionViewDelegate,SelectReusableViewPro>

@property (nonatomic, strong) UICollectionView *collectionView;//频道编辑
@property (nonatomic, strong) NSMutableArray *remainArrays;
@property (nonatomic, strong) NSMutableArray *bgArrays;
@property (nonatomic, strong) NSMutableArray *selectArrays;//擅长数组
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *snameArr;//比对数组
@property (nonatomic, assign) BOOL isShake;
@end

@implementation MyAdvantagesVC
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self getData];
    [self initUI];
}
#pragma mark - methods
- (void)getData { WEAKSELF;
    [MBProgressHUD showMBLoadingWithText:nil];
    NSString *dmainUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,DomainList];
    [ZhouDao_NetWorkManger getWithUrl:dmainUrl sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        [weakSelf analyticalData:jsonDic];

    } fail:^(NSError *error) {
        [MBProgressHUD showError:LOCERROEMESSAGE];
    }];
    
}
- (void)analyticalData:(NSDictionary *)dict { WEAKSELF;
    
    [_compareArr enumerateObjectsUsingBlock:^(AdvantagesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.snameArr addObject:obj.sname];
    }];
    _remainArrays = [NSMutableArray arrayWithObjects:@"民事",@"经济",@"房地产",@"金融",@"国际",@"知识产权",@"刑事", nil];
    NSDictionary *remainDic = dict[@"data"];
    NSArray *keyArrays = [remainDic allKeys];
    [keyArrays enumerateObjectsUsingBlock:^(NSString *objName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![weakSelf.remainArrays containsObject:objName]) {
            
            [weakSelf.remainArrays addObject:objName];
        }
    }];
    
    [_remainArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *keyStr = (NSString *)obj;
        NSMutableArray *tempArrays = [NSMutableArray array];
        NSMutableArray *arrays = [NSMutableArray array];
        tempArrays = remainDic[keyStr];
        
        for (NSDictionary *dicc in tempArrays) {
            
            AdvantagesModel *model = [[AdvantagesModel alloc] initWithDictionary:dicc];
            if ([weakSelf.snameArr containsObject:model.sname]) {
                [weakSelf.selectArrays addObject:model];
            }else{
                [arrays addObject:model];
            }
        }
        [weakSelf.bgArrays addObject:arrays];
    }];
    [_collectionView reloadData];
}
- (void)initUI {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    self.statusBarView.backgroundColor = LRRGBColor(242, 242, 242);//[UIColor colorWithHexString:@"#"];
    self.naviBarView.backgroundColor = LRRGBColor(242, 242, 242);
    self.view.backgroundColor = LRRGBColor(242, 242, 242);
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_guanbi"];

  
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.lineView];
    [self.view bringSubviewToFront:_lineView];
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([_remainArrays count]>0) {
        return [_remainArrays count] +1;
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 && _selectArrays.count>0) {
        return [_selectArrays count];
    }else if (_bgArrays.count>0 && section>0) {
        return [_bgArrays[section-1] count];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelCollectionCell * cell = (ChannelCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier forIndexPath:indexPath];
    cell.delImgView.hidden = YES;
    if (indexPath.section == 0) {
        
        if (_selectArrays.count>0) {
            AdvantagesModel *model = _selectArrays[indexPath.row];
            cell.titleLab.text = model.sname;
        }
        if (_isShake == YES){
            cell.delImgView.hidden = NO;
            [AnimationTools shakeAnimationWith:cell];

        }else{
            [cell.layer removeAllAnimations];
        }
    }
    if (_bgArrays.count >0 && indexPath.section >0) {
        
        NSMutableArray *arr = _bgArrays[indexPath.section -1];
        AdvantagesModel *model = arr[indexPath.row];
        cell.titleLab.text = model.sname;
    }

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
//先修改数据源 然后执行插入删除操作
    if (_selectArrays.count <12 && section >0) {
        
        NSMutableArray *arr = _bgArrays[section-1];
        AdvantagesModel *model = arr[row];
        [_selectArrays addObject:model];
        [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[_selectArrays count]-1 inSection:0]]];
        [arr removeObject:model];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:section]]];

    }else if (_selectArrays.count >=12 && section !=0){
        [JKPromptView showWithImageName:nil message:@"您最多可选择12项"];
    }
    
    if (_isShake == YES && section == 0) {
        
        AdvantagesModel *model = _selectArrays[row];
        
        for (NSUInteger i=0; i<_remainArrays.count; i++) {
            
            NSString *str = _remainArrays[i];
            if ([str isEqualToString:model.cname]) {
                NSMutableArray *arr = _bgArrays[i];
                [_selectArrays removeObject:model];
                [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:0]]];
                [arr addObject:model];
                [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[arr count]-1 inSection:i+1]]];
                break;
            }
        }
        
        if (_selectArrays.count == 0) {
            _isShake = NO;
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }
    }
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",indexPath.section,indexPath.row);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
            [self.collectionView registerClass:[SelectReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:selectIdentifier];
            
            SelectReusableView *oneView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:selectIdentifier forIndexPath:indexPath];
            if (_isShake == NO) {
                [oneView setStateStr:@"编辑"];
            }else {
                [oneView setStateStr:@"完成"];
            }
            oneView.delegete = self;
            return oneView;
            
        }else if (indexPath.section == 1){
            [self.collectionView registerClass:[AllReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:allIdentifier];
            
            AllReusableView *twoView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:allIdentifier forIndexPath:indexPath];
            twoView.titLab.text =  _remainArrays[0];
            return twoView;
        }
        [self.collectionView registerClass:[commonReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:commenIdentifier];
        
        commonReusableView *thirdView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:commenIdentifier forIndexPath:indexPath];
        NSString *title = _remainArrays[indexPath.section -1];
        [thirdView setLabelText:title];
        return thirdView;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(cellWidth, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        height = 50.f;
    }else if (section == 1){
        height = 65.f;
    }else{
        height = 30.f;
    }
    return CGSizeMake(SCREENWIDTH, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return kCollectionViewCellsHorizonMargin;
}
#pragma mark -SelectReusableViewPro
- (void)editStateShake {
    
    _isShake = !_isShake;
    if (_selectArrays.count == 0) {
        _isShake = NO;
    }
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //y值向下拉的时候是负的值
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset<=0) {
        _lineView.hidden = YES;

    }else{
        _lineView.hidden = NO;
    }
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction { WEAKSELF;
    

    BOOL __block isContain = NO;
    [_selectArrays enumerateObjectsUsingBlock:^(AdvantagesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![weakSelf.snameArr containsObject:obj.sname]) {
            isContain = YES;
        }
    }];
    if (_selectArrays.count < self.snameArr.count) {
        isContain = YES;
    }
    
    if (isContain == YES) {
        __block NSMutableString *dominString = [[NSMutableString alloc] init];
        
        [_selectArrays enumerateObjectsUsingBlock:^(AdvantagesModel *objModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == [weakSelf.selectArrays count] -1) {
                [dominString appendString:objModel.id];
            }else{
                [dominString appendString:[NSString stringWithFormat:@"%@,",objModel.id]];
            }
        }];
        if ([_selectArrays count] == 0) {
            [dominString appendString:@","];
        }
        
        /*
         修改擅长领域
         */
        NSString *addUrl = [NSString stringWithFormat:@"%@%@uid=%@&special=%@",kProjectBaseUrl,DomainAdd,UID,GET(dominString)];
        
        [MBProgressHUD showMBLoadingWithText:nil];
        [ZhouDao_NetWorkManger getWithUrl:addUrl sg_cache:NO success:^(id response) {
            
            [MBProgressHUD hideHUD];
            NSDictionary *jsonDic = (NSDictionary *)response;
            NSUInteger errorcode = [jsonDic[@"state"] integerValue];
            NSString *msg = jsonDic[@"info"];
            [JKPromptView showWithImageName:nil message:msg];
            if (errorcode !=1) {
                return ;
            }
            weakSelf.domainBlock(weakSelf.selectArrays);
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
            
        } fail:^(NSError *error) {
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
            [MBProgressHUD showError:LOCERROEMESSAGE];
            
        }];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH ,SCREENHEIGHT-64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = LRRGBColor(242, 242, 242);
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ChannelCollectionCell class] forCellWithReuseIdentifier:KCellIdentifier];
    }
    return _collectionView;
}
- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, .5f)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"D7D7D7"];
        _lineView.hidden = YES;
    }
    return _lineView;
}
- (NSMutableArray *)bgArrays {
    
    if (!_bgArrays) {
        _bgArrays = [NSMutableArray array];
    }
    return _bgArrays;
}
- (NSMutableArray *)selectArrays {
    
    if (!_selectArrays) {
        _selectArrays = [NSMutableArray array];
    }
    return _selectArrays;
}
- (NSMutableArray *)snameArr {
    
    if (!_snameArr) {
        _snameArr = [NSMutableArray array];
    }
    return _snameArr;
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
