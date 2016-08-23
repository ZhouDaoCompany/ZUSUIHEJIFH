//
//  PushAlertWindow.m
//  ZhouDao
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "PushAlertWindow.h"
#import "UIColor+Helper.h"
#define zd_width [UIScreen mainScreen].bounds.size.width
#define zd_height [UIScreen mainScreen].bounds.size.height
#define kContentLabelWidth     13.f/16.f*([UIScreen mainScreen].bounds.size.width)

@interface PushAlertWindow()<UIScrollViewDelegate>

@property (nonatomic, copy) NSString *contentString;//内容
@property (nonatomic, copy) NSString *titleString;//标题

@property (nonatomic, strong) UIScrollView *contentjScrollView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation PushAlertWindow

- (id)initWithFrame:(CGRect)frame
          WithTitle:(NSString *)title
        WithContent:(NSString *)contentStr
           withType:(NSUInteger)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        //内容 标题
        self.contentString = contentStr;
        self.titleString = title;
        self.type = type;
        
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.zd_superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContentLabelWidth, 224)];
    self.zd_superView.backgroundColor = [UIColor whiteColor];
    self.zd_superView.center = CGPointMake(zd_width/2.0,0);
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.zd_superView.center = CGPointMake(zd_width/2.0,zd_height/2.0);
    } completion:^(BOOL finished) {
    }];

    self.zd_superView.layer.cornerRadius = 3.f;
    self.zd_superView.clipsToBounds = YES;
    [self addSubview:self.zd_superView];
    
    /**
     *
     */
     float height = 224;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContentLabelWidth, 54)];
    headView.backgroundColor  = [UIColor clearColor];
    [self.zd_superView addSubview:headView];
    
    UILabel *titLab = [[UILabel alloc] init];
    titLab.center = headView.center;
    titLab.bounds = CGRectMake(0, 0, kContentLabelWidth- 30, 20);
    titLab.backgroundColor = [UIColor clearColor];
    titLab.text = self.titleString;
//    titLab.textColor = [UIColor whiteColor];
    titLab.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titLab];
    
    self.contentjScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, Orgin_y(headView) +10, kContentLabelWidth -20, height-114.f)];
    self.contentjScrollView.showsVerticalScrollIndicator = NO;
    self.contentjScrollView.showsHorizontalScrollIndicator = NO;
    self.contentjScrollView.backgroundColor = [UIColor clearColor];
    //self.contentjScrollView.bounces = NO;
    [self.zd_superView addSubview:self.contentjScrollView];

    float width = self.contentjScrollView.frame.size.width;
    
    NSDictionary *attribute = @{NSFontAttributeName:Font_15};
    CGSize size = [_contentString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    UILabel *msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width , size.height)];
    msgLab.font = [UIFont systemFontOfSize:15.f];
    msgLab.numberOfLines = 0;
    msgLab.text = self.contentString;
    [self.contentjScrollView addSubview:msgLab];
    
    if (size.height<height-114.f) {
       
        msgLab.center = CGPointMake( _contentjScrollView.center.x, _contentjScrollView.center.y);
        msgLab.bounds = CGRectMake(0, 0, width, size.height);
        msgLab.frame = CGRectMake(0, ((height-114.f)-size.height)/2.f , width, size.height);
        msgLab.textAlignment  = NSTextAlignmentCenter;
        self.contentjScrollView.contentSize = CGSizeMake(width, _contentjScrollView.frame.size.height);
    }else{
        msgLab.textAlignment  = NSTextAlignmentCenter;
        self.contentjScrollView.contentSize = CGSizeMake(width, msgLab.frame.size.height +10.f);
    }
    
    
    if (_type == 1  || _type == 3) {
        
        UIButton *botomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        botomBtn.backgroundColor = KNavigationBarColor;
        botomBtn.titleLabel.font = Font_15;
        botomBtn.tag = 4003;
        botomBtn.frame = CGRectMake(15.f, Orgin_y(_contentjScrollView) +5, kContentLabelWidth - 30 , 40);
        [botomBtn setTitle:@"确定" forState:0];
        botomBtn.layer.masksToBounds = YES;
        botomBtn.layer.cornerRadius = 5.f;
        [botomBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.zd_superView addSubview:botomBtn];
        
    }else {
        
        //按钮
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.titleLabel.font = Font_15;
        cancelBtn.tag = 4001;
        cancelBtn.backgroundColor = KNavigationBarColor;
        cancelBtn.frame = CGRectMake(15, Orgin_y(_contentjScrollView) +5, (kContentLabelWidth - 45.f)/2.f , 40);
        [cancelBtn setTitle:@"取消" forState:0];
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.cornerRadius = 5.f;

        [cancelBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.zd_superView addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.backgroundColor = KNavigationBarColor;
        sureBtn.titleLabel.font = Font_15;
        sureBtn.tag = 4002;
        sureBtn.frame = CGRectMake(Orgin_x(cancelBtn) +15.f, Orgin_y(_contentjScrollView) +5, (kContentLabelWidth - 45.f)/2.f , 40);
        [sureBtn setTitle:@"确定" forState:0];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.f;
        [sureBtn addTarget:self action:@selector(cancelOrSureEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.zd_superView addSubview:sureBtn];
    }

    [self.zd_superView whenCancelTapped:^{
        
    }];
    
}
- (void)cancelOrSureEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    
    switch (index) {
        case 4001:
        {//取消
            
        }
            break;
        case 4002:
        {//确定
            if (_pushBlock) {
                
            }
            _pushBlock();
        }
            break;
        case 4003:
        {//确定  消息自定义
            _pushBlock();
        }
            break;

        default:
            break;
    }
    
    [self zd_Windowclose];
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
    TTVIEW_RELEASE_SAFELY(self.zd_superView);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
