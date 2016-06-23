//
//  CaseDetailHeadView.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CaseDetailHeadView.h"
#import "ZD_CaseWindow.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define lineColor     [UIColor colorWithHexString:@"#D4D4D4"]
#define labWidth      (87.5f/375.f)*[UIScreen mainScreen].bounds.size.width

#define contentLabWidth (SCREENWIDTH - 2*labWidth -1.5f)/2.f
#define lineW     0.5f
@interface CaseDetailHeadView()
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titileLab ;//标题
@property (nonatomic, strong) UILabel *saReasonLab;//委托人
@property (nonatomic, strong) UILabel *ygLab;//委托人联系电话
@property (nonatomic, strong) UILabel *bgLab;//委托人联系邮箱
@property (nonatomic, strong) UILabel *jaReasonLab;//委托人联系地址
@property (nonatomic, strong) UILabel *saDateLab;//收案日期
@property (nonatomic, strong) UILabel *jaDateLab;//结案日期
@property (nonatomic, strong) UILabel *jATypelab;//结案形式
//@property (nonatomic, strong) 
@property (nonatomic, strong) UIView *botomView;

@end
@implementation CaseDetailHeadView
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
- (void)layoutSubviews
{
    [super layoutSubviews];
    _botomView.frame = CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height);
}
- (void)setConArrays:(NSMutableArray *)conArrays
{
    _conArrays = nil;
    _conArrays = conArrays;
    
    _titileLab.text = _conArrays[0];
    _saReasonLab.text = _conArrays[1];;
    _ygLab.text = _conArrays[2];;
    _bgLab.text = _conArrays[3];;
    _jaReasonLab.text = _conArrays[4];;
    _saDateLab.text = _conArrays[5];;
    _jaDateLab.text = _conArrays[6];;
    _jATypelab.text = _conArrays[7];;
    
    if (_saReasonLab.text.length>0) {
        [_saReasonLab whenCancelTapped:^{
            ZD_CaseWindow * window = [[ZD_CaseWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:@"收案理由" WithContent:_saReasonLab.text];
            [self.superview.superview addSubview:window];

        }];
    }

    if (_jaReasonLab.text.length>0) {
        [_jaReasonLab whenCancelTapped:^{
            ZD_CaseWindow * window = [[ZD_CaseWindow alloc] initWithFrame:kMainScreenFrameRect WithTitle:@"结案理由" WithContent:_jaReasonLab.text];
            [self.superview.superview addSubview:window];
            
        }];
    }
}
- (void)initUI
{
    float height = 362.f;
    
    _botomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height)];
    _botomView.backgroundColor = [UIColor whiteColor];
    _botomView.clipsToBounds = YES;
    [self addSubview:_botomView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 125.f)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"case_detailHead.jpg"];
    _imgView = imageView;
    [_botomView addSubview:_imgView];
    UILabel * titileLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 25.f, SCREENWIDTH -150.f, 50.f)];
    titileLab.text = @"";
    titileLab.textAlignment = NSTextAlignmentCenter;
    titileLab.textColor = [UIColor whiteColor];
    titileLab.font = Font_15;
    titileLab.numberOfLines = 0;
    _titileLab = titileLab;
    [_imgView addSubview:_titileLab];
    
    UILabel * expandLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-100.f)/2.f, Orgin_y(_titileLab) +5.f, 100.f, 25.f)];
    expandLab.backgroundColor = KNavigationBarColor;
    expandLab.text = @"点此展开";
    expandLab.textAlignment = NSTextAlignmentCenter;
    expandLab.textColor = [UIColor whiteColor];
    expandLab.font = Font_15;
    expandLab.numberOfLines = 0;
    _expandLab = expandLab;
    [_imgView addSubview:_expandLab];

    
    [imageView whenCancelTapped:^{
        _caseBlock();
    }];
    
    //委托人
    
    UILabel *reasonLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), labWidth, 45.f)];
    reasonLab.text = @"委托人";
    reasonLab.textAlignment = NSTextAlignmentCenter;
    reasonLab.textColor = thirdColor;
    reasonLab.font = Font_14;
    reasonLab.numberOfLines = 0;
    [_botomView addSubview:reasonLab];
    
    // 划线
    UIView *lineViewH1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(reasonLab), Orgin_y(_imgView), lineW, height-135.5f)];
    lineViewH1.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH1];
    
    UIView *lineViewV1 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(reasonLab), SCREENWIDTH, lineW)];
    lineViewV1.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV1];
    
    UILabel *saReasonLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(_imgView), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    saReasonLab.text = @"";
    saReasonLab.textAlignment = NSTextAlignmentCenter;
    saReasonLab.textColor = sixColor;
    saReasonLab.font = Font_14;
    saReasonLab.numberOfLines = 1;
    _saReasonLab = saReasonLab;
    [_botomView addSubview:_saReasonLab];
   /***********************分割线****************************/
    
    //委托人联系电话
    UILabel *plaintiffLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV1), labWidth, 45.f)];
    plaintiffLab.text = @" 委托人联系电话";
    plaintiffLab.textAlignment = NSTextAlignmentCenter;
    plaintiffLab.textColor = thirdColor;
    plaintiffLab.font = Font_14;
    plaintiffLab.numberOfLines = 0;
    [_botomView addSubview:plaintiffLab];
    
    UIView *lineViewV2 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(plaintiffLab), SCREENWIDTH, lineW)];
    lineViewV2.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV2];
    
    UILabel *pLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV1), contentLabWidth, 45.f)];
    pLab.text = @"";
    pLab.textAlignment = NSTextAlignmentCenter;
    pLab.textColor = sixColor;
    pLab.font = Font_14;
    pLab.numberOfLines = 1;
    _ygLab = pLab;
    [_botomView addSubview:_ygLab];

    
    //委托人联系邮箱
    UIView *lineViewH2 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(pLab), Orgin_y(lineViewV1), lineW,45.f)];
    lineViewH2.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH2];
    
    UILabel *defendantLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH2), Orgin_y(lineViewV1), labWidth, 45.f)];
    defendantLab.text = @" 委托人联系邮箱";
    defendantLab.textAlignment = NSTextAlignmentCenter;
    defendantLab.textColor = thirdColor;
    defendantLab.font = Font_14;
    defendantLab.numberOfLines = 0;
    [_botomView addSubview:defendantLab];
    
    UIView *lineViewH3 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(defendantLab), Orgin_y(lineViewV1), lineW,45.f)];
    lineViewH3.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH3];
    
    UILabel *defLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH3), Orgin_y(lineViewV1), contentLabWidth, 45.f)];
    defLab.text = @"";
    defLab.textAlignment = NSTextAlignmentCenter;
    defLab.textColor = sixColor;
    defLab.font = Font_14;
    defLab.numberOfLines = 1;
    _bgLab = defLab;
    [_botomView addSubview:_bgLab];

    //委托人联系地址
    UILabel *jieanLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV2), labWidth, 45.f)];
    jieanLab.text = @" 委托人联系地址";
    jieanLab.textAlignment = NSTextAlignmentCenter;
    jieanLab.textColor = thirdColor;
    jieanLab.font = Font_14;
    jieanLab.numberOfLines = 0;
    [_botomView addSubview:jieanLab];
    
    UILabel *jaReasonLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV2), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    jaReasonLab.text = @"";
    jaReasonLab.textAlignment = NSTextAlignmentCenter;
    jaReasonLab.textColor = sixColor;
    jaReasonLab.font = Font_14;
    jaReasonLab.numberOfLines = 1;
    _jaReasonLab = jaReasonLab;
    [_botomView addSubview:_jaReasonLab];

    
    UIView *lineViewV3 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(jieanLab), SCREENWIDTH, lineW)];
    lineViewV3.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV3];
    
    //收案日期
    UILabel *saDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV3), labWidth, 45.f)];
    saDateLab.text = @"收案日期";
    saDateLab.textAlignment = NSTextAlignmentCenter;
    saDateLab.textColor = thirdColor;
    saDateLab.font = Font_14;
    saDateLab.numberOfLines = 0;
    [_botomView addSubview:saDateLab];
    
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV3), contentLabWidth, 45.f)];
    sLab.text = @"";
    sLab.textAlignment = NSTextAlignmentCenter;
    sLab.textColor = sixColor;
    sLab.font = Font_14;
    sLab.numberOfLines = 1;
    _saDateLab = sLab;
    [_botomView addSubview:_saDateLab];

    
    UIView *lineViewH4 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sLab), Orgin_y(lineViewV3), lineW,45.f)];
    lineViewH4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH4];
    
    //结案日期
    UILabel *jaDateLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH4), Orgin_y(lineViewV3), labWidth, 45.f)];
    jaDateLab.text = @"结案日期";
    jaDateLab.textAlignment = NSTextAlignmentCenter;
    jaDateLab.textColor = thirdColor;
    jaDateLab.font = Font_14;
    jaDateLab.numberOfLines = 1;
    [_botomView addSubview:jaDateLab];

    UIView *lineViewH5 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(jaDateLab), Orgin_y(lineViewV3), lineW,45.f)];
    lineViewH5.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH5];

    UILabel *jaContentLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH5), Orgin_y(lineViewV3), contentLabWidth, 45.f)];
    jaContentLab.text = @"";
    jaContentLab.textAlignment = NSTextAlignmentCenter;
    jaContentLab.textColor = sixColor;
    jaContentLab.font = Font_14;
    jaContentLab.numberOfLines = 1;
    _jaDateLab = jaContentLab;
    [_botomView addSubview:_jaDateLab];
    
    //结案形式
    
    UIView *lineViewV4 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(saDateLab), SCREENWIDTH, lineW)];
    lineViewV4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV4];

    UILabel *jaTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV4), labWidth, 45.f)];
    jaTypeLab.text = @" 结案形式";
    jaTypeLab.textAlignment = NSTextAlignmentCenter;
    jaTypeLab.textColor = thirdColor;
    jaTypeLab.font = Font_14;
    jaTypeLab.numberOfLines = 1;
    [_botomView addSubview:jaTypeLab];
    
    UILabel *jaTypeConLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV4), (SCREENWIDTH - labWidth -.5f), 45.f)];
    jaTypeConLab.text = @"";
//    jaTypeConLab.textAlignment = NSTextAlignmentCenter;
    jaTypeConLab.textColor = sixColor;
    jaTypeConLab.font = Font_14;
    jaTypeConLab.numberOfLines = 1;
    _jATypelab = jaTypeConLab;
    [_botomView addSubview:_jATypelab];


    /****************友好分割线************************************/
    
    UIView *sectionView  = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(jaTypeLab), SCREENWIDTH, 10)];
    sectionView.backgroundColor = ViewBackColor;
    [_botomView addSubview:sectionView];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
