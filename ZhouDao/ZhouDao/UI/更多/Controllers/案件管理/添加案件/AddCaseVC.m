//
//  AddCaseVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddCaseVC.h"
#import "LitigationTabVC.h"//诉讼业务
#import "AccusingTheTabVC.h"// 非诉业务
#import "ConsultantTabVC.h"// 法律顾问

#define labWidth (kMainScreenWidth-30)/3.f
@interface AddCaseVC ()<UIScrollViewDelegate>
/** 标题栏 */
@property (strong, nonatomic)  UIScrollView *smallScrollView;
/** 下面的内容栏 */
@property (strong, nonatomic)  UIScrollView *bigScrollView;
@property (strong,nonatomic) NSMutableArray *titleArrays;//标题数组
@property (strong,nonatomic) UIView *redView;//青色跟随

@end

@implementation AddCaseVC
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    self.fd_interactivePopDisabled = YES;

    [self setupNaviBarWithTitle:@"添加案件"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    _titleArrays = [[NSMutableArray alloc] initWithObjects:@"诉讼业务",@"非诉业务",@"法律顾问",nil];
    self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 50)];
    self.smallScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.smallScrollView];
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    
    [self addChildController];
    [self addLable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(_smallScrollView), kMainScreenWidth, .6f)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];

    
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,Orgin_y(lineView), kMainScreenWidth, kMainScreenHeight-Orgin_y(lineView))];
    [self.view addSubview:self.bigScrollView];
    CGFloat contentX = (self.childViewControllers.count) * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
//    self.bigScrollView.scrollEnabled = NO;
    self.bigScrollView.delegate = self;
    
    // 添加默认控制器
    LitigationTabVC *vc = [self.childViewControllers firstObject];
    vc.litEditType = LitiAddCase;
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
}
- (void)addChildController{
    
    //1 诉讼业务
    LitigationTabVC *litigationVC = [LitigationTabVC new];
    //allOrderVC.urlString =
    litigationVC.litEditType = LitiAddCase;
    [self addChildViewController:litigationVC];
    //2 非诉业务
    AccusingTheTabVC *accusingVC = [AccusingTheTabVC new];
    accusingVC.accType = AccFromAddCase;
    [self addChildViewController:accusingVC];
    //3 法律顾问
    ConsultantTabVC *conVC = [ConsultantTabVC new];
    conVC.ConType = ConFromAddCase;
    [self addChildViewController:conVC];
    
}
/** 添加标题栏 */
- (void)addLable
{
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = KNavigationBarColor;
    for (NSUInteger i = 0; i < _titleArrays.count; i++) {
        CGFloat lblW = (self.view.bounds.size.width-40)/3.f;
        CGFloat lblH = 49;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW +10*(i+1);
        UILabel *lbl1 = [[UILabel alloc]init];
        //UIViewController *vc = self.childViewControllers[i];
        lbl1.text =_titleArrays[i];
        lbl1.font = Font_15;
        lbl1.textAlignment = NSTextAlignmentCenter;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i+2000;
        lbl1.userInteractionEnabled = YES;
        lbl1.textColor = thirdColor;
        if (i==0) {
            _redView.center = CGPointMake(lbl1.center.x, self.smallScrollView.frame.size.height -1.f);
            lbl1.textColor = KNavigationBarColor;
        }
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake( kMainScreenWidth-30, 0);
    
    _redView.bounds = CGRectMake(0, 0, labWidth, 2);
    [self.smallScrollView addSubview:_redView];
}
/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    UILabel *titlelable = (UILabel *)recognizer.view;
    [UIView animateWithDuration:0.3 animations:^{
        
        NSUInteger indexS = titlelable.tag -2000;
        CGFloat offsetX = indexS * self.bigScrollView.frame.size.width;
        CGFloat offsetY = self.bigScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [self.bigScrollView setContentOffset:offset animated:YES];
    }];
}
#pragma mark - ******************** scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    for (UILabel *viewLab in _smallScrollView.subviews){
        if ([viewLab isKindOfClass:[UILabel class]]){
            viewLab.textColor = thirdColor;
        }
    }
    
    DLog(@"第几个－－－%ld",(unsigned long)index);
    
    // 滚动标题栏
    UILabel *titleLable = (UILabel *)[self.smallScrollView viewWithTag:index+2000];
    titleLable.textColor =  KNavigationBarColor;
    [UIView animateWithDuration:0.2 animations:^{
        _redView.center = CGPointMake(titleLable.center.x, self.smallScrollView.frame.size.height -1.f);
        _redView.bounds = CGRectMake(0, 0, labWidth, 2);
    }];
    
    // 添加控制器
    switch (index) {
        case 0:{ //1诉讼业务
             LitigationTabVC *orderVC = self.childViewControllers[index];
            orderVC.view.frame = scrollView.bounds;
            orderVC.litEditType = LitiAddCase;
            [self.bigScrollView addSubview:orderVC.view];
        }
            break;
        case 1:{//2 非诉业务
            AccusingTheTabVC *orderVC = self.childViewControllers[index];
            orderVC.view.frame = scrollView.bounds;
            orderVC.accType = AccFromAddCase;
            [self.bigScrollView addSubview:orderVC.view];
        }
            break;
        case 2:{//3 法律顾问
            ConsultantTabVC *orderVC = self.childViewControllers[index];
            orderVC.view.frame = scrollView.bounds;
            orderVC.ConType = ConFromAddCase;
            [self.bigScrollView addSubview:orderVC.view];
        }
            break;
        default:
            break;
    }
    
}
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
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
