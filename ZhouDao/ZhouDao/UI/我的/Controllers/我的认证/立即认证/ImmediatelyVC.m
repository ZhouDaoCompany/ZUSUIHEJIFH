//
//  ImmediatelyVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ImmediatelyVC.h"
#import "CertificationVC.h"
#import "MyAdvantagesVC.h"
#import "AdvantagesModel.h"

@interface ImmediatelyVC ()<UIScrollViewDelegate>
{
    UIImageView *_cerImgView;//认证背景图
    UIImage *_cerImage;//图片
}
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIImageView *photoImgView;//照片
@property (nonatomic,strong) UIView *domainView;//领域选择
@property (nonatomic,strong) NSMutableArray *domainArrays;//擅长领域

@end

@implementation ImmediatelyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"立即认证"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"取消" img:nil];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    self.rightBtn.titleLabel.font = Font_15;
    self.fd_interactivePopDisabled = YES;
    
    _domainArrays = [NSMutableArray array];
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight-64)];
    _bgScrollView.delegate = self;
    //_bgScrollView.bounces = NO;
    _bgScrollView.backgroundColor = ViewBackColor;
    [self.view addSubview:_bgScrollView];
    
    
    _cerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth*8/15.f)];
    _cerImgView.image = [UIImage imageNamed:@"mine_banner.jpg"];
    [_bgScrollView addSubview:_cerImgView];
    
    //1
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(15, Orgin_y(_cerImgView) - 15, kMainScreenWidth-30, 130)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 5.f;
    [_bgScrollView addSubview:view1];
    
    //特权说明
    UILabel *explainLab = [[UILabel alloc] init];
    explainLab.center = CGPointMake(view1.center.x, view1.center.y -65);
    explainLab.bounds = CGRectMake(0, 0, 80, 25);
    [_bgScrollView addSubview:explainLab];
    explainLab.font = Font_14;
    explainLab.textAlignment = NSTextAlignmentCenter;
    explainLab.backgroundColor = [UIColor whiteColor];
    explainLab.text = @"特权说明";
    explainLab.layer.borderWidth = .5f;
    explainLab.textColor = [UIColor colorWithHexString:@"#333333"];
    explainLab.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    explainLab.layer.masksToBounds = YES;
    explainLab.layer.cornerRadius = 12.5f;
    
    NSArray *arr = [NSArray arrayWithObjects:@"1、参与新功能的产品设计；",@"2、优先体验新的产品服务;",@"3、直送1000兆案件管理免费存储空间；",@"4、优先适配优质客户资源。", nil];
    
    for (NSUInteger i =0; i<arr.count; i++)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, i*20 + 25, kMainScreenWidth-60, 20)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.text = arr[i];
        lab.font = Font_13;
        [view1 addSubview:lab];
    }
    
    //立即认证
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(15, Orgin_y(view1) + 15, kMainScreenWidth-30, 105)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.masksToBounds = YES;
    view2.layer.cornerRadius = 5.f;
    [_bgScrollView addSubview:view2];
    
    UILabel *imLab = [[UILabel alloc] init];
    imLab.center = CGPointMake(view1.center.x, view1.center.y +85.f);
    imLab.bounds = CGRectMake(0, 0, 80, 25);
    [_bgScrollView addSubview:imLab];
    imLab.font = Font_14;
    imLab.textAlignment = NSTextAlignmentCenter;
    imLab.backgroundColor = [UIColor whiteColor];
    imLab.text = @"立即认证";
    imLab.layer.borderWidth = .5f;
    imLab.textColor = [UIColor colorWithHexString:@"#333333"];
    imLab.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
    imLab.layer.masksToBounds = YES;
    imLab.layer.cornerRadius = 12.5f;
    //照片
    _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 22.5, 60, 60)];
    _photoImgView.image = [UIImage imageNamed:@"compose_pic_add"];
    _photoImgView.userInteractionEnabled = YES;
    [view2 addSubview:_photoImgView];
    WEAKSELF;
    [view2 whenTapped:^{
        CertificationVC *vc = [CertificationVC new];
        vc.imgBlock = ^(id obj){
            UIImage *image = (UIImage *)obj;
            _cerImage = image;
            weakSelf.photoImgView.image = image;
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];

    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(Orgin_x(_photoImgView) +15, 42.5, 160, 20);
    lab.text = @"上传您的执业证图片";
    lab.font = Font_14;
    lab.textColor = [UIColor colorWithHexString:@"#666666"];
    [view2 addSubview:lab];
    
    
//    //选择领域
//    
//   _domainView = [[UIView alloc] initWithFrame:CGRectMake(15, Orgin_y(view2) + 15, kMainScreenWidth-30, 60)];
//    _domainView.backgroundColor = [UIColor whiteColor];
//    _domainView.layer.masksToBounds = YES;
//    _domainView.layer.cornerRadius = 5.f;
//    [_bgScrollView addSubview:_domainView];
//    
//    UILabel *domainLab = [[UILabel alloc] init];
//    domainLab.center = CGPointMake(view2.center.x, view2.center.y +72.5f);
//    domainLab.bounds = CGRectMake(0, 0, 80, 25);
//    [_bgScrollView addSubview:domainLab];
//    domainLab.font = Font_14;
//    domainLab.textAlignment = NSTextAlignmentCenter;
//    domainLab.backgroundColor = [UIColor whiteColor];
//    domainLab.text = @"选择领域";
//    domainLab.layer.borderWidth = .5f;
//    domainLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    domainLab.layer.borderColor = [UIColor colorWithHexString:@"#d4d4d4"].CGColor;
//    domainLab.layer.masksToBounds = YES;
//    domainLab.layer.cornerRadius = 12.5f;
//    
//    
//    UILabel *setLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 160, 20)];
//    setLab.font = Font_13;
//    setLab.text = @"暂未设置您的擅长领域，";
//    setLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    [_domainView addSubview:setLab];
    
    UIButton *cerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cerBtn.frame = CGRectMake(15, Orgin_y(view2) +35, kMainScreenWidth-30, 45);
    cerBtn.backgroundColor = KNavigationBarColor;
    [cerBtn setTitleColor:[UIColor whiteColor] forState:0];
    [cerBtn setTitle:@"立即认证" forState:0];
    cerBtn.layer.cornerRadius = 5.f;
    cerBtn.layer.masksToBounds = YES;
    [_bgScrollView addSubview:cerBtn];
    [cerBtn addTarget:self action:@selector(imClickEvent:) forControlEvents:UIControlEventTouchUpInside];

    //设置scrollview的contentsize
    _bgScrollView.contentSize = CGSizeMake(kMainScreenWidth, Orgin_y(cerBtn)+45);
    
//    //立即设置
//    CGSize sizes = [ConFunc  calculateLengthOfFont:setLab.text WithFont:13.f WithlabWidth:160];
//    UILabel *imSetLab =[[UILabel alloc] initWithFrame:CGRectMake(75.f + sizes.width, 20, 60, 20)];
//    imSetLab.font = Font_13;
//    imSetLab.text = @"立即设置";
//    imSetLab.textColor = [UIColor colorWithHexString:@"#00c8aa"];
//    [_domainView addSubview:imSetLab];
//    
//    [_domainView whenTapped:^{
//        //进入选择擅长领域
//        MyAdvantagesVC *advc = [MyAdvantagesVC new];
//        advc.type = SelectCer;//从认证界面过去
//        advc.domainBlock = ^(NSMutableArray *arrays){
//            
//            float width = (_domainView.frame.size.width -75.f)/4.f;
//            
//            if (arrays.count >0)
//            {
//                [_domainArrays removeAllObjects];
//                _domainArrays = [arrays mutableCopy];
//                [setLab setHidden:YES];
//                [imSetLab setHidden:YES];
//                
//                float height = 0.f;
//                //擅长  40
//                for (NSUInteger i = 0 ; i < arrays.count;  i ++)
//                {
//                    AdvantagesModel *model = arrays[i];
//                    UILabel *goodLab = [[UILabel alloc] init];
//                    goodLab.frame = CGRectMake( 15*(i%4 + 1) + width * (i%4), 20*(i/4 + 1) + 30 *(i/4) , width, 30);
//                    goodLab.backgroundColor = [UIColor whiteColor];
//                    goodLab.layer.borderColor = [UIColor colorWithHexString:@"#d7d7d7"].CGColor;
//                    goodLab.layer.borderWidth = .5f;
//                    goodLab.font = Font_13;
//                    goodLab.textAlignment = NSTextAlignmentCenter;
//                    goodLab.text = model.sname;
//                    [_domainView addSubview:goodLab];
//                    if (i==arrays.count -1)
//                    {
//                        height = Orgin_y(goodLab);
//                    }
//                }
//                
//                CGRect domainframe = _domainView.frame;
//                domainframe.size.height = height +20;
//                _domainView.frame = domainframe;
//                
//                CGRect cerframe = cerBtn.frame;
//                cerframe.origin.y = Orgin_y(_domainView) +35;
//                cerBtn.frame = cerframe;
//                
//                _bgScrollView.contentSize = CGSizeMake(kMainScreenWidth, Orgin_y(cerBtn)+45);
//            }
//            
//        };
//        [self presentViewController:advc animated:YES completion:nil];
//    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//        //y值向下拉的时候是负的值
//        CGFloat yOffset = scrollView.contentOffset.y;
//        //    NSLog(@"此时的Y坐标    %lf",y);
//        if (yOffset < 0)
//        {
//            CGRect frame = _cerImgView.frame;
//            frame.origin.y = yOffset  - _cerImgView.frame.origin.y;
//            frame.size.height = - yOffset;
//            _cerImgView.frame = frame;
//        }
}
#pragma marrk -UIButtonEvent
- (void)rightBtnAction
{
    if (_cerType == FromRegister) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)leftBtnAction{
    if (_cerType == FromRegister) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)imClickEvent:(id)sender
{
    DLog(@"提交认证");
    if (_cerImage) {
        WEAKSELF
        [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
            [NetWorkMangerTools uploadCertificateImage:_cerImage RequestSuccess:^{

                if (_cerType == FrommMineSetting){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }else{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }];
    }else{
        [JKPromptView showWithImageName:nil message:@"请您添加照片!"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
