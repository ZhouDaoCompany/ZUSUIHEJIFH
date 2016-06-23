//
//  FilterView.m
//  UItext
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "FilterView.h"
#import "FilterCollectionViewCell.h"
#import "FilterReusableView.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define  LeftView 10.0f
#define  TopToView 10.0f

#define buttonWidth (SCREENWIDTH-40.f)/2.f
#define filterWidth (SCREENWIDTH -40.f-15.f)/4.f
#define monthWidth (SCREENWIDTH -70.f-15.f)/6.f

static NSString * const kCellIdentifier           = @"CellIdentifier";
static NSString * const kHeaderViewCellIdentifier = @"HeaderViewCellIdentifier";
static NSString * const kFooterViewCellIdentifier = @"FooterViewCellIdentifier";

static float const kCollectionViewToLeftMargin                = 0;
static float const kCollectionViewToTopMargin                 = 10;
static float const kCollectionViewToRightMargin               = 10;
static float const kCollectionViewToBottomtMargin             = 10;

static float const kCollectionViewCellsHorizonMargin          = 10.f;//每个item之间的距离;
static float const kCollectionViewCellsSection                = 10.f;//每行之间的距离;

@interface FilterView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    int _oneRow;
    int _twoRow;
    int _threeRow;
    int _fourRow;
}

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, strong) UIView *maskView;//遮罩层
@property (nonatomic, strong)  UIView *botomView;
@property (nonatomic,strong) NSMutableArray *symptoms;//类别
@property (nonatomic,strong) NSArray *sectionArrays;//类别名称
@property (nonatomic, strong) UICollectionView *collectionView;//案件
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) NSArray *gwArrays;
@property (nonatomic, strong) NSArray *secondArrays;
@end

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }

    return self;
}

