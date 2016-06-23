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
        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 300)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.borderWidth = 1;
        self.zd_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.zd_superView.layer.cornerRadius = 5.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 64)];
        headView.backgroundColor  = KNavigationBarColor;
        [self.zd_superView addSubview:headView];
        [self initUI];
        [self makeKeyAndVisible];
        
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    UILabel *msgLab = [[UILabel alloc] init];
    msgLab.center = self.zd_superView.center;
    msgLab.frame = CGRectMake(0, 100, zd_width-100, 30);
    msgLab.font = Font_14 ;
    msgLab.textAlignment  = NSTextAlignmentCenter;
    msgLab.text = @"暂未开发 -_-!!";
    [self.zd_superView addSubview:msgLab];
    
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.zd_superView.center = CGPointMake(zd_width/2.0,-300);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 点击消失
    [self zd_Windowclose];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
