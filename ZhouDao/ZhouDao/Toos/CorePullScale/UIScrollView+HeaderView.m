//
//  UIScrollView+HeaderView.m
//  tableViewCover
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 sunhw. All rights reserved.
//

#import "UIScrollView+HeaderView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
static char kHeaderView;
@implementation UIScrollView (HeaderView)
@dynamic headerView;
-(void)setHeaderView:(MyHeaderImageView *)headerView{
    objc_setAssociatedObject(self, &kHeaderView, headerView, OBJC_ASSOCIATION_ASSIGN);
}

-(MyHeaderImageView *)headerView{
    return objc_getAssociatedObject(self, &kHeaderView);
}

-(void)addScrollViewHeaderWithImage:(UIImage *)image withHeight:(CGFloat)imgheight target:(id)target{
    UIScrollView *scrollView = (UIScrollView *)self;
    MyHeaderImageView *header = [[MyHeaderImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenSize.width, imgheight)];
    header.delegate = target;
    header.imageHeight = imgheight;
    header.scrollView = scrollView;
    header.image = image;
    [scrollView addSubview:header];
    self.headerView = header;
}

@end

@implementation MyHeaderImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeader:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)clickHeader:(UITapGestureRecognizer *)tap{
    MyHeaderImageView *header = (MyHeaderImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(clickHeaderView:)]) {
        [self.delegate performSelector:@selector(clickHeaderView:) withObject:header];
    }
}

- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}


-(void)setScrollView:(UIScrollView *)scrollView{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_scrollView.contentOffset.y < 0) {
        CGFloat offset = -_scrollView.contentOffset.y;
        self.frame = CGRectMake(-offset, -offset, KScreenSize.width+offset*2, _imageHeight+offset);
    }else{
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self setNeedsLayout];
}
@end

