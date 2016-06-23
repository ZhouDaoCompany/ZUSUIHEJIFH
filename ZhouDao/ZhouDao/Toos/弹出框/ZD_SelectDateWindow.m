//
//  ZD_SelectDateWindow.m
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZD_SelectDateWindow.h"
#import "ZHPickView.h"

#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height


@implementation ZD_SelectDateWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.windowLevel = UIWindowLevelAlert;
        
        self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 230)];
        self.zd_superView.backgroundColor = [UIColor whiteColor];
        self.zd_superView.center = CGPointMake(zd_width/2.0,0);
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
        } completion:^(BOOL finished) {
        }];
        self.zd_superView.layer.borderWidth = 1.f;
        self.zd_superView.layer.borderColor = [UIColor clearColor].CGColor;
        self.zd_superView.layer.cornerRadius = 5.f;
        self.zd_superView.clipsToBounds = YES;
        [self addSubview:self.zd_superView];
        
        [self initUI];
        [self makeKeyAndVisible];
    }
    return self;
}
#pragma mark -布局界面
- (void)initUI
{
    
    
//    [self whenTapped:^{
//        
//        [self zd_Windowclose];
//    }];

    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, zd_width-100, 60)];
    headView.backgroundColor  = KNavigationBarColor;
    [self.zd_superView addSubview:headView];
    
    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, zd_width-100, 20)];
    headlab.text = @"选择裁判日期";
    headlab.textAlignment = NSTextAlignmentCenter;
    headlab.font = Font_18;
    headlab.textColor = [UIColor whiteColor];
    [self.zd_superView addSubview:headlab];
    

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, zd_width - 130, 80)];
    [self.zd_superView addSubview:backView];
    
    float width = backView.frame.size.width;
    
    UIImageView *imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 16, 15)];
    imgview1.image = [UIImage imageNamed:@"Esearch_dateSelect"];
    imgview1.userInteractionEnabled = YES;
    imgview1.contentMode = UIViewContentModeScaleAspectFit;
    [backView addSubview:imgview1];
    
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgview1) +10, 10,width - Orgin_x(imgview1) -25 , 20)];
    startLab.textColor = thirdColor;
    startLab.text = @"请选择开始时间";
    startLab.textAlignment = NSTextAlignmentLeft;
    startLab.font = [UIFont boldSystemFontOfSize:15.f];
    _startLab = startLab;
    [backView addSubview:_startLab];
    
    WEAKSELF;
    [_startLab whenCancelTapped:^{
        

        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showWindowPickView:self];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            weakSelf.startLab.text = selectedStr;
        };
        
    }];
    
    UIImageView *imgview3 = [[UIImageView alloc] initWithFrame:CGRectMake(Orgin_x(startLab) +9, 15, 6, 10)];
    imgview3.image = [UIImage imageNamed:@"Esearch_jiantou"];
    imgview3.userInteractionEnabled = YES;
    [backView addSubview:imgview3];

    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, width, .6f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [backView addSubview:lineView];

    UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 54, 16, 15)];
    imgview2.contentMode = UIViewContentModeScaleAspectFit;
    imgview2.image = [UIImage imageNamed:@"Esearch_dateSelect"];
    imgview2.userInteractionEnabled = YES;
    [backView addSubview:imgview2];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(imgview2) +10, 51,width - Orgin_x(imgview2) -25 , 20)];
    endLab.text = @"请选择结束时间";
    endLab.textAlignment = NSTextAlignmentLeft;
    endLab.textColor = thirdColor;
    endLab.font = [UIFont boldSystemFontOfSize:15.f];
    _endLab = endLab;
    [backView addSubview:_endLab];
    
    [_endLab whenCancelTapped:^{
        
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showWindowPickView:self];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            weakSelf.endLab.text = selectedStr;
        };
        
    }];

    
    UIImageView *imgview4 = [[UIImageView alloc] initWithFrame:CGRectMake(Orgin_x(endLab) +9, 56, 6, 10)];
    imgview4.image = [UIImage imageNamed:@"Esearch_jiantou"];
    imgview4.userInteractionEnabled = YES;
    [backView addSubview:imgview4];

    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 79, width, .6f)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
    [backView addSubview:lineView2];

    
    
    //按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = Font_15;
    cancelBtn.tag = 3001;
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#d2d2d2"];
    cancelBtn.frame = CGRectMake(15, Orgin_y(backView) +15, (width-15)/2.f , 40);
    [cancelBtn setTitle:@"取消" forState:0];
    //    navBtn.layer.masksToBounds = YES;
    //    navBtn.layer.cornerRadius = 5.f;
    [cancelBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.zd_superView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = KNavigationBarColor;
    sureBtn.titleLabel.font = Font_15;
    sureBtn.tag = 3002;
    sureBtn.frame = CGRectMake(Orgin_x(cancelBtn) +15.f, Orgin_y(backView) +15, (width-15)/2.f , 40);
    [sureBtn setTitle:@"确定" forState:0];
    //    navBtn.layer.masksToBounds = YES;
    //    navBtn.layer.cornerRadius = 5.f;
    [sureBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.zd_superView addSubview:sureBtn];
    
    [self.zd_superView whenCancelTapped:^{
        
    }];
    
    [self whenTapped:^{
        
        [self zd_Windowclose];
    }];
    

}

- (void)cancelOrSureEvent:(id)sender
{
    DLog(@"点击去导航按钮");
    
    UIButton *btn = (UIButton *)sender;
    
    NSUInteger index = btn.tag;
    
    if (index == 3002)
    {
        if (![_startLab.text isEqualToString:@"请选择开始时间"] && ![_endLab.text isEqualToString:@"请选择结束时间"]) {
            self.selectBlock(_startLab.text,_endLab.text);
            
            [self zd_Windowclose];

        }

    }else if(index == 3001){
        [self zd_Windowclose];

    }
    
    
}
#pragma mark -关闭
- (void)zd_Windowclose {
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.zd_superView.center = CGPointMake(zd_width/2.0,-230);
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
