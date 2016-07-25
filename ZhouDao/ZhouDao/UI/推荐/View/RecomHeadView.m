//
//  RecomHeadView.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RecomHeadView.h"
#import "SDCycleScrollView.h"
#import "FlipPageView.h"
#import "GovListmodel.h"
#import "BasicModel.h"
#define oftenLaws     [UIScreen mainScreen].bounds.size.width*(311.f/750.f)
@interface RecomHeadView()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) FlipPageView *adView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imageArrays;
@property (nonatomic, strong) NSMutableArray *titleArrays;
@property (strong, nonatomic) UIView *newslLawView;
@property (strong, nonatomic) UIImageView *imgView3;
@end

@implementation RecomHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self initUI];
    }
    return self;
}
- (void)setFlipPageArr:(NSArray *)flipPageArr
{WEAKSELF;
    _flipPageArr = nil;
    _flipPageArr = flipPageArr;
    float width = self.bounds.size.width;
    
    NSMutableArray *nameArr = [NSMutableArray array];
    [flipPageArr enumerateObjectsUsingBlock:^(GovListmodel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj.name isEqual:[NSNull null]]) {
            [nameArr addObject:obj.name];
        }
    }];

    if (_adView) {
        [_adView removeFromSuperview];
    }
    //广告文字
    _adView = [[FlipPageView alloc] initWithFrame:CGRectMake(118.5f, 5,width - 118.5f, 40)];
    _adView.iDisplayTime = 3.f;
    
    [_adView startAdsWithBlock:nameArr block:^(NSInteger clickIndex){
        [weakSelf.adView stopAds];
        DLog(@"%d",(int)clickIndex);
        GovListmodel *model = _flipPageArr[clickIndex];
        if ([weakSelf.delegate respondsToSelector:@selector(startAdsClick:)])
        {
            [weakSelf.delegate startAdsClick:model.id];
        }
    }];
    [_newslLawView addSubview:_adView];
}
- (void)setRecomArrays:(NSArray *)recomArrays
{
    if(recomArrays.count ==0){
        return;
    }
    _recomArrays  = nil;
    _recomArrays = recomArrays;
   __block  NSMutableArray *picArr   = [NSMutableArray array];
   __block  NSMutableArray *titleArr = [NSMutableArray array];
    [_recomArrays enumerateObjectsUsingBlock:^(BasicModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [picArr addObject:obj.slide_pic];
        [titleArr addObject:obj.slide_name];
    }];
    _cycleScrollView.imageURLStringsGroup = picArr;
    _cycleScrollView.titlesGroup = titleArr;
}
- (void)setJdArrays:(NSArray *)jdArrays
{
    if (jdArrays.count ==0) {
        return;
    }
    _jdArrays = nil;
    _jdArrays = jdArrays;
    BasicModel *model = _jdArrays[0];
    [_imgView3 sd_setImageWithURL:[NSURL URLWithString:model.slide_pic] placeholderImage:[UIImage imageNamed:@"recommedArticle.jpg"]];
}

- (void)initUI
{
    WEAKSELF;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"home_Shuff"]];
    //    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.titleLabelHeight = 30.f;
    _cycleScrollView.titleLabelTextFont = Font_15;
    _cycleScrollView.autoScrollTimeInterval = 3.f;
    _cycleScrollView.pageDotColor = [UIColor whiteColor];
    _cycleScrollView.currentPageDotColor = KNavigationBarColor;
    //_cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
   _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoresizingMask = YES;
    [self addSubview:_cycleScrollView];
    
    //新法速递
    UIView *newslLawView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_cycleScrollView), width, 50)];
    newslLawView.backgroundColor = [UIColor whiteColor];
    _newslLawView = newslLawView;
    [self addSubview:_newslLawView];
    
    UIImageView *newImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    newImg.image = [UIImage imageNamed:@"recommedNew"];
    [_newslLawView addSubview:newImg];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(newImg) +7.5f, 15, 60, 20)];
    titLab.font = Font_15;
    titLab.textColor = thirdColor;
    titLab.text = @"新法速递";
    [_newslLawView addSubview:titLab];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(titLab) +10.f, 15, 1.f, 20.f)];
    verticalLine.backgroundColor = KNavigationBarColor;
    [_newslLawView addSubview:verticalLine];
    
    
    //图片
    UIView *imgBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_newslLawView),width , 124.f)];
    imgBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:imgBgView];
    
    //1
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, oftenLaws, 61.75f)];
    imgView1.image = [UIImage imageNamed:@"commonRegulations"];
    imgView1.userInteractionEnabled = YES;
    [imgBgView addSubview:imgView1];
    [imgView1 whenCancelTapped:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(commonRegulations)])
        {
            [weakSelf.delegate commonRegulations];
        }
        
    }];

    
    //2
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, Orgin_y(imgView1) +.5f, oftenLaws, 61.75f)];
    imgView2.image = [UIImage imageNamed:@"CompensationStandard"];
    imgView2.userInteractionEnabled = YES;
    [imgBgView addSubview:imgView2];
    [imgView2 whenCancelTapped:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(theCompensationStandard)])
        {
            [weakSelf.delegate theCompensationStandard];
        }
    }];

    
    //3
    _imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(oftenLaws +.5f, 0 , width - oftenLaws-.5f, 124.f)];
//    _imgView3.image = [UIImage imageNamed:@"recommedArticle"];
    _imgView3.userInteractionEnabled = YES;
    [imgBgView addSubview:_imgView3];

    [_imgView3 whenCancelTapped:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(recommendTheArticle)])
        {
            [weakSelf.delegate recommendTheArticle];
        }

    }];

    
    UIView *sectionView = [[UIView alloc] initWithFrame: CGRectMake(0, height-55, width, 10)];
    sectionView.backgroundColor = ViewBackColor;
    [self addSubview:sectionView];
    
    //时事热点
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
    lineView.backgroundColor = lineColor;
    [hotView addSubview:lineView];

}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DLog(@"---点击了第%ld张图片", (long)index);
//    NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
//    SHOW_ALERT(str);
    if ([self.delegate respondsToSelector:@selector(getSlideWithCount:)])
    {
        [self.delegate getSlideWithCount:index];
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
