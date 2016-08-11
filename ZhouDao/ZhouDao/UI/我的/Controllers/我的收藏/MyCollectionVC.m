//
//  MyCollectionVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MyCollectionVC.h"
#import "OrderTitleLab.h"
#import "CollectionTableVC.h"


@interface MyCollectionVC ()<UIScrollViewDelegate>
/** 标题栏 */
@property (strong, nonatomic)  UIScrollView *smallScrollView;
/** 下面的内容栏 */
@property (strong, nonatomic)  UIScrollView *bigScrollView;
@property (strong,nonatomic) NSMutableArray *titleArrays;//标题数组
@property (strong,nonatomic) UIView *redView;//青色跟随

@end

@implementation MyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}
- (void)initView{
    [self setupNaviBarWithBackAndTitle:@"我的收藏"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"" img:@"backVC"];
    
    _titleArrays = [[NSMutableArray alloc] initWithObjects:@"法律法规",@"司法机关",@"相关案例",@"合同模版",@"赔偿标准",nil];
    self.smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 50)];
    self.smallScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.smallScrollView];
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.smallScrollView.scrollsToTop = NO;
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
    self.bigScrollView.scrollEnabled = NO;
    self.bigScrollView.delegate = self;
    self.bigScrollView.scrollsToTop = NO;
    // 添加默认控制器
    CollectionTableVC *vc = [self.childViewControllers firstObject];
    vc.typeString = @"1";
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    OrderTitleLab *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 0.5;
}
- (void)addChildController{
    
    //1法律法规
    CollectionTableVC *lawVC = [CollectionTableVC new];
    [self addChildViewController:lawVC];
    //2 司法机关
    CollectionTableVC *organVC = [CollectionTableVC new];
    [self addChildViewController:organVC];
    //3 相关案例
    CollectionTableVC *caseVC = [CollectionTableVC new];
    [self addChildViewController:caseVC];
    
    //4 合同模版
    CollectionTableVC *templateVC = [CollectionTableVC new];
    [self addChildViewController:templateVC];
    
    //5 赔偿标准
    CollectionTableVC *allVC = [CollectionTableVC new];
    [self addChildViewController:allVC];
    
}
/** 添加标题栏 */
- (void)addLable
{
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = KNavigationBarColor;
    for (NSUInteger i = 0; i < _titleArrays.count; i++) {
        CGFloat lblW = (self.view.bounds.size.width-60)/5.f;
        CGFloat lblH = 49;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW +10*(i+1);
        OrderTitleLab *lbl1 = [[OrderTitleLab alloc]init];
        //UIViewController *vc = self.childViewControllers[i];
        lbl1.text =_titleArrays[i];
        lbl1.font = Font_15;
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
    self.smallScrollView.contentSize = CGSizeMake( kMainScreenWidth-70, 0);
    
    NSString *titileStr = _titleArrays[0];
    CGSize size = [titileStr  sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.f],NSFontAttributeName, nil]];
    _redView.bounds = CGRectMake(0, 0, size.width, 2);
    [self.smallScrollView addSubview:_redView];
}
/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    OrderTitleLab *titlelable = (OrderTitleLab *)recognizer.view;
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
    for (OrderTitleLab *viewLab in _smallScrollView.subviews){
        if ([viewLab isKindOfClass:[OrderTitleLab class]]){
            viewLab.textColor = thirdColor;
            viewLab.scale = 0;
        }
    }
    
    DLog(@"第几个－－－%ld",(unsigned long)index);
    
    // 滚动标题栏
    OrderTitleLab *titleLable = (OrderTitleLab *)[self.smallScrollView viewWithTag:index+2000];
    titleLable.textColor =  KNavigationBarColor;
    // DLog(@"详细信息－－－:%@", [NSString stringWithFormat:@"%@",titleLable]);
    NSString *titileStr =  _titleArrays[index];
    CGSize size = [titileStr  sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.f],NSFontAttributeName, nil]];
    [UIView animateWithDuration:0.2 animations:^{
        _redView.center = CGPointMake(titleLable.center.x, self.smallScrollView.frame.size.height -1.f);
        _redView.bounds = CGRectMake(0, 0, size.width, 2);
        titleLable.scale = 0.5;
    }];
    
    // 添加控制器
    CollectionTableVC *orderVC = self.childViewControllers[index];
    switch (index) {
        case 0:{ //1法律法规
            orderVC.typeString = lawCollect;
        }
            break;
        case 1:{//2 司法机关
            orderVC.typeString = govCollect;
        }
            break;
        case 2:{//3 相关案例
            orderVC.typeString = aboutCollect;
        }
            break;
        case 3:{//4 合同模版
            orderVC.typeString = templateCollect;
        }
            break;
        case 4:{ //5 赔偿标准
            orderVC.typeString = standardCollect;
        }
            break;
        default:
            break;
    }
//    orderVC.typeString = [NSString stringWithFormat:@"%ld",index+1];
    orderVC.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:orderVC.view];
    
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
