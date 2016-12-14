//
//  TingShiHeadView.m
//  ZhouDao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "TingShiHeadView.h"

@interface TingShiHeadView()


@end

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
        
        UIImageView *jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 27, 30, 8, 13)];
        jiantouimg.userInteractionEnabled = YES;
        jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
        [self addSubview:jiantouimg];

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

//表头
- (instancetype)initTingShiListHeadViewWithTitleString:(NSString *)titleString
                                            withSetion:(NSUInteger)section
                                          withDelegate:(id<TingShiHeadViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    if (self) {
        
        _delegate = delegate;
        _section = section;
        [self addSubview:self.titleLabel];
        [self addSubview:self.delBtn];
        [_delBtn setImage:[UIImage imageNamed:@"mine_guanbi"] forState:0];
        _delBtn.tag = 6701;

        _titleLabel.text = titleString;
        
    }
    return self;
}

// 庭室列表页
- (instancetype)initTingShiListPageHeadViewWithState:(NSString *)stateString
                                     withTitleString:(NSString *)titleString
                                          withSetion:(NSUInteger)section
                                        withDelegate:(id<TingShiHeadViewPro>)delegate {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    if (self) {
        
        _section = section;
        _delegate = delegate;
        [self addSubview:self.titleLabel];
        [self addSubview:self.delBtn];

        _titleLabel.text = titleString;
        _delBtn.tag = 6700;
        [_delBtn setTitleColor:KNavigationBarColor forState:0];
        [_delBtn setBackgroundImage:kGetImage(@"mine_box") forState:0];
        _delBtn.titleLabel.font = Font_12;
        _delBtn.frame = CGRectMake(kMainScreenWidth - 55.f, 12.f, 40 , 20);
        [_delBtn setTitle:@"编辑" forState:0];
        
        NSDictionary *attribute = @{NSFontAttributeName:Font_15};
        CGSize size = [titleString boundingRectWithSize:CGSizeMake(160, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        CGFloat stateWidth = size.width;
        if (size.width >= 160) {
            stateWidth = 160;
        }
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateWidth + 21, 15, 50, 15)];
        stateLabel.font = Font_12;
        stateLabel.text = stateString;
        [stateLabel setTextColor:hexColor(333333)];
        [self addSubview:stateLabel];
    }
    return self;
}

- (void)deleteEventRespose:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(editTingShiListView:)]) {
        
        [self.delegate editTingShiListView:_section];
    }

    if ([self.delegate respondsToSelector:@selector(deleteRedundantTingShiSectionView:)]) {
        
        [self.delegate deleteRedundantTingShiSectionView:_section];
    }
}
#pragma mark - setter and getter
- (UIButton *)delBtn {
    
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(kMainScreenWidth - 55.f, 10.f, 40 , 25);
        [_delBtn addTarget:self action:@selector(deleteEventRespose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(13, 0, 160, self.frame.size.height);
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_titleLabel setTextColor:hexColor(333333)];
    }
    return _titleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
