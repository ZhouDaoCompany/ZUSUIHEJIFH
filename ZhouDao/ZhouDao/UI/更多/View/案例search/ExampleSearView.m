//
//  ExampleSearView.m
//  ZhouDao
//
//  Created by apple on 16/4/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ExampleSearView.h"

#define searchWidth     [UIScreen mainScreen].bounds.size.width*(225.f/375.0f)

@interface ExampleSearView()

@property (nonatomic,strong) UIImageView *imgView;

@end
@implementation ExampleSearView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    float width = self.bounds.size.width;
//    float height = self.bounds.size.height;
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
    _imgView.image = [UIImage imageNamed:@"laws_CaseSearch.jpg"];
    _imgView.userInteractionEnabled = YES;
    [self addSubview:_imgView];
    
    [self initSearchUI];
    
//    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), width, 10.f)];
//    sectionView.backgroundColor = ViewBackColor;
//    [self addSubview:sectionView];

    UILabel *headlab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), width, 45)];
    headlab.text = @"案件类型";
    headlab.textAlignment = NSTextAlignmentCenter;
    headlab.font = Font_15;
    headlab.textColor = THIRDCOLOR;
    [self addSubview:headlab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(headlab), width, 2.f)];
    lineView.backgroundColor = ViewBackColor;
    [self addSubview:lineView];
}
- (void)initSearchUI
{
    float width = self.bounds.size.width;
//    UIView *serchView1 = [[UIView alloc] initWithFrame:CGRectMake(50,100, searchWidth, 30)];
    UIView *serchView1 = [[UIView alloc] initWithFrame:CGRectMake(50,100, width-100, 30)];
    serchView1.backgroundColor = [UIColor whiteColor];
    serchView1.layer.cornerRadius = 3.f;
    serchView1.layer.masksToBounds = YES;
    [_imgView addSubview:serchView1];
    
    WEAKSELF;
    [serchView1 whenCancelTapped:^{
        
        weakSelf.searchBlock(@"普通");
    }];
    

    
    UIImageView *search =[[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 18, 18)];
    [serchView1 addSubview:search];
    search.image = [UIImage imageNamed:@"Esearch_graySousuo"];
    UILabel *searchLab = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, serchView1.frame.size.width-32, 30)];
    searchLab.text =  @"搜索相关案例";
    searchLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    searchLab.font = Font_14;
    [serchView1 addSubview:searchLab];
    
//    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(serchView1) +8, 100, kMainScreenWidth -Orgin_x(serchView1) -8 , 30)];
//    Label.text =  @"高级搜索";
//    Label.textColor = [UIColor whiteColor];
//    Label.backgroundColor = [UIColor clearColor];
//    Label.font = Font_15;
//    [_imgView addSubview:Label];
//    
//    [Label whenCancelTapped:^{
//        
//        weakSelf.searchBlock(@"高级");
//    }];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
