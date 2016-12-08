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
- (instancetype)initTingShiHeadView {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 14)];
        iconImgView.image = kGetImage(@"Gov_TingShi");
        [self addSubview:iconImgView];
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(39, 15, 100, 14)];
        titLabel.text = @"庭室信息";
        titLabel.font = Font_12;
        titLabel.textColor = hexColor(666666);
        [self addSubview:titLabel];
    }
    return self;
}

//行政审判庭
- (instancetype)initAdministrativeTrial {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

//简介
- (instancetype)initIntroductionToThe {
    
    self = [super initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45)];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 10.f)];
        lineView.backgroundColor = LINECOLOR;
        [self addSubview:lineView];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kMainScreenWidth - 15,40.f)];
        lab.font = Font_15;
        lab.textColor = [UIColor redColor];
        lab.numberOfLines = 0;
        lab.text = @"简介";
        [self addSubview:lab];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49.4f, kMainScreenWidth, .6f)];
        lineView1.backgroundColor = LINECOLOR;
        [self addSubview:lineView1];

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
