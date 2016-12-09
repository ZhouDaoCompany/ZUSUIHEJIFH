//
//  TingShiHeadView.m
//  ZhouDao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiHeadView.h"

@implementation TingShiHeadView

//庭室
- (instancetype)initTingShiHeadViewWithDelegate:(id<TingShiHeadViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    
    if (self) { WEAKSELF;
        
        _delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 15.f)];
        headView.backgroundColor = LINECOLOR;
        [self addSubview:headView];

        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 16, 14)];
        iconImgView.image = kGetImage(@"Gov_TingShi");
        [self addSubview:iconImgView];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 30, 160, 14)];
        titLabel.text = @"庭室信息";
        titLabel.font = Font_12;
        titLabel.textColor = hexColor(666666);
        [self addSubview:titLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.4, kMainScreenWidth, .6f)];
        lineView.backgroundColor = LINECOLOR;
        [self addSubview:lineView];
        
        [self whenCancelTapped:^{
            
            if ([weakSelf.delegate respondsToSelector:@selector(selectTingShiItem)]) {
                
                [weakSelf.delegate selectTingShiItem];
            }
        }];
    }
    return self;
}

//行政审判庭
- (instancetype)initAdministrativeTrialWithSection:(NSUInteger)section withUpOrDown:(BOOL)isUp withDelegate:(id<TingShiHeadViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    
    if (self) {WEAKSELF;
        
        _delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 11, 11)];
        iconImgView.image = kGetImage(@"Gov_XingzhengSP");
        [self addSubview:iconImgView];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 15, 160, 15)];
        titLabel.text = @"行政审判庭";
        titLabel.font = Font_12;
        titLabel.textColor = hexColor(666666);
        [self addSubview:titLabel];
        
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 27, 19, 12, 6.5f)];
        arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
        arrowImgView.image = (isUp) ? kGetImage(@"case_up") :  kGetImage(@"case_jianTou");
        [self addSubview:arrowImgView];
        
        [self whenCancelTapped:^{
            
            if ([weakSelf.delegate respondsToSelector:@selector(onAddOffClickWithSection:)]) {
                
                [weakSelf.delegate onAddOffClickWithSection:section];
            }
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(39, 44.4, kMainScreenWidth - 39, .6f)];
        lineView.backgroundColor = LINECOLOR;
        [self addSubview:lineView];
        
    }
    return self;
}

//简介
- (instancetype)initIntroductionToThe {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 60)];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 15.f)];
        lineView.backgroundColor = LINECOLOR;
        [self addSubview:lineView];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kMainScreenWidth - 15,45.f)];
        lab.font = Font_15;
        lab.textColor = [UIColor redColor];
        lab.text = @"简介";
        [self addSubview:lab];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 59.4f, kMainScreenWidth, .6f)];
        lineView1.backgroundColor = LINECOLOR;
        [self addSubview:lineView1];
    }
    return self;
}
//邮箱纠错
- (instancetype)initEmailErrorCorrectionWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *footLab = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth - 285.f)/2.f, 0, 285.f, 30.f)];
        footLab.backgroundColor = LRRGBColor(233.f, 229.f, 228.f);
        footLab.textColor = LRRGBColor(135.f, 131.f, 130.f);
        footLab.layer.cornerRadius = 5.f;
        footLab.textAlignment = NSTextAlignmentCenter;
        footLab.font = Font_14;
        footLab.text = @"仅供参考，欢迎纠错 zd@zhoudao.cc";
        footLab.layer.masksToBounds = YES;
        [self addSubview:footLab];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
