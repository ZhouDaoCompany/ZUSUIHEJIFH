//
//  FaLvGuWenView.m
//  ZhouDao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FaLvGuWenView.h"
#import "ZD_CaseWindow.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define lineColor     [UIColor colorWithHexString:@"#D4D4D4"]
#define labWidth      (87.5f/375.f)*[UIScreen mainScreen].bounds.size.width

#define contentLabWidth (SCREENWIDTH - 2*labWidth -1.5f)/2.f
#define lineW     0.5f
#define contentLongWidth (SCREENWIDTH - labWidth -.5f)

@interface FaLvGuWenView()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titileLab ;//标题

@property (nonatomic, strong) UILabel *wTRLab;//委托人或公司
@property (nonatomic, strong) UILabel *hTQYLab;//合同签约时间
@property (nonatomic, strong) UILabel *hTQYlimitLab;//合同签约年限
@property (nonatomic, strong) UILabel *alertLab;//是否开启到期提醒
@property (nonatomic, strong) UILabel *fRLab;//法定代表人
@property (nonatomic, strong) UILabel *gSDZLab;//公司地址
@property (nonatomic, strong) UILabel *zYYWlab;//主营业务
@property (nonatomic, strong) UILabel *gDLab;//股东情况
@property (nonatomic, strong) UILabel *lXRlab;//联系人
@property (nonatomic, strong) UILabel *lXRPhonelab;//联系电话
@property (nonatomic, strong) UILabel *lXREmaillab;//联系邮箱

@property (nonatomic, strong) UIView *botomView;