- (void)initUI
{
    _oneRow = -1;
    _twoRow = -1;
    _threeRow = -1;
    _fourRow = -1;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    NSArray *oneArrays= @[@"诉讼案件",@"非诉案件",@"法律顾问"];
   _secondArrays = @[@"在办",@"已结案"];
    _gwArrays = @[@"合约期内",@"合约期满"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *nowDate =[NSDate date];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    NSUInteger nowYear = [dateComponent year];
    
    NSMutableArray *thirdArrays = [NSMutableArray array];

    for (NSUInteger i = nowYear; i >=2013; i--)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",(unsigned long)i];
        [thirdArrays addObject:yearStr];
    }

    NSArray *fourArrays = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    self.symptoms =[NSMutableArray arrayWithObjects:oneArrays,_secondArrays,thirdArrays,fourArrays, nil];
    self.sectionArrays = @[@"类别",@"状态",@"年份",@"月份"];
    
    [self whenCancelTapped:^{
        
        [self viewDismiss];
    }];
    
    UIView *botomView = [[UIView alloc] initWithFrame:CGRectMake(0,119 , width, height-119.f)];
    botomView.backgroundColor = [UIColor blackColor];
    botomView.alpha = 0.4f;
    _botomView = botomView;
    [self addSubview:_botomView];

    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 119.f, width, 0)];
    _maskView.backgroundColor = [UIColor whiteColor];
    _maskView.clipsToBounds = YES;
    [_maskView whenCancelTapped:^{
        
    }];
    
    [UIView animateWithDuration:.35f animations:^{
        
        if (SCREENHEIGHT >579.f){
            _maskView.frame = CGRectMake(0, 119.f, width, 440.f);
        }else{
            _maskView.frame = CGRectMake(0, 119.f, width, height - 119.f- 65.f);
        }
        [self addSubview:_maskView];

    }];
    
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 118.5, width, .5f)];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
//    [self addSubview:lineView];

    

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15.f, 0 , _maskView.frame.size.width-15.f , _maskView.frame.size.height-65.f) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [_maskView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView registerClass:[FilterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewCellIdentifier];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    [resetBtn setTitle:@"重置" forState:0];
    resetBtn.tag = 10001;
    resetBtn.frame = CGRectMake(15,Orgin_y(_collectionView) + 15, buttonWidth, 40.f);
    [resetBtn addTarget:self action:@selector(fiterBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _resetBtn = resetBtn;
    [_maskView addSubview:_resetBtn];

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor  = KNavigationBarColor;
    [sureBtn setTitle:@"确定" forState:0];
    sureBtn.tag = 10002;
    sureBtn.frame = CGRectMake(Orgin_x(resetBtn) +10.f, Orgin_y(_collectionView) +15, buttonWidth, 40.f);
    [sureBtn addTarget:self action:@selector(fiterBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.enabled = NO;
    _sureBtn = sureBtn;
    [_maskView addSubview:_sureBtn];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [self.sectionArrays count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arrays = self.symptoms[section];
    return [arrays count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell * cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.titleLab.text = self.symptoms[indexPath.section][indexPath.row];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    cell.isSelected = NO;
    
    if (section == 0 && _oneRow == row) {
        cell.isSelected = YES;
    }else if(section == 1 && _twoRow == row){
        cell.isSelected = YES;
    }else if(section == 2 && _threeRow == row){
        cell.isSelected = YES;
    }else if(section == 3 && _fourRow == row){
        cell.isSelected = YES;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = indexPath.section;
    int row = (int)indexPath.row;
    
    if (section == 0) {
        (_oneRow == row)?(_oneRow = -1):(_oneRow = row);
    }else if(section == 1){
        (_twoRow == row)?(_twoRow = -1):(_twoRow = row);
    }else if(section == 2){
        (_threeRow == row)?(_threeRow = -1):(_threeRow = row);
    }else if(section == 3){
        (_fourRow == row)?(_fourRow = -1):(_fourRow = row);
    }
    
    if (section == 0){
        if (_oneRow == 2) {
            [_symptoms replaceObjectAtIndex:1 withObject:_gwArrays];
        }else {
            [_symptoms replaceObjectAtIndex:1 withObject:_secondArrays];
        }
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }
    
    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
    
    if ((_oneRow == -1)&&(_twoRow == -1)&&(_threeRow == -1)&&(_fourRow == -1)) {
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:0];
        _resetBtn.layer.borderWidth = 0.f;
        _sureBtn.enabled = NO;
    }else{
        _sureBtn.enabled = YES;
        [_resetBtn setTitleColor:thirdColor forState:0];
        _resetBtn.backgroundColor = [UIColor clearColor];
        _resetBtn.layer.borderWidth = .6f;
        _resetBtn.layer.borderColor = sixColor.CGColor;
    }
    

//    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%d",section,row);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        FilterReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewCellIdentifier forIndexPath:indexPath];
        NSString *title = self.sectionArrays[indexPath.section];
        [headerView setLabelText:title];
        reusableview = headerView;
    }else if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *fooltView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterViewCellIdentifier forIndexPath:indexPath];
        fooltView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
        reusableview = fooltView;
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *text = self.symptoms[indexPath.section][indexPath.row];
//    float cellWidth = [self collectionCellWidthText:text];
    if (indexPath.section == 3) {
        return CGSizeMake(monthWidth, 40);
    }
    return CGSizeMake(filterWidth, 40);
}
- (float)collectionCellWidthText:(NSString *)text{
    float cellWidth;
    CGSize size = [text sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:14]}];
    cellWidth = size.width;
    
    return cellWidth +30;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH - 50, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH-15.f, .5f);
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

#pragma mark -消失
- (void)viewDismiss
{
    [_botomView removeFromSuperview];
    WEAKSELF;
    [UIView animateWithDuration:.35f animations:^{
        _maskView.frame = CGRectMake(0,119 , self.frame.size.width, 0);
        _botomView.frame = CGRectMake(0,119 , self.frame.size.width, 0);
        
        weakSelf.filterBlock();
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark -UIButonEvent
- (void)fiterBtnEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    
    if (index == 10001)
    {
        _oneRow = -1;
        _twoRow = -1;
        _threeRow = -1;
        _fourRow = -1;
        [_collectionView reloadData];
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:0];
        _resetBtn.layer.borderWidth = 0.f;

    }else{
        NSString *type;
        if (_oneRow == 0) {
            type = @"1";
        }else if (_oneRow == 1){
            type = @"2";
        }else if (_oneRow == 2){
            type = @"3";
        }else{
            type = @"";
        }
        
        NSString *state;
        if (_twoRow == 0) {
            state = @"1";
        }else if (_twoRow == 1){
            state = @"2";
        }else{
            state = @"";
        }
        
        NSString *year = @"";
        if (_threeRow >0) {
           year = self.symptoms[2][_threeRow];
        }
        NSString *month = @"";
        if (_fourRow >0) {
            month = self.symptoms[3][_fourRow];
        }
        NSString *url = [NSString stringWithFormat:@"%@%@uid=%@&type=%@&state=%@&timeYear=%@&timeMonth=%@",kProjectBaseUrl,arrangeScreen,UID,type,state,year,month];
        _urlBlock(url);
        [self viewDismiss];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect

{
    //    [colors[serie] setFill];
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context,
                           LeftView + 10, 119);//设置起点
    
    CGContextAddLineToPoint(context,2*LeftView + 10 ,  109);
    
    CGContextAddLineToPoint(context,TopToView * 3 + 10, 119);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
    //    [self setNeedsDisplay];
}



@end
