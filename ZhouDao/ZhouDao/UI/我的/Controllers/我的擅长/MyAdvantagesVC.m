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
{
    BOOL _isShake;
}
@property (nonatomic, strong) UICollectionView *collectionView;//频道编辑
@property (nonatomic, strong) NSMutableArray *remainArrays;
@property (nonatomic, strong) NSMutableArray *bgArrays;
@property (nonatomic, strong) NSMutableArray *selectArrays;//擅长数组
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *snameArr;//比对数组

@end

@implementation MyAdvantagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
    [self initUI];
}
- (void)getData
{
    [SVProgressHUD show];
    NSString *dmainUrl = [NSString stringWithFormat:@"%@%@",kProjectBaseUrl,DomainList];
    [ZhouDao_NetWorkManger GetJSONWithUrl:dmainUrl success:^(NSDictionary *jsonDic) {
        [SVProgressHUD dismiss];
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        [self analyticalData:jsonDic];
        
    } fail:^{
        [SVProgressHUD showErrorWithStatus:AlrertMsg];
    }];
    
//    NSString *pathSource = [[NSBundle mainBundle] pathForResource:@"mygood" ofType:@"txt"];
//    NSString *dataS = [NSString stringWithContentsOfFile:pathSource encoding:NSUTF8StringEncoding error:nil];
//    
//    //DLog(@"输出文件数据－－－－－%@",dataS);
//    NSData *data = [dataS dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//   // DLog(@"输出文件字典－－－－－%@",dict);
}
- (void)analyticalData:(NSDictionary *)dict
{
    _bgArrays = [NSMutableArray  array];
    _selectArrays = [NSMutableArray array];
    _snameArr = [NSMutableArray array];
    [_compareArr enumerateObjectsUsingBlock:^(AdvantagesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_snameArr addObject:obj.sname];
    }];
    _remainArrays = [NSMutableArray arrayWithObjects:@"民事",@"经济",@"房地产",@"金融",@"国际",@"知识产权",@"刑事", nil];
    NSDictionary *remainDic = dict[@"data"];
    NSArray *keyArrays = [remainDic allKeys];
    for (NSString *nameStr in keyArrays)
    {
        if (![_remainArrays containsObject:nameStr])
        {
            [_remainArrays addObject:nameStr];
        }
    }
    
    [_remainArrays enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *keyStr = (NSString *)obj;
        NSMutableArray *tempArrays = [NSMutableArray array];
        NSMutableArray *arrays = [NSMutableArray array];
        tempArrays = remainDic[keyStr];
        
        for (NSDictionary *dicc in tempArrays)
        {
            AdvantagesModel *model = [[AdvantagesModel alloc] initWithDictionary:dicc];
            if ([_snameArr containsObject:model.sname]) {
                [_selectArrays addObject:model];
            }else{
                [arrays addObject:model];
            }
        }
        [_bgArrays addObject:arrays];
    }];
    [_collectionView reloadData];
}
- (void)initUI
{
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
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelCollectionCell * cell = (ChannelCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier forIndexPath:indexPath];
    cell.delImgView.hidden = YES;
    if (indexPath.section == 0)
    {
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
    
    if (_bgArrays.count >0 && indexPath.section >0)
    {
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
    if (_selectArrays.count <12 && section >0)
    {
        NSMutableArray *arr = _bgArrays[section-1];
        AdvantagesModel *model = arr[row];
        [_selectArrays addObject:model];
        [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[_selectArrays count]-1 inSection:0]]];
        [arr removeObject:model];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:row inSection:section]]];

    }else if (_selectArrays.count >=12 && section !=0){
        [JKPromptView showWithImageName:nil message:@"您最多可选择12项"];
    }
    
    if (_isShake == YES && section == 0)
    {
        AdvantagesModel *model = _selectArrays[row];
        
        for (NSUInteger i=0; i<_remainArrays.count; i++)
        {
            NSString *str = _remainArrays[i];
            if ([str isEqualToString:model.cname])
            {
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0)
        {
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
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
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
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kCollectionViewToTopMargin, kCollectionViewToLeftMargin, kCollectionViewToBottomtMargin, kCollectionViewToRightMargin);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kCollectionViewCellsHorizonMargin;
}

////每个section中不同的行之间的行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 5;
//}
//- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//    attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//    
//    return attr;
//}
#pragma mark -SelectReusableViewPro
- (void)editStateShake
{
    _isShake = !_isShake;
    if (_selectArrays.count == 0) {
        _isShake = NO;
    }
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //y值向下拉的时候是负的值
    CGFloat yOffset = scrollView.contentOffset.y;
    //DLog(@"hhhhhhh:%f",yOffset);
    
    if (yOffset<=0)
    {
        _lineView.hidden = YES;

    }else{
        _lineView.hidden = NO;
    }

}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    WEAKSELF;

//    if (_selectArrays.count >0)
//    {
        BOOL __block isContain = NO;
        [_selectArrays enumerateObjectsUsingBlock:^(AdvantagesModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![weakSelf.snameArr containsObject:obj.sname]) {
                isContain = YES;
            }
        }];
        if (_selectArrays.count < self.snameArr.count) {
            isContain = YES;
        }
        
        if (isContain == YES)
        {
            NSMutableString *dominString = [[NSMutableString alloc] init];
            for (NSUInteger i=0; i<_selectArrays.count; i++)
            {
                AdvantagesModel *model = _selectArrays[i];
                if (i == _selectArrays.count -1) {
                    [dominString appendString:model.id];
                }else{
                    [dominString appendString:[NSString stringWithFormat:@"%@,",model.id]];
                }
            }
            
            if (_selectArrays.count == 0) {
                [dominString appendString:@","];
            }
            
            /*
             修改擅长领域
             */
            NSString *addUrl = [NSString stringWithFormat:@"%@%@uid=%@&special=%@",kProjectBaseUrl,DomainAdd,UID,GET(dominString)];
            
            [SVProgressHUD show];
            [ZhouDao_NetWorkManger GetJSONWithUrl:addUrl success:^(NSDictionary *jsonDic) {
                
                [SVProgressHUD dismiss];
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                [JKPromptView showWithImageName:nil message:msg];
                if (errorcode !=1) {
                    return ;
                }
                weakSelf.domainBlock(weakSelf.selectArrays);
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                }];
                
            } fail:^{
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                }];
                [SVProgressHUD showErrorWithStatus:AlrertMsg];
            }];

        }else{
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }

        
//    }else{
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        }];
//
//    }
    
}

#pragma mark - setters and getters
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , SCREENWIDTH ,SCREENHEIGHT-64) collectionViewLayout:layout];
        //layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = LRRGBColor(242, 242, 242);
        //self.collectionView.bounces = NO;
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView registerClass:[ChannelCollectionCell class] forCellWithReuseIdentifier:KCellIdentifier];
    }
    return _collectionView;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, .5f)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"D7D7D7"];
        _lineView.hidden = YES;
    }
    return _lineView;
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
