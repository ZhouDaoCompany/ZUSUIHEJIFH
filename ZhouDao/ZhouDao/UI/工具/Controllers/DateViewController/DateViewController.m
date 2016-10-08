//
//  DateViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "DateViewController.h"
#import "RiQiTablViewController.h"
#import "DayTabViewController.h"

@interface DateViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIButton *dayButton;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation DateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
- (void)rightBtnAction
{
    
    // 获得索引
    NSInteger index = self.bigScrollView.contentOffset.x / self.bigScrollView.frame.size.width;

    if (index == 0) {
        [GcNoticeUtil sendNotification:@"DayTabViewController"];
    }else {
        [GcNoticeUtil sendNotification:@"RiQiTablViewController"];
    }
}
#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"日期计算"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    
    [self addChildControllers];
    [self.view addSubview:self.dayButton];
    [self.view addSubview:self.dateButton];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.bigScrollView];
    
    // 添加默认控制器
    DayTabViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
}
- (void)addChildControllers
{
    DayTabViewController *dayVC = [DayTabViewController new];
    [self addChildViewController:dayVC];
    
    RiQiTablViewController *riqiVC = [RiQiTablViewController new];
    [self addChildViewController:riqiVC];
}
#pragma mark - event response
- (void)dayAndDateBtnEvent:(UIButton *)button
{WEAKSELF;
    NSInteger index = button.tag - 3043;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        weakSelf.bottomView.frame =  CGRectMake((kMainScreenWidth/2.f)*index , 108, kMainScreenWidth/2.f, 1);
        CGFloat offsetX = index * self.bigScrollView.frame.size.width;
        CGFloat offsetY = self.bigScrollView.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [self.bigScrollView setContentOffset:offset animated:YES];
    }];
}
#pragma mark - ******************** scrollView代理方法
/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{WEAKSELF;
    // 获得索引
    NSInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        weakSelf.bottomView.frame =  CGRectMake((kMainScreenWidth/2.f)*index , 108, kMainScreenWidth/2.f, 1);
    }];

    switch (index) {
        case 0:
        {
            DayTabViewController *dayVC = self.childViewControllers[index];
            dayVC.view.frame = scrollView.bounds;
            [self.bigScrollView addSubview:dayVC.view];
        }
            break;
        case 1:
        {
            RiQiTablViewController *riqiVC = self.childViewControllers[index];
            riqiVC.view.frame = scrollView.bounds;
            [self.bigScrollView addSubview:riqiVC.view];
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
#pragma mark - setter and getter
- (UIScrollView *)bigScrollView
{
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,109.f, kMainScreenWidth, kMainScreenHeight - 109.f)];
        CGFloat contentX = (self.childViewControllers.count) * [UIScreen mainScreen].bounds.size.width;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.contentSize = CGSizeMake(contentX, 0);
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.showsHorizontalScrollIndicator = NO;
//        _bigScrollView.scrollEnabled = NO;
        _bigScrollView.delegate = self;
        _bigScrollView.scrollsToTop = NO;
    }
    return _bigScrollView;
}
- (UIButton *)dateButton
{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _dateButton.frame = CGRectMake(kMainScreenWidth/2.f , 64, kMainScreenWidth/2.f, 44);
        _dateButton.backgroundColor  = [UIColor clearColor];
        [_dateButton setTitleColor:hexColor(00c8aa) forState:0];
        [_dateButton setTitle:@"日期计算" forState:0];
        _dateButton.titleLabel.font = Font_15;
        _dateButton.tag = 3044;
        [_dateButton addTarget:self action:@selector(dayAndDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateButton;
}
- (UIButton *)dayButton
{
    if (!_dayButton) {
        _dayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _dayButton.frame = CGRectMake(0 , 64, kMainScreenWidth/2.f, 44);
        _dayButton.backgroundColor  =[UIColor clearColor];
        [_dayButton setTitleColor:hexColor(00c8aa) forState:0];
        [_dayButton setTitle:@"天数计算" forState:0];
        _dayButton.titleLabel.font = Font_15;
        _dayButton.tag = 3043;
        [_dayButton addTarget:self action:@selector(dayAndDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dayButton;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, kMainScreenWidth/2.f, 1)];
        _bottomView.backgroundColor = hexColor(00c8aa);
    }
    return _bottomView;
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
