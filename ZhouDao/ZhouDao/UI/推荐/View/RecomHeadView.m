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
#import "MobClick.h"

#define oftenLaws     [UIScreen mainScreen].bounds.size.width*(311.f/750.f)
@interface RecomHeadView()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) FlipPageView *adView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imageArrays;
@property (nonatomic, strong) NSMutableArray *titleArrays;
@property (strong, nonatomic) UIView *newslLawView;
@property (strong, nonatomic) UIImageView *imgView3;
@property (strong, nonatomic) UIView *backgroundView;//背景
@property (strong, nonatomic) UILabel *textLabel;//文字描述
@end

@implementation RecomHeadView

- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_adView);
    TTVIEW_RELEASE_SAFELY(_cycleScrollView);
    TTVIEW_RELEASE_SAFELY(_imgView3);
    TTVIEW_RELEASE_SAFELY(_newslLawView);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self initUI];
    }
    return self;
}
#pragma mark - private methods

- (void)initUI
{
    WEAKSELF;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    [self addSubview:self.cycleScrollView];
    
    //新法速递
    [self addSubview:self.newslLawView];
    
    UIImageView *newImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
    newImg.image = [UIImage imageNamed:@"recommedNew"];
    [_newslLawView addSubview:newImg];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(newImg) +5.5f, 15, 62, 20)];
    titLab.font = Font_15;
    titLab.textColor = THIRDCOLOR;
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
        
        
        [MobClick event:@"TJCYFG" label:@"推荐"];

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
        
        [MobClick event:@"TJPCBZ" label:@"推荐"];

        if ([weakSelf.delegate respondsToSelector:@selector(theCompensationStandard)])
        {
            [weakSelf.delegate theCompensationStandard];
        }
    }];
    
    
    //3
    [imgBgView addSubview:self.imgView3];
    
    [self.imgView3 addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.textLabel];

    
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
    lineView.backgroundColor = LINECOLOR;
    [hotView addSubview:lineView];
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    [MobClick event:@"TJLunBo" label:@"推荐"];
    DLog(@"---点击了第%ld张图片", (long)index);
    //    NSString *str = [NSString stringWithFormat:@"%ld",(long)index];
    //    SHOW_ALERT(str);
    if ([self.delegate respondsToSelector:@selector(getSlideWithCount:)])
    {
        [self.delegate getSlideWithCount:index];
        
    }
}

#pragma mark - setters and getters

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        float width = self.bounds.size.width;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, 150) delegate:self placeholderImage:[UIImage imageNamed:@"home_Shuff"]];
        //    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.titleLabelHeight = 30.f;
        _cycleScrollView.titleLabelTextFont = Font_14;
        _cycleScrollView.autoScrollTimeInterval = 3.f;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = KNavigationBarColor;
        //_cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoresizingMask = YES;
    }
    return _cycleScrollView;
}
- (UIView *)newslLawView{
    if (!_newslLawView) {
        float width = self.bounds.size.width;
        _newslLawView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_cycleScrollView), width, 50)];
        _newslLawView.backgroundColor = [UIColor whiteColor];
    }
    return _newslLawView;
}
- (UIImageView *)imgView3
{WEAKSELF;
    float width = self.bounds.size.width;
    if (!_imgView3) {
        _imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(oftenLaws +.5f, 0 , width - oftenLaws-.5f, 124.f)];
        _imgView3.userInteractionEnabled = YES;
        
        [_imgView3 whenCancelTapped:^{
            
            [MobClick event:@"TJMRLB" label:@"推荐"];

            if ([weakSelf.delegate respondsToSelector:@selector(recommendTheArticle)])
            {
                [weakSelf.delegate recommendTheArticle];
            }
            
        }];
    }
    return _imgView3;
}
- (void)setFlipPageArr:(NSArray *)flipPageArr
{WEAKSELF;
    _flipPageArr = nil;
    _flipPageArr = flipPageArr;
    
    NSMutableArray *nameArr = [NSMutableArray array];
    [flipPageArr enumerateObjectsUsingBlock:^(GovListmodel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj.name isEqual:[NSNull null]]) {
            [nameArr addObject:obj.name];
        }
    }];

    if (_adView) {
        
        TTVIEW_RELEASE_SAFELY(_adView);
    }
    //广告文字
    [_newslLawView addSubview:self.adView];
    [_adView startAdsWithBlock:nameArr block:^(NSInteger clickIndex){
        
        
        [MobClick event:@"TJxinFaSuDi" label:@"推荐"];

        [weakSelf.adView stopAds];
        DLog(@"%d",(int)clickIndex);
        GovListmodel *model = _flipPageArr[clickIndex];
        if ([weakSelf.delegate respondsToSelector:@selector(startAdsClick:)])
        {
            [weakSelf.delegate startAdsClick:model.id];
        }
    }];
}
- (FlipPageView *)adView
{
    if (!_adView) {
        float width = self.bounds.size.width;
        _adView = [[FlipPageView alloc] initWithFrame:CGRectMake(118.5f, 5,width - 118.5f, 40)];
        _adView.iDisplayTime = 3.f;
    }
    return _adView;
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
- (void)setJdArrays:(NSArray *)jdArrays {
    
    if (jdArrays.count ==0) {
        return;
    }
    _jdArrays = nil;
    _jdArrays = jdArrays;
    BasicModel *model = _jdArrays[0];
    [_imgView3 sd_setImageWithURL:[NSURL URLWithString:model.slide_pic] placeholderImage:[UIImage imageNamed:@"recommedArticle.jpg"]];
    
    if (model.slide_name.length > 0) {
        
        _backgroundView.hidden = NO;
        _textLabel.hidden = NO;
        _textLabel.text = model.slide_name;
    } else {
        _backgroundView.hidden = YES;
        _textLabel.hidden = YES;
        _textLabel.text = @"";
    }
}
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:_imgView3.bounds];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _backgroundView;
}
- (UILabel *)textLabel {
    
    if (!_textLabel) {
        float width = self.bounds.size.width - oftenLaws - 20.5f;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, width, 60)];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = Font_13;
    }
    return _textLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
