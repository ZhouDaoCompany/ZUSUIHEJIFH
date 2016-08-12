//
//  ZD_Window.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZD_Window.h"

#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height
static CGFloat kTransitionDuration = 0.3f;

@interface ZD_Window ()

@property (nonatomic ,strong) UIView *zd_superView;
@end
@implementation ZD_Window

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        [self addSubview:self.zd_superView];
        [self initUI];
        [self bounce0Animation];
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 64)];
    headView.backgroundColor  = [UIColor clearColor];
    [self.zd_superView addSubview:headView];

    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, zd_width-150, 20)];
    headlab.text = @"审查说明";
    headlab.textAlignment = NSTextAlignmentLeft;
    headlab.font = Font_18;
    [self.zd_superView addSubview:headlab];
    
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.center = self.zd_superView.center;
    msgLab.frame = CGRectMake(15, 54, zd_width-130, 100);
    msgLab.font = Font_14 ;
    msgLab.numberOfLines = 0;
    msgLab.text = @"已审查：信息已和官方网站信息核对一致。\n \n未审查：信息正在马不停蹄的审核中，请您耐心等待。";
    [self.zd_superView addSubview:msgLab];
    
    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenTapped:^{
        
        [self zd_Windowclose];
    }];
    
}
#pragma mark -关闭
- (void)zd_Windowclose {

    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:kTransitionDuration];
    self.alpha = 0.0;
    [UIView commitAnimations];
}
#pragma mark - setters and getters
- (UIView *)zd_superView
{
    if (!_zd_superView) {
        _zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 179)];
        _zd_superView.backgroundColor = [UIColor whiteColor];
        _zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        _zd_superView.layer.cornerRadius = 3.f;
        _zd_superView.clipsToBounds = YES;
    }
    return _zd_superView;
}
#pragma mark -
#pragma mark animation

- (void)bounce0Animation{
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.001f, 0.001f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 1.1f, 1.1f);
    [UIView commitAnimations];
}

- (void)bounce1AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationDidStop)];
    self.zd_superView.transform = CGAffineTransformScale([AnimationTools transformForOrientation], 0.9f, 0.9f);
    [UIView commitAnimations];
}
- (void)bounce2AnimationDidStop{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(bounceDidStop)];
    self.zd_superView.transform = [AnimationTools transformForOrientation];
    [UIView commitAnimations];
}

- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(self.zd_superView)
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
