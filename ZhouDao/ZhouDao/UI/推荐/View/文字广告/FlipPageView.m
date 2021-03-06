//
//  FlipPageView.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FlipPageView.h"
#import "JX_GCDTimerManager.h"

@interface FlipPageView() <UIScrollViewDelegate>
@property (nonatomic, assign) int                   indexShow;
@property (nonatomic, strong) NSArray               *arrText;
@property (nonatomic, strong) UIScrollView          *scView;
@property (nonatomic, strong) UILabel               *labelPrev;
@property (nonatomic, strong) UILabel               *labelCurrent;
@property (nonatomic, strong) UILabel               *labelNext;
@property (nonatomic, copy)   NSString               *myTimer;

@property (nonatomic, copy)   ZDIndexBlock          myBlock;

@end
@implementation FlipPageView

- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_scView);
    TTVIEW_RELEASE_SAFELY(_labelPrev);
    TTVIEW_RELEASE_SAFELY(_labelNext);
    TTVIEW_RELEASE_SAFELY(_labelCurrent);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initUI];
}
- (void)initUI {

    
    [self addSubview:self.scView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAds)];
    [_scView addGestureRecognizer:tap];
    
    _myTimer = @"shuffling";
    [_scView addSubview:self.labelPrev];
    [_scView addSubview:self.labelCurrent];
    [_scView addSubview:self.labelNext];
}
- (UIScrollView *)scView
{
    if (!_scView) {
        float height = self.frame.size.height;
        float width = self.frame.size.width;

        _scView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scView.delegate = self;
        _scView.pagingEnabled = YES;
        _scView.bounces = NO;
        _scView.contentSize = CGSizeMake(width, height*3);
        _scView.showsHorizontalScrollIndicator = NO;
        _scView.showsVerticalScrollIndicator = NO;
        _scView.scrollsToTop = NO;
        [_scView setTranslatesAutoresizingMaskIntoConstraints:YES];
    }
    return _scView;
}
- (UILabel *)labelPrev
{
    if (!_labelPrev) {
        float height = self.frame.size.height;
        float width = self.frame.size.width;

        _labelPrev = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _labelPrev.textColor = THIRDCOLOR;
        _labelPrev.font = Font_15;
        _labelPrev.numberOfLines = 0;
        _labelPrev.textAlignment = NSTextAlignmentLeft;
    }
    return _labelPrev;
}
- (UILabel *)labelCurrent
{
    if (!_labelCurrent) {
        float height = self.frame.size.height;
        float width = self.frame.size.width;

        _labelCurrent = [[UILabel alloc] initWithFrame:CGRectMake(0, height, width, height)];
        _labelCurrent.textColor = THIRDCOLOR;
        _labelCurrent.font = Font_15;
        _labelCurrent.numberOfLines = 0;
        _labelCurrent.textAlignment = NSTextAlignmentLeft;
    }
    return _labelCurrent;
}
- (UILabel *)labelNext
{
    if (!_labelNext) {
        float height = self.frame.size.height;
        float width = self.frame.size.width;

        _labelNext = [[UILabel alloc] initWithFrame:CGRectMake(0, 2*height, width, height)];
        _labelNext.textColor = THIRDCOLOR;
        _labelNext.font = Font_15;
        _labelNext.numberOfLines = 0;
        _labelNext.textAlignment = NSTextAlignmentLeft;
    }
    return _labelNext;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    float height = self.frame.size.height;
    float width = self.frame.size.width;

    _labelPrev.frame = CGRectMake(0, 0, width, height);
    _labelCurrent.frame = CGRectMake(0, height, width, height);
    _labelNext.frame = CGRectMake(0, height*2, width, height);
}
/**
 *  启动函数
 *
 *  @param textArray 文字数组
 *  @param block      click回调
 */
- (void)startAdsWithBlock:(NSArray*)textArray block:(ZDIndexBlock)block {
    if (textArray.count==0) {
        return;
    }
    if(textArray.count <= 1) {
        _scView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    }
    _arrText = textArray;
    self.myBlock = block;
    [self reloadTexts];
}
- (void)stopAds {
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:_myTimer];
}
/**
 *  点击lab
 */
- (void)tapAds
{
    if (self.myBlock != NULL) {
        self.myBlock(_indexShow);
    }
//    if (_myTimer){
//        [_myTimer invalidate];
//        _myTimer = nil;
//    }
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:_myTimer];

    if (_iDisplayTime > 0)
        [self startTimerPlay];
}
/**
 *  加载label顺序
 */
- (void)reloadTexts {
    if (_indexShow >= (int)_arrText.count)
        _indexShow = 0;
    if (_indexShow < 0)
        _indexShow = (int)_arrText.count - 1;
    int prev = _indexShow - 1;
    if (prev < 0)
        prev = (int)_arrText.count - 1;
    int next = _indexShow + 1;
    if (next > _arrText.count - 1)
        next = 0;
    NSString* prevstr = [_arrText objectAtIndex:prev];
    NSString* curstr = [_arrText objectAtIndex:_indexShow];
    NSString* nextstr = [_arrText objectAtIndex:next];
    _labelPrev.text = prevstr;
    _labelCurrent.text = curstr;
    _labelNext.text = nextstr;
    [_scView scrollRectToVisible:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height) animated:NO];
    if (_iDisplayTime > 0)
        [self startTimerPlay];
}
/**
 *  切换文字完毕事件
 *
 *  @param scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:_myTimer];
    if (scrollView.contentOffset.y >=self.frame.size.height*2)
        _indexShow++;
    else if (scrollView.contentOffset.y < self.frame.size.height)
        _indexShow--;
    [self reloadTexts];
}
- (void)startTimerPlay { WEAKSELF;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:_myTimer
                                                           timeInterval:_iDisplayTime
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
         [weakSelf doTextGoDisplay];
    }];
    
}
/**
 *  轮播文字
 */
- (void)doTextGoDisplay { WEAKSELF;
    [_scView scrollRectToVisible:CGRectMake(0, self.frame.size.height*2, self.frame.size.width, self.frame.size.height) animated:YES];
    _indexShow++;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf reloadTexts];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
