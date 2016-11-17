//
//  LPCameraBrowerCell.m
//  ContinuousShooting
//
//  Created by apple on 16/11/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LPCameraBrowerCell.h"

@interface LPCameraBrowerCell() <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    
    CGFloat _browser_width;
    CGFloat _browser_height;
}

@property (nonatomic, strong) UIScrollView *scaleView;
@property (nonatomic, strong) UIImageView *photo_image_view;

@end

@implementation LPCameraBrowerCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initUI];
    }
    return self;
}
#pragma mark - private methods
- (void)initUI {
    
    _browser_width = [UIScreen mainScreen].bounds.size.width;
    _browser_height = [UIScreen mainScreen].bounds.size.height;
    
    [self.contentView addSubview:self.scaleView];
    [_scaleView addSubview:self.photo_image_view];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    [_photo_image_view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    [_photo_image_view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];

}

-(void)changeFrameWithImage:(UIImage *)image
{
    CGFloat height = image.size.height / image.size.width * _browser_width;
    self.photo_image_view.frame = CGRectMake(0, 0, _browser_width, height);
    self.photo_image_view.center = CGPointMake(_browser_width / 2, _browser_height / 2);
    _scaleView.contentSize = CGSizeMake(_browser_width, MAX(self.photo_image_view.frame.size.height, _browser_height));
}

-(void)loadPicData:(UIImage *)image
{
    if (image != nil) {
        [self changeFrameWithImage:image];
        _photo_image_view.image = image;
    }
}

-(void)recoverSubview
{
    [_scaleView setZoomScale:1.0 animated:NO];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _photo_image_view;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _photo_image_view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                           scrollView.contentSize.height * 0.5 + offsetY);
}

-(void)singleTapHandle:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickSingleFingerAtScreen)]) {
        [self.delegate clickSingleFingerAtScreen];
    }
}


- (void)doubleTapHandle:(UITapGestureRecognizer *)sender
{
    if (_scaleView.zoomScale > 1.0) {
        [_scaleView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [sender locationInView:self.photo_image_view];
        CGFloat maxScale = _scaleView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / maxScale;
        CGFloat ysize = self.frame.size.height / maxScale;
        [_scaleView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - setter and getter
- (UIImageView *)photo_image_view {
    
    if (!_photo_image_view) {
        
        _photo_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _browser_width, _browser_height)];
        _photo_image_view.contentMode = UIViewContentModeScaleAspectFit;
        _photo_image_view.userInteractionEnabled = YES;
    }
    return _photo_image_view;
}
- (UIScrollView *)scaleView {
    
    if (!_scaleView) {
        _scaleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _browser_width, _browser_height)];
        _scaleView.delegate = self;
        _scaleView.maximumZoomScale = 2.5;
        _scaleView.minimumZoomScale = 1.0;
        _scaleView.bouncesZoom = YES;
        _scaleView.multipleTouchEnabled = YES;
        _scaleView.delegate = self;
        _scaleView.scrollsToTop = NO;
        _scaleView.showsHorizontalScrollIndicator = NO;
        _scaleView.showsVerticalScrollIndicator = NO;
        _scaleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scaleView.delaysContentTouches = NO;
        _scaleView.canCancelContentTouches = YES;
        _scaleView.alwaysBounceVertical = NO;
    }
    return _scaleView;
}


@end
