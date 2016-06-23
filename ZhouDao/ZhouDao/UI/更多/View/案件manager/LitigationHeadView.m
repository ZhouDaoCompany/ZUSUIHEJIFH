//
//  LitigationHeadView.m
//  ZhouDao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LitigationHeadView.h"
#import "ZD_CaseWindow.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define lineColor     [UIColor colorWithHexString:@"#D4D4D4"]
#define labWidth      (87.5f/375.f)*[UIScreen mainScreen].bounds.size.width

#define contentLabWidth (SCREENWIDTH - 2*labWidth -1.5f)/2.f
#define lineW     0.5f
#define contentLongWidth (SCREENWIDTH - labWidth -.5f)

@interface LitigationHeadView()
@property (nonatomic,strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titileLab ;//标题
@property (nonatomic, strong) UILabel *ktLab;//开庭时间
@property (nonatomic, strong) UILabel *sALYLab;//收案理由
@property (nonatomic, strong) UILabel *sARQLab;//收案日期
@property (nonatomic, strong) UILabel *jARQLab;//结案日期
@property (nonatomic, strong) UILabel *jALYLab;//结案理由

@property (nonatomic, strong) UILabel *YGLab;//公诉机关或原告人
@property (nonatomic, strong) UILabel *bGLab;//被告人或上诉人
@property (nonatomic, strong) UILabel *otherlab;//其他诉讼参与人
@property (nonatomic, strong) UILabel *ySFYLab;//一审法院/仲裁委员会
@property (nonatomic, strong) UILabel *zSFGlab;//主审法官
@property (nonatomic, strong) UILabel *lXDHlab;//联系电话
@property (nonatomic, strong) UILabel *lXDZlab;//联系地址
@property (nonatomic, strong) UILabel *onerResultslab;//一审仲裁结果
@property (nonatomic, strong) UILabel *tFYlab;//二审法院
@property (nonatomic, strong) UILabel *tZSFGlab;//主审法官
@property (nonatomic, strong) UILabel *tLXDHlab;//联系电话
@property (nonatomic, strong) UILabel *tLXDZlab;//联系地址
@property (nonatomic, strong) UILabel *tResultlab;//二审结果
@property (nonatomic, strong) UILabel *sQZXlab;//申请执行时间
@property (nonatomic, strong) UILabel *zXFYlab;//执行法院
@property (nonatomic, strong) UILabel *zXFGlab;//执行法官
@property (nonatomic, strong) UILabel *tLXFSlab;//联系方式


@property (nonatomic, strong) UIView *botomView;

@end

@implementation LitigationHeadView
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
    
    _titileLab.text = conArrays[0];
    _ktLab.text = conArrays[1];
    _sALYLab.text = conArrays[2];
    _sARQLab.text = conArrays[3];//conArrays[2];
    _jARQLab.text = conArrays[4];//conArrays[3];
    _jALYLab.text = conArrays[5];
    _YGLab.text = conArrays[6];//conArrays[4];
    _bGLab.text = conArrays[7];//conArrays[5];
    _otherlab.text = conArrays[8];
    _ySFYLab.text = conArrays[9];
    _zSFGlab.text = conArrays[10];
    _lXDHlab.text = conArrays[11];
    _lXDZlab.text = conArrays[12];
    _onerResultslab.text = conArrays[13];
    _tFYlab.text = conArrays[14];
    _tZSFGlab.text = conArrays[15];
    _tLXDHlab.text = conArrays[16];
    _tLXDZlab.text = conArrays[17];
    _tResultlab.text = conArrays[18];
    _sQZXlab.text = conArrays[19];
    _zXFYlab.text = conArrays[20];
    _zXFGlab.text = conArrays[21];
    _tLXFSlab.text = conArrays[22];
}
- (void)initUI
{
    float height = 863.f;
    
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
    
    UILabel * expandLab = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-100.f)/2.f, Orgin_y(titileLab) +5.f, 100.f, 25.f)];
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
    
    
    //开庭时间
    
    UILabel *sjLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(_imgView), labWidth, 45.f)];
    sjLab.text = @" 开庭时间";
    sjLab.textAlignment = NSTextAlignmentCenter;
    sjLab.textColor = thirdColor;
    sjLab.font = Font_14;
    sjLab.numberOfLines = 0;
    [_botomView addSubview:sjLab];
    // 划线
    UIView *lineViewH1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sjLab), Orgin_y(_imgView), lineW, height-135.5f)];
    lineViewH1.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH1];
    
    UIView *lineViewV1 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(sjLab), SCREENWIDTH, lineW)];
    lineViewV1.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV1];
    
    UILabel *kTLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(_imgView), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    kTLab.text = @"";
    kTLab.textAlignment = NSTextAlignmentCenter;
    kTLab.textColor = sixColor;
    kTLab.font = Font_14;
    kTLab.numberOfLines = 1;
    _ktLab = kTLab;
    [_botomView addSubview:_ktLab];
    
    /***********************分割线****************************/

    //收案理由
    UILabel *reasonLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV1), labWidth, 45.f)];
    reasonLab.text = @" 收案理由";
    reasonLab.textAlignment = NSTextAlignmentCenter;
    reasonLab.textColor = thirdColor;
    reasonLab.font = Font_14;
    reasonLab.numberOfLines = 0;
    [_botomView addSubview:reasonLab];
    // 划线
    
    UIView *lineViewV2 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(reasonLab), SCREENWIDTH, lineW)];
    lineViewV2.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV2];
    
    UILabel *sALab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV1), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    sALab.text = @"";
    sALab.textAlignment = NSTextAlignmentCenter;
    sALab.textColor = sixColor;
    sALab.font = Font_14;
    sALab.numberOfLines = 1;
    _sALYLab = sALab;
    [_botomView addSubview:_sALYLab];
    /***********************分割线****************************/
    
    //收案日期
    UILabel *saDateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV2), labWidth, 45.f)];
    saDateLab.text = @"收案日期";
    saDateLab.textAlignment = NSTextAlignmentCenter;
    saDateLab.textColor = thirdColor;
    saDateLab.font = Font_14;
    saDateLab.numberOfLines = 0;
    [_botomView addSubview:saDateLab];
    
    UILabel *sLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV2), contentLabWidth, 45.f)];
    sLab.text = @"";
    sLab.textAlignment = NSTextAlignmentCenter;
    sLab.textColor = sixColor;
    sLab.font = Font_14;
    sLab.numberOfLines = 1;
    _sARQLab = sLab;
    [_botomView addSubview:_sARQLab];
    
    
    UIView *lineViewH2 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sLab), Orgin_y(lineViewV2), lineW,45.f)];
    lineViewH2.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH2];
    
    //结案日期
    UILabel *jaDateLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH2), Orgin_y(lineViewV2), labWidth, 45.f)];
    jaDateLab.text = @"结案日期";
    jaDateLab.textAlignment = NSTextAlignmentCenter;
    jaDateLab.textColor = thirdColor;
    jaDateLab.font = Font_14;
    jaDateLab.numberOfLines = 1;
    [_botomView addSubview:jaDateLab];
    
    UIView *lineViewH3 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(jaDateLab), Orgin_y(lineViewV2), lineW,45.f)];
    lineViewH3.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH3];
    
    UILabel *jaContentLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH3), Orgin_y(lineViewV2), contentLabWidth, 45.f)];
    jaContentLab.text = @"";
    jaContentLab.textAlignment = NSTextAlignmentCenter;
    jaContentLab.textColor = sixColor;
    jaContentLab.font = Font_14;
    jaContentLab.numberOfLines = 1;
    _jARQLab = jaContentLab;
    [_botomView addSubview:_jARQLab];
    
    UIView *lineViewV3 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(saDateLab), SCREENWIDTH, lineW)];
    lineViewV3.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV3];

    
    /***********************分割线****************************/
   // 结案理由
    UILabel *lYLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV3), labWidth, 45.f)];
    lYLab.text = @" 结案理由";
    lYLab.textAlignment = NSTextAlignmentCenter;
    lYLab.textColor = thirdColor;
    lYLab.font = Font_14;
    lYLab.numberOfLines = 0;
    [_botomView addSubview:lYLab];
    
    UILabel *jALab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV3), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    jALab.text = @"";
    jALab.textAlignment = NSTextAlignmentCenter;
    jALab.textColor = sixColor;
    jALab.font = Font_14;
    jALab.numberOfLines = 1;
    _jALYLab = jALab;
    [_botomView addSubview:_jALYLab];
    
    UIView *lineViewV4 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(lYLab), SCREENWIDTH, lineW)];
    lineViewV4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV4];
    /***********************分割线****************************/
    //公诉机关或原告人
    UILabel *tygLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV4), labWidth, 45.f)];
    tygLab.text = @"公诉机关或原告人";
    tygLab.textAlignment = NSTextAlignmentCenter;
    tygLab.textColor = thirdColor;
    tygLab.font = Font_14;
    tygLab.numberOfLines = 0;
    [_botomView addSubview:tygLab];
    
    UILabel *ygLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV4), contentLabWidth, 45.f)];
    ygLab.text = @"";
    ygLab.textAlignment = NSTextAlignmentCenter;
    ygLab.textColor = sixColor;
    ygLab.font = Font_14;
    ygLab.numberOfLines = 0;
    _YGLab = ygLab;
    [_botomView addSubview:_YGLab];
    
    UIView *lineViewH4 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sLab), Orgin_y(lineViewV4), lineW,45.f)];
    lineViewH4.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH4];
    
    //被告人或上诉人
    UILabel *tbgLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH4), Orgin_y(lineViewV4), labWidth, 45.f)];
    tbgLab.text = @"被告人或上诉人";
    tbgLab.textAlignment = NSTextAlignmentCenter;
    tbgLab.textColor = thirdColor;
    tbgLab.font = Font_14;
    tbgLab.numberOfLines = 0;
    [_botomView addSubview:tbgLab];
    
    UIView *lineViewH5 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(tbgLab), Orgin_y(lineViewV4), lineW,45.f)];
    lineViewH5.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH5];
    
    UILabel *bgLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH5), Orgin_y(lineViewV4), contentLabWidth, 45.f)];
    bgLab.text = @"";
    bgLab.textAlignment = NSTextAlignmentCenter;
    bgLab.textColor = sixColor;
    bgLab.font = Font_14;
    bgLab.numberOfLines = 0;
    _bGLab = bgLab;
    [_botomView addSubview:_bGLab];
    
    UIView *lineViewV5 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(tygLab), SCREENWIDTH, lineW)];
    lineViewV5.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV5];

    /***********************分割线****************************/
    //其他诉讼参与人
    UILabel *otherLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV5), labWidth, 45.f)];
    otherLab.text = @" 其他诉讼参与人";
    otherLab.textAlignment = NSTextAlignmentCenter;
    otherLab.textColor = thirdColor;
    otherLab.font = Font_14;
    otherLab.numberOfLines = 0;
    [_botomView addSubview:otherLab];
    
    UILabel *ConOtherLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV5), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    ConOtherLab.text = @"";
    ConOtherLab.textAlignment = NSTextAlignmentCenter;
    ConOtherLab.textColor = sixColor;
    ConOtherLab.font = Font_14;
    ConOtherLab.numberOfLines = 0;
    _otherlab = ConOtherLab;
    [_botomView addSubview:_otherlab];
    
    UIView *lineViewV6 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(otherLab), SCREENWIDTH, lineW)];
    lineViewV6.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV6];

    /***********************分割线****************************/
    //一审法院/仲裁委员会
    UILabel *ySLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV6), labWidth, 45.f)];
    ySLab.text = @" 一审法院/仲裁委员会";
    ySLab.textAlignment = NSTextAlignmentCenter;
    ySLab.textColor = thirdColor;
    ySLab.font = Font_14;
    ySLab.numberOfLines = 0;
    [_botomView addSubview:ySLab];
    
    UILabel *ySFYLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV6), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    ySFYLab.text = @"";
    ySFYLab.textAlignment = NSTextAlignmentCenter;
    ySFYLab.textColor = sixColor;
    ySFYLab.font = Font_14;
    ySFYLab.numberOfLines = 0;
    _ySFYLab = ySFYLab;
    [_botomView addSubview:_ySFYLab];
    
    UIView *lineViewV7 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(ySLab), SCREENWIDTH, lineW)];
    lineViewV7.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV7];
    /***********************分割线****************************/
    //主审法官
    UILabel *zsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV7), labWidth, 45.f)];
    zsLab.text = @" 主审法官";
    zsLab.textAlignment = NSTextAlignmentCenter;
    zsLab.textColor = thirdColor;
    zsLab.font = Font_14;
    zsLab.numberOfLines = 0;
    [_botomView addSubview:zsLab];
    
    UILabel *zSFGLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV7), contentLabWidth, 45.f)];
    zSFGLab.text = @"";
    zSFGLab.textAlignment = NSTextAlignmentCenter;
    zSFGLab.textColor = sixColor;
    zSFGLab.font = Font_14;
    zSFGLab.numberOfLines = 0;
    _zSFGlab = zSFGLab;
    [_botomView addSubview:_zSFGlab];
    
    UIView *lineViewH6 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sLab), Orgin_y(lineViewV7), lineW,45.f)];
    lineViewH6.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH6];
    
    //联系电话
    UILabel *lXLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH4), Orgin_y(lineViewV7), labWidth, 45.f)];
    lXLab.text = @"联系电话";
    lXLab.textAlignment = NSTextAlignmentCenter;
    lXLab.textColor = thirdColor;
    lXLab.font = Font_14;
    lXLab.numberOfLines = 0;
    [_botomView addSubview:lXLab];
    
    UIView *lineViewH7 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(tbgLab), Orgin_y(lineViewV7), lineW,45.f)];
    lineViewH7.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH7];
    
    UILabel *lXDHLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH5), Orgin_y(lineViewV7), contentLabWidth, 45.f)];
    lXDHLab.text = @"";
    lXDHLab.textAlignment = NSTextAlignmentCenter;
    lXDHLab.textColor = sixColor;
    lXDHLab.font = Font_13;
    lXDHLab.numberOfLines = 0;
    _lXDHlab = lXDHLab;
    [_botomView addSubview:_lXDHlab];
    
    UIView *lineViewV8 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(zsLab), SCREENWIDTH, lineW)];
    lineViewV8.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV8];
    
    /***********************分割线****************************/
    //联系地址
    UILabel *lXDZLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV8), labWidth, 45.f)];
    lXDZLab.text = @"联系地址";
    lXDZLab.textAlignment = NSTextAlignmentCenter;
    lXDZLab.textColor = thirdColor;
    lXDZLab.font = Font_14;
    lXDZLab.numberOfLines = 0;
    [_botomView addSubview:lXDZLab];
    
    UILabel *conLXDZLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV8), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    conLXDZLab.text = @"";
    conLXDZLab.textAlignment = NSTextAlignmentCenter;
    conLXDZLab.textColor = sixColor;
    conLXDZLab.font = Font_14;
    conLXDZLab.numberOfLines = 0;
    _lXDZlab = conLXDZLab;
    [_botomView addSubview:_lXDZlab];
    
    UIView *lineViewV9 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(lXDZLab), SCREENWIDTH, lineW)];
    lineViewV9.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV9];
    /***********************分割线****************************/
    //一审仲裁结果
    UILabel *ysresLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV9), labWidth, 45.f)];
    ysresLab.text = @"一审仲裁结果";
    ysresLab.textAlignment = NSTextAlignmentCenter;
    ysresLab.textColor = thirdColor;
    ysresLab.font = Font_14;
    ysresLab.numberOfLines = 0;
    [_botomView addSubview:ysresLab];
    
    UILabel *conResultLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV9), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    conResultLab.text = @"";
    conResultLab.textAlignment = NSTextAlignmentCenter;
    conResultLab.textColor = sixColor;
    conResultLab.font = Font_14;
    conResultLab.numberOfLines = 0;
    _onerResultslab = conResultLab;
    [_botomView addSubview:_onerResultslab];
    
    UIView *lineViewV10 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(ysresLab), SCREENWIDTH, lineW)];
    lineViewV10.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV10];
    /***********************分割线****************************/
    //二审法院
    UILabel *tFYLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV10), labWidth, 45.f)];
    tFYLab.text = @"二审法院";
    tFYLab.textAlignment = NSTextAlignmentCenter;
    tFYLab.textColor = thirdColor;
    tFYLab.font = Font_14;
    tFYLab.numberOfLines = 0;
    [_botomView addSubview:tFYLab];
    
    UILabel *conTFYLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV10), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    conTFYLab.text = @"";
    conTFYLab.textAlignment = NSTextAlignmentCenter;
    conTFYLab.textColor = sixColor;
    conTFYLab.font = Font_14;
    conTFYLab.numberOfLines = 0;
    _tFYlab = conTFYLab;
    [_botomView addSubview:_tFYlab];
    
    UIView *lineViewV11 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(tFYLab), SCREENWIDTH, lineW)];
    lineViewV11.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV11];
    /***********************分割线****************************/
    
    //主审法官
    UILabel *tZSFGLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV11), labWidth, 45.f)];
    tZSFGLab.text = @"主审法官";
    tZSFGLab.textAlignment = NSTextAlignmentCenter;
    tZSFGLab.textColor = thirdColor;
    tZSFGLab.font = Font_14;
    tZSFGLab.numberOfLines = 0;
    [_botomView addSubview:tZSFGLab];
    
    UILabel *conTZSFGLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV11), contentLabWidth, 45.f)];
    conTZSFGLab.text = @"";
    conTZSFGLab.textAlignment = NSTextAlignmentCenter;
    conTZSFGLab.textColor = sixColor;
    conTZSFGLab.font = Font_14;
    conTZSFGLab.numberOfLines = 0;
    _tZSFGlab = conTZSFGLab;
    [_botomView addSubview:_tZSFGlab];
    
    UIView *lineViewH8 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(sLab), Orgin_y(lineViewV11), lineW,45.f)];
    lineViewH8.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH8];
    
    //联系电话
    UILabel *tLXDHLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH4), Orgin_y(lineViewV11), labWidth, 45.f)];
    tLXDHLab.text = @"联系电话";
    tLXDHLab.textAlignment = NSTextAlignmentCenter;
    tLXDHLab.textColor = thirdColor;
    tLXDHLab.font = Font_14;
    tLXDHLab.numberOfLines = 0;
    [_botomView addSubview:tLXDHLab];
    
    UIView *lineViewH9 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(tLXDHLab), Orgin_y(lineViewV11), lineW,45.f)];
    lineViewH9.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH9];
    
    UILabel *conTLXDHLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH5), Orgin_y(lineViewV11), contentLabWidth, 45.f)];
    conTLXDHLab.text = @"";
    conTLXDHLab.textAlignment = NSTextAlignmentCenter;
    conTLXDHLab.textColor = sixColor;
    conTLXDHLab.font = Font_13;
    conTLXDHLab.numberOfLines = 0;
    _tLXDHlab = conTLXDHLab;
    [_botomView addSubview:_tLXDHlab];
    
    UIView *lineViewV12 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(tZSFGLab), SCREENWIDTH, lineW)];
    lineViewV12.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV12];

    /***********************分割线****************************/
    //联系地址
    UILabel *tLxdzLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV12), labWidth, 45.f)];
    tLxdzLab.text = @"联系地址";
    tLxdzLab.textAlignment = NSTextAlignmentCenter;
    tLxdzLab.textColor = thirdColor;
    tLxdzLab.font = Font_14;
    tLxdzLab.numberOfLines = 0;
    [_botomView addSubview:tLxdzLab];
    
    UILabel *conTLxdzLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV12), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    conTLxdzLab.text = @"";
    conTLxdzLab.textAlignment = NSTextAlignmentCenter;
    conTLxdzLab.textColor = sixColor;
    conTLxdzLab.font = Font_14;
    conTLxdzLab.numberOfLines = 0;
    _tLXDZlab = conTLxdzLab;
    [_botomView addSubview:_tLXDZlab];
    
    UIView *lineViewV13 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(tLxdzLab), SCREENWIDTH, lineW)];
    lineViewV13.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV13];
    /***********************分割线****************************/
    //二审结果
    UILabel *tResultsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV13), labWidth, 45.f)];
    tResultsLab.text = @"二审结果";
    tResultsLab.textAlignment = NSTextAlignmentCenter;
    tResultsLab.textColor = thirdColor;
    tResultsLab.font = Font_14;
    tResultsLab.numberOfLines = 0;
    [_botomView addSubview:tResultsLab];
    
    UILabel *conTResultsLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1) +10, Orgin_y(lineViewV13), SCREENWIDTH - Orgin_x(lineViewH1) -20.f, 45.f)];
    conTResultsLab.text = @"";
    conTResultsLab.textAlignment = NSTextAlignmentCenter;
    conTResultsLab.textColor = sixColor;
    conTResultsLab.font = Font_14;
    conTLxdzLab.numberOfLines = 0;
    _tResultlab = conTResultsLab;
    [_botomView addSubview:_tResultlab];
    
    UIView *lineViewV14 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(tResultsLab), SCREENWIDTH, lineW)];
    lineViewV14.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV14];

    /***********************分割线****************************/
    //申请执行时间
    UILabel *sQZXlab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV14), labWidth, 45.f)];
    sQZXlab.text = @"申请执行时间";
    sQZXlab.textAlignment = NSTextAlignmentCenter;
    sQZXlab.textColor = thirdColor;
    sQZXlab.font = Font_14;
    sQZXlab.numberOfLines = 0;
    [_botomView addSubview:sQZXlab];
    
    UILabel *conSQZXlab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV14), contentLabWidth, 45.f)];
    conSQZXlab.text = @"";
    conSQZXlab.textAlignment = NSTextAlignmentCenter;
    conSQZXlab.textColor = sixColor;
    conSQZXlab.font = Font_14;
    conSQZXlab.numberOfLines = 0;
    _sQZXlab = conSQZXlab;
    [_botomView addSubview:_sQZXlab];
    
    UIView *lineViewH10 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(conSQZXlab), Orgin_y(lineViewV14), lineW,45.f)];
    lineViewH10.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH10];
    
    //执行法院
    UILabel *zxfyLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH10), Orgin_y(lineViewV14), labWidth, 45.f)];
    zxfyLab.text = @"执行法院";
    zxfyLab.textAlignment = NSTextAlignmentCenter;
    zxfyLab.textColor = thirdColor;
    zxfyLab.font = Font_14;
    zxfyLab.numberOfLines = 0;
    [_botomView addSubview:zxfyLab];
    
    UIView *lineViewH11 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(zxfyLab), Orgin_y(lineViewV14), lineW,45.f)];
    lineViewH11.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH11];
    
    UILabel *conZXFGLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH11), Orgin_y(lineViewV14), contentLabWidth, 45.f)];
    conZXFGLab.text = @"";
    conZXFGLab.textAlignment = NSTextAlignmentCenter;
    conZXFGLab.textColor = sixColor;
    conZXFGLab.font = Font_14;
    conZXFGLab.numberOfLines = 0;
    _zXFYlab = conZXFGLab;
    [_botomView addSubview:_zXFYlab];
    
    UIView *lineViewV15 = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(sQZXlab), SCREENWIDTH, lineW)];
    lineViewV15.backgroundColor = lineColor;
    [_botomView addSubview:lineViewV15];
    
    /***********************分割线****************************/

    //执行法官
    UILabel *zxfglab = [[UILabel alloc] initWithFrame:CGRectMake(0, Orgin_y(lineViewV15), labWidth, 45.f)];
    zxfglab.text = @"执行法官";
    zxfglab.textAlignment = NSTextAlignmentCenter;
    zxfglab.textColor = thirdColor;
    zxfglab.font = Font_14;
    zxfglab.numberOfLines = 0;
    [_botomView addSubview:zxfglab];
    
    UILabel *conZxfglab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH1), Orgin_y(lineViewV15), contentLabWidth, 45.f)];
    conZxfglab.text = @"";
    conZxfglab.textAlignment = NSTextAlignmentCenter;
    conZxfglab.textColor = sixColor;
    conZxfglab.font = Font_14;
    conZxfglab.numberOfLines = 0;
    _zXFGlab = conZxfglab;
    [_botomView addSubview:_zXFGlab];
    
    UIView *lineViewH12 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(conZxfglab), Orgin_y(lineViewV15), lineW,45.f)];
    lineViewH12.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH12];
    
    ///联系方式
    UILabel *lxfsLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH12), Orgin_y(lineViewV15), labWidth, 45.f)];
    lxfsLab.text = @"联系方式";
    lxfsLab.textAlignment = NSTextAlignmentCenter;
    lxfsLab.textColor = thirdColor;
    lxfsLab.font = Font_14;
    lxfsLab.numberOfLines = 0;
    [_botomView addSubview:lxfsLab];
    
    UIView *lineViewH13 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lxfsLab), Orgin_y(lineViewV15), lineW,45.f)];
    lineViewH13.backgroundColor = lineColor;
    [_botomView addSubview:lineViewH13];
    
    UILabel *conlxfsLab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineViewH13), Orgin_y(lineViewV15), contentLabWidth, 45.f)];
    conlxfsLab.text = @"";
    conlxfsLab.textAlignment = NSTextAlignmentCenter;
    conlxfsLab.textColor = sixColor;
    conlxfsLab.font = Font_13;
    conlxfsLab.numberOfLines = 0;
    _tLXFSlab = conlxfsLab;
    [_botomView addSubview:_tLXFSlab];
    

    /****************友好分割线************************************/
    
    UIView *sectionView  = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(zxfglab), SCREENWIDTH, 10)];
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
