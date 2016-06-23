//
//  ZD_SettingBottomBar.m
//  ZhouDao
//
//  Created by cqz on 16/3/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//


//section的头部
@interface SectionHeadView : UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

-(void)setLabelText:(NSString *)text;
@end

@implementation SectionHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        self.label.font = Font_15;
        [self.label setTextColor:[UIColor colorWithHexString:@"#666666"]];
        [self addSubview:self.label];
    }
    return self;
}

- (void) setLabelText:(NSString *)text
{
    self.label.text = text;
    [self.label sizeToFit];
}

@end

#import "ZD_SettingBottomBar.h"
#import "SetCollectionViewCell.h"

#define cellWidth (self.frame.size.width-50)/8.f

static NSString *const HeadIdentifier = @"hedIdentifier";
static NSString *const commenIdentifier = @"commenIdentifier";

static float const kCollectionViewToLeftMargin                = 25.f;
static float const kCollectionViewToTopMargin                 = 10.f;
static float const kCollectionViewToRightMargin               = 25.f;
static float const kCollectionViewToBottomtMargin             = 10.f;
static float const kCollectionViewCellsHorizonMargin          = 25.f;//每个item之间的距离;

@interface ZD_SettingBottomBar ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;//频道编辑
@property (nonatomic, strong) UIView *bgView;//北京view
@property (nonatomic, strong) UIView *botomView;

@end
@implementation ZD_SettingBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    UIView *views = [[UIView alloc] initWithFrame:self.bounds];
    views.backgroundColor = [UIColor blackColor];
    views.alpha = .3f;
    _bgView = views;
    [self addSubview:_bgView];
    [_bgView whenCancelTapped:^{
        [self selfDismiss];

        
    }];
    
    UIView * botomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 240)];
    botomView.backgroundColor = ViewBackColor;
    _botomView = botomView;
    [self addSubview:_botomView];
    [_botomView whenCancelTapped:^{
        
    }];
    
    [UIView animateWithDuration:.35f animations:^{
        _botomView.frame = CGRectMake(0, height - 240, width, 240);
    }];

    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.center = CGPointMake(self.center.x, 35);
    titleLab.bounds = CGRectMake(0, 0, 100, 20);
    titleLab.font = Font_18;
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"阅读设置";
    [_botomView addSubview:titleLab];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.backgroundColor = [UIColor clearColor];
    [completeBtn setTitleColor:KNavigationBarColor forState:0];
    [completeBtn setTitle:@"完成" forState:0];
    completeBtn.titleLabel.font = Font_15;
    completeBtn.frame = CGRectMake(width -60, 20, 45, 30);
    [completeBtn addTarget:self action:@selector(completesettingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:completeBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70 , botomView.frame.size.width ,botomView.frame.size.height -70) collectionViewLayout:layout];
    //layout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces = NO;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [_botomView addSubview:self.collectionView];
    [self.collectionView registerClass:[SetCollectionViewCell class] forCellWithReuseIdentifier:commenIdentifier];
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SetCollectionViewCell * cell = (SetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:commenIdentifier forIndexPath:indexPath];
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    DLog(@"标签被点击了－－－－第几个便签－section:%ld   row:%ld",section,row);
    
    if (section == 0)
    {
        //float fontSize = 3.f*(row +4);
        NSString *fontsize = nil;
        if (row == 0) {
            fontsize = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '90%'";
        }else if(row ==1){
            fontsize = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
        }else if(row ==2){
            fontsize = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'";
        }else if(row ==3){
            fontsize = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'";
        }else if(row ==4){
            fontsize = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '140%'";
        }

        if ([self.delegate respondsToSelector:@selector(getFontSize:WithSection:WithRow:)])
        {
            [self.delegate getFontSize:fontsize WithSection:section WithRow:row];
        }
    }
    
    if (section == 1)
    {
        NSString *colorString = nil;
        NSString *bacViewColor = nil;
        if (row == 0) {
            colorString =@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'";
            bacViewColor = @"#FFFFFF";
        }else if(row ==1){
            colorString =@"document.getElementsByTagName('body')[0].style.background='#9DD6CA'";
            bacViewColor = @"#9DD6CA";
        }else if(row ==2){
            colorString =@"document.getElementsByTagName('body')[0].style.background='#EAE0CB'";
            bacViewColor = @"#EAE0CB";
        }else if(row ==3){
            colorString =@"document.getElementsByTagName('body')[0].style.background='#E7D8BE'";
            bacViewColor = @"#E7D8BE";
        }else if(row ==4){
            colorString =@"document.getElementsByTagName('body')[0].style.background='#273C32'";
            bacViewColor = @"#273C32";
        }
        
        if ([self.delegate respondsToSelector:@selector(getbackgroundColor:WithBackViewColor:WithSection:WithRow:)])
        {
            [self.delegate getbackgroundColor:colorString WithBackViewColor:bacViewColor WithSection:section WithRow:row];
        }
    }

    
    [self selfDismiss];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SectionHeadView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        [self.collectionView registerClass:[SectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadIdentifier];
        SectionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeadIdentifier forIndexPath:indexPath];
        NSString *title = nil;
        if (indexPath.section ==0) {
            title = @"字体设置";
        }else{
            title = @"设置背景色";
        }
        [headerView setLabelText:title];
        reusableview = headerView;
    }
    return reusableview;
 
}
#pragma mark - UICollectionViewDelegateLeftAlignedLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(cellWidth, 30);
    }
    return CGSizeMake(cellWidth, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(self.frame.size.width, 20);
    }
    return CGSizeMake(self.frame.size.width, 30);
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

#pragma mark -消失
- (void)completesettingEvent:(id)sender
{
    [self selfDismiss];
}
- (void)selfDismiss
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    [UIView animateWithDuration:0.35f animations:^{
        _botomView.frame = CGRectMake(0, height, width, 240);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
- (void)dealloc
{
    self.collectionView = nil;
    self.bgView = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
