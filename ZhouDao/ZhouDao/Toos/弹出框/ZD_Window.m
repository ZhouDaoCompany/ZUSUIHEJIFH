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

@implementation ZD_Window

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 179)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.cornerRadius = 3.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        [self initUI];
//        [self makeKeyAndVisible];
        
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
//    msgLab.textAlignment  = NSTextAlignmentCenter;
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
- (void)zd_Windowclose {WEAKSELF;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.35 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.zd_superView.center = CGPointMake(zd_width/2.0,-300);
        
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
