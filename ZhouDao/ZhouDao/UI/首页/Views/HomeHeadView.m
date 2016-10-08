//
//  HomeHeadView.m
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "HomeHeadView.h"
#import "SDCycleScrollView.h"
#import "DPHorizontalScrollView.h"
#import "LawsKindView.h"
#import "BasicModel.h"
#import "MobClick.h"

#define lawWidth     [UIScreen mainScreen].bounds.size.width/4.f

@interface HomeHeadView()<SDCycleScrollViewDelegate,DPHorizontalScrollViewDelegate>
@property(nonatomic,strong) DPHorizontalScrollView *horizontalScrollView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSMutableArray *imageArrays;
@property (nonatomic,strong) NSMutableArray *titleArrays;
@property (nonatomic,strong) UIView *sectionView;

@end
@implementation HomeHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}
- (void)setDataArrays:(NSArray *)dataArrays
{
    if (dataArrays.count == 0) {
        return;
    }
    _dataArrays = nil;
    _dataArrays = dataArrays;
    __block  NSMutableArray *picArr   = [NSMutableArray array];
    __block  NSMutableArray *titleArr = [NSMutableArray array];
    [_dataArrays enumerateObjectsUsingBlock:^(BasicModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [picArr addObject:obj.slide_pic];
        [titleArr addObject:obj.slide_name];
    }];
    _cycleScrollView.imageURLStringsGroup = picArr;
//    _cycleScrollView.titlesGroup = titleArr;
}
- (void)initUI
{
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"home_Shuff"]];
//    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.titleLabelHeight = 25.f;
    _cycleScrollView.titleLabelTextFont = Font_14;
    _cycleScrollView.autoScrollTimeInterval = 3.f;
    _cycleScrollView.pageDotColor = [UIColor whiteColor];
    _cycleScrollView.currentPageDotColor = KNavigationBarColor;
//    _cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoresizingMask = YES;
    [self addSubview:_cycleScrollView];
    
    _titleArrays = [NSMutableArray arrayWithObjects:@"法律法规",@"案例查询",@"司法机关",@"赔偿标准", nil];
    _imageArrays = [NSMutableArray arrayWithObjects:@"home_fagui",@"tabbar_CaseQuery",@"tabbar_judicial",@"home_peichangbiaozhun", nil];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_cycleScrollView), width, 110)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self addSubview:bottomView];
    
    _horizontalScrollView = [[DPHorizontalScrollView alloc] initWithFrame:CGRectMake(0, Orgin_y(_cycleScrollView), width, 110)];
    _horizontalScrollView.scrollViewDelegate = self;
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    _horizontalScrollView.scrollsToTop = NO;
    [self addSubview:_horizontalScrollView];
    
    _sectionView = [[UIView alloc] initWithFrame: CGRectMake(0, height-55, width, 10)];
    _sectionView.backgroundColor = ViewBackColor;
    [self addSubview:_sectionView];
    
    UIView *hotView = [[UIView alloc] initWithFrame:CGRectMake(0, height-45, width, 45)];
    hotView.backgroundColor = [UIColor whiteColor];
    [self addSubview:hotView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 104/7.f, 20)];
    imgView.image = [UIImage imageNamed:@"home_hot"];
    [hotView addSubview:imgView];
    
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgView) +10, 12.5, 100, 20)];
    hotLab.text = @"时事热点";
    hotLab.font = Font_15;
    hotLab.textColor = KNavigationBarColor;
    [hotView addSubview:hotLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, width-15, .5f)];
    lineView.backgroundColor = LINECOLOR;
    [hotView addSubview:lineView];
    
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
    if ([self.delegate respondsToSelector:@selector(getSlideWithCount:)])
    {
        [self.delegate getSlideWithCount:index];
    }
}
#pragma mark - ---------------------- DPHorizontalScrollViewDelegate
- (NSInteger)numberOfColumnsInTableView:(DPHorizontalScrollView *)tableView{
    
    return [_titleArrays count];
}
- (CGFloat)tableView:(DPHorizontalScrollView *)tableView widthForColumnAtIndex:(NSInteger)index{
    return lawWidth;
}
- (UIView *)tableView:(DPHorizontalScrollView *)tableView viewForColumnAtIndex:(NSInteger)index{
    LawsKindView *view = [tableView reusableView];
    if (!view) {
        view = [[LawsKindView alloc] init];
    }
    view.type = HomeFrom;
    view.indexBlock = ^(NSInteger index){
        
        
        if (_indexBlock) {
            
            NSMutableArray *eventIDArray = [NSMutableArray arrayWithObjects:@"SYfaLvFaGui",@"SYanLiChaXun",@"SYsiFaJiGuan",@"SYpeiChangBZ", nil];
            [MobClick event:eventIDArray[index] label:@"首页"];

            _indexBlock(index);
        }
    };
    if (_imageArrays.count !=0) {
        [view setImgViewImageName:_imageArrays[index] WithLabelText:_titleArrays[index]];
    }
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
