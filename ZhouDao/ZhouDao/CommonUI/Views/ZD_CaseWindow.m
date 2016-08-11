//
//  TheCaseWindow.m
//  TestDemo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 zhongGe. All rights reserved.
//

#import "ZD_CaseWindow.h"
#import "UIColor+Helper.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height

@interface ZD_CaseWindow()<UIScrollViewDelegate>

@property (nonatomic, copy) NSString *contentString;//内容
@property (nonatomic, copy) NSString *titleString;//标题

@property (nonatomic, strong) UIScrollView *contentjScrollView;
@property (nonatomic, strong) UIView *maskView;
@end
@implementation ZD_CaseWindow

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithContent:(NSString *)contentStr
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self addSubview:_maskView];
        [_maskView whenCancelTapped:^{
            
            [self zd_Windowclose];
        }];
        
        self.backgroundColor = [UIColor clearColor];
//        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, zd_width-100)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.cornerRadius = 3.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        //内容 标题
        self.contentString = contentStr;
        self.titleString = title;

        [self initUI];
//        [self makeKeyAndVisible];
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    
    float height = zd_width-100;

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 64)];
    headView.backgroundColor  = [UIColor clearColor];
    [self.zd_superView addSubview:headView];

    UILabel *titLab = [[UILabel alloc] init];
    titLab.center = headView.center;
    titLab.bounds = CGRectMake(0, 0, 100, 20);
    titLab.backgroundColor = [UIColor clearColor];
    titLab.text = self.titleString;
//    titLab.textColor = [UIColor whiteColor];
    titLab.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titLab];
    
    self.contentjScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, Orgin_y(headView) +10, zd_width-120, height-64.f)];
    self.contentjScrollView.showsVerticalScrollIndicator = NO;
    self.contentjScrollView.showsHorizontalScrollIndicator = NO;
    self.contentjScrollView.backgroundColor = [UIColor clearColor];
    //self.contentjScrollView.bounces = NO;
    [self.zd_superView addSubview:self.contentjScrollView];
    
    float width = self.contentjScrollView.frame.size.width;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f]};
    CGSize size = [self.contentString boundingRectWithSize:CGSizeMake(width,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width , size.height)];
    msgLab.font = [UIFont systemFontOfSize:14.f];
    msgLab.textAlignment  = NSTextAlignmentLeft;
    msgLab.numberOfLines = 0;
    msgLab.text = self.contentString;
    [self.contentjScrollView addSubview:msgLab];
    
    self.contentjScrollView.contentSize = CGSizeMake(width, msgLab.frame.size.height +10.f);
    
    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenCancelTapped:^{
        
        [self zd_Windowclose];
    }];
    

    
}
#pragma mark -关闭
- (void)zd_Windowclose {WEAKSELF;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,-zd_width+100);
        
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
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