@end
@implementation FaLvGuWenView
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
    _wTRLab.text = _conArrays[1];
    _hTQYLab.text = _conArrays[2];
    _hTQYlimitLab.text = _conArrays[3];//conArrays[2];
    _alertLab.text = _conArrays[4];//conArrays[3];
    _fRLab.text = _conArrays[5];//conArrays[4];
    _gSDZLab.text = _conArrays[6];//conArrays[5];
    _zYYWlab.text = _conArrays[7];
    _gDLab.text = _conArrays[8];
    _lXRlab.text = _conArrays[9];
    _lXRPhonelab.text = _conArrays[10];
    _lXREmaillab.text = _conArrays[11];
}
- (void)initUI
{
    float height = 499.f;
    
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
    titileLab.text = @"上海中南电子科技股份有限公司劳动纠纷开庭";
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
    
    //委托人或公司
    UILabel *reasonLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), labWidth, 45.f)];
    reasonLab.text = @" 委托人或公司";
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
    _wTRLab = saReasonLab;
    [_botomView addSubview:_wTRLab];
    /***********************分割线****************************/

    //合同签约时间
    UILabel *plaintiffLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV1), labWidth, 45.f)];
    plaintiffLab.text = @" 合同签约时间";
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
    _hTQYLab = pLab;
    [_botomView addSubview:_hTQYLab];

    // 合同签约年限
    UIView *lineViewH2 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(pLab), Orgin_y(lineViewV1), lineW,45.f)];
    lineViewH2.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH2];
    
    UILabel *defendantLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH2), Orgin_y(lineViewV1), labWidth, 45.f)];
    defendantLab.text = @" 合同签约年限";
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
    _hTQYlimitLab = defLab;
    [_botomView addSubview:_hTQYlimitLab];
    
    //是否开启到期提醒
    UILabel *isAlertLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV2), labWidth, 45.f)];
    isAlertLab.text = @" 是否开启到期提醒";
    isAlertLab.textAlignment = NSTextAlignmentCenter;
    isAlertLab.textColor = thirdColor;
    isAlertLab.font = Font_14;
    isAlertLab.numberOfLines = 0;
    [_botomView addSubview:isAlertLab];
    
    UIView *lineViewV3 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(isAlertLab), SCREENWIDTH, lineW)];
    lineViewV3.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV3];
    
    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV2), contentLabWidth, 45.f)];
    alertLab.text = @"";
    alertLab.textAlignment = NSTextAlignmentCenter;
    alertLab.textColor = sixColor;
    alertLab.font = Font_14;
    alertLab.numberOfLines = 1;
    _alertLab = alertLab;
    [_botomView addSubview:_alertLab];
    
    //法定代表人
    UIView *lineViewH4 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(pLab), Orgin_y(lineViewV2), lineW,45.f)];
    lineViewH4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH4];
    
    UILabel *frLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH4), Orgin_y(lineViewV2), labWidth, 45.f)];
    frLab.text = @" 法定代表人";
    frLab.textAlignment = NSTextAlignmentCenter;
    frLab.textColor = thirdColor;
    frLab.font = Font_14;
    frLab.numberOfLines = 0;
    [_botomView addSubview:frLab];
    
    UIView *lineViewH5 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(defendantLab), Orgin_y(lineViewV2), lineW,45.f)];
    lineViewH5.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH5];
    
    UILabel *fRLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH5), Orgin_y(lineViewV2), contentLabWidth, 45.f)];
    fRLab.text = @"";
    fRLab.textAlignment = NSTextAlignmentCenter;
    fRLab.textColor = sixColor;
    fRLab.font = Font_14;
    fRLab.numberOfLines = 1;
    _fRLab = fRLab;
    [_botomView addSubview:_fRLab];
    
    // 公司地址
    UILabel *gsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV3), labWidth, 45.f)];
    gsLab.text = @" 公司地址";
    gsLab.textAlignment = NSTextAlignmentCenter;
    gsLab.textColor = thirdColor;
    gsLab.font = Font_14;
    gsLab.numberOfLines = 0;
    [_botomView addSubview:gsLab];
    
    UILabel *gSDZLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV3), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    gSDZLab.text = @"";
    gSDZLab.textAlignment = NSTextAlignmentCenter;
    gSDZLab.textColor = sixColor;
    gSDZLab.font = Font_14;
    gSDZLab.numberOfLines = 1;
    _gSDZLab = gSDZLab;
    [_botomView addSubview:_gSDZLab];
    
    UIView *lineViewV4 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(gsLab), SCREENWIDTH, lineW)];
    lineViewV4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV4];
    
    // 主营业务
    
    UILabel *zYLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV4), labWidth, 45.f)];
    zYLab.text = @" 主营业务";
    zYLab.textAlignment = NSTextAlignmentCenter;
    zYLab.textColor = thirdColor;
    zYLab.font = Font_14;
    zYLab.numberOfLines = 0;
    [_botomView addSubview:zYLab];
    
    UILabel *zYYWLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV4), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    zYYWLab.text = @"";
    zYYWLab.textAlignment = NSTextAlignmentCenter;
    zYYWLab.textColor = sixColor;
    zYYWLab.font = Font_14;
    zYYWLab.numberOfLines = 1;
    _zYYWlab = zYYWLab;
    [_botomView addSubview:_zYYWlab];
    
    UIView *lineViewV5 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(zYLab), SCREENWIDTH, lineW)];
    lineViewV5.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV5];
    
    // 股东情况

    UILabel *gDLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV5), labWidth, 45.f)];
    gDLab.text = @" 股东情况";
    gDLab.textAlignment = NSTextAlignmentCenter;
    gDLab.textColor = thirdColor;
    gDLab.font = Font_14;
    gDLab.numberOfLines = 0;
    [_botomView addSubview:gDLab];
    
    UILabel *gDQKLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV5), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    gDQKLab.text = @"";
    gDQKLab.textAlignment = NSTextAlignmentCenter;
    gDQKLab.textColor = sixColor;
    gDQKLab.font = Font_14;
    gDQKLab.numberOfLines = 1;
    _gDLab = gDQKLab;
    [_botomView addSubview:_gDLab];
    
    UIView *lineViewV6 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(gDLab), SCREENWIDTH, lineW)];
    lineViewV6.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV6];
    
    // 联系人
    UILabel *lXRLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV6), labWidth, 45.f)];
    lXRLab.text = @"联系人";
    lXRLab.textAlignment = NSTextAlignmentCenter;
    lXRLab.textColor = thirdColor;
    lXRLab.font = Font_14;
    lXRLab.numberOfLines = 0;
    [_botomView addSubview:lXRLab];
    
    UILabel *lXRlab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV6), contentLabWidth, 45.f)];
    lXRlab.text = @"";
    lXRlab.textAlignment = NSTextAlignmentCenter;
    lXRlab.textColor = sixColor;
    lXRlab.font = Font_14;
    lXRlab.numberOfLines = 0;
    _lXRlab = lXRlab;
    [_botomView addSubview:_lXRlab];
    
    UIView *lineViewH6 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(_lXRlab), Orgin_y(lineViewV6), lineW,45.f)];
    lineViewH6.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH6];

    // 联系电话
    UILabel *lXDHLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH6), Orgin_y(lineViewV6), labWidth, 45.f)];
    lXDHLab.text = @"联系电话";
    lXDHLab.textAlignment = NSTextAlignmentCenter;
    lXDHLab.textColor = thirdColor;
    lXDHLab.font = Font_14;
    lXDHLab.numberOfLines = 1;
    [_botomView addSubview:lXDHLab];
    
    UIView *lineViewH7 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lXDHLab), Orgin_y(lineViewV6), lineW,45.f)];
    lineViewH7.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH7];
    
    UILabel *lXRPhonelab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH7), Orgin_y(lineViewV6), contentLabWidth, 45.f)];
    lXRPhonelab.text = @"";
    lXRPhonelab.textAlignment = NSTextAlignmentCenter;
    lXRPhonelab.textColor = sixColor;
    lXRPhonelab.font = Font_14;
    lXRPhonelab.numberOfLines = 1;
    _lXRPhonelab = lXRPhonelab;
    [_botomView addSubview:_lXRPhonelab];

    UIView *lineViewV7 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_lXRlab), SCREENWIDTH, lineW)];
    lineViewV7.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV7];
    
    // 联系地址
    UILabel *dZLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV7), labWidth, 45.f)];
    dZLab.text = @" 联系邮箱";
    dZLab.textAlignment = NSTextAlignmentCenter;
    dZLab.textColor = thirdColor;
    dZLab.font = Font_14;
    dZLab.numberOfLines = 1;
    [_botomView addSubview:dZLab];
    
    UILabel *dZConLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV7), (SCREENWIDTH - labWidth -.5f), 45.f)];
    dZConLab.text = @"";
    dZConLab.textAlignment = NSTextAlignmentCenter;
    dZConLab.textColor = sixColor;
    dZConLab.font = Font_14;
    dZConLab.numberOfLines = 1;
    _lXREmaillab = dZConLab;
    [_botomView addSubview:_lXREmaillab];

    /****************友好分割线************************************/
    
    UIView *sectionView  = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(dZConLab), SCREENWIDTH, 10)];
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
