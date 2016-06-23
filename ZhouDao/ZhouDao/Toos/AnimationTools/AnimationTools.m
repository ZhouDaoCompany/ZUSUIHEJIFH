//
//  AnimationTools.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AnimationTools.h"
/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation AnimationTools

#pragma mark - 登录界面pop动画效果
+ (void)popViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    // 带有颤动  动画效果
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        // 设置旋转中心点
        [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- push动画
+ (void)pushViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT);
    [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
    //旋转角度
    viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    // 带有颤动  动画效果
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        // 设置旋转中心点
        [QZManager setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((360.0f * M_PI) / 180.0f);
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -抖动
+(void)rippleEffectAnimation:(UIView *)views{
    CATransition *anima = [CATransition animation];
    anima.type = @"rippleEffect";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 1.0f;
    anima.repeatCount = MAXFLOAT ;
    [views.layer addAnimation:anima forKey:@"rippleEffectAnimation"];
}
#pragma mark -摇动
+ (void)shakeAnimationWith:(UIView *)views
{
    CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
    NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*2];
    NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*2];
    NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*2];
    anima.values = @[value1,value2,value3];
    anima.repeatCount = MAXFLOAT;
    [views.layer addAnimation:anima forKey:@"shakeAnimation"];
}
#pragma mark -弹出
+ (void)makeAnimationBottom:(UIView *)views
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [views.layer addAnimation:transition forKey:nil];
}
+ (void)makeAnimationFade:(UIViewController *)nextVc :(UINavigationController *)nav
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav pushViewController:nextVc animated:NO];
    
}

+ (void)makeAnimationFade:(UINavigationController *)nav
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [nav.view.layer addAnimation:transition forKey:nil];
    [nav popViewControllerAnimated:NO];
    
}


/*
 
 #import "SDCycleScrollView.h"
 SDCycleScrollViewDelegate
 @property (strong,nonatomic) SDCycleScrollView *cycleScrollView;
 
 _dataArrays = [NSMutableArray arrayWithObjects:@"http://a.hiphotos.baidu.com/zhidao/pic/item/18d8bc3eb13533fafae9926cabd3fd1f41345b10.jpg",@"http://g.hiphotos.baidu.com/zhidao/pic/item/86d6277f9e2f0708fe8a5fd1eb24b899a801f250.jpg",@"http://www.mangowed.com/uploads/allimg/141128/1-14112Q245551T.jpg",@"http://c.hiphotos.baidu.com/zhidao/pic/item/d6ca7bcb0a46f21f94b67c2af5246b600d33aecc.jpg",@"http://b.zol-img.com.cn/desk/bizhi/image/4/960x600/1387880566676.jpg", nil];
 
 NSArray *titleArrays = [NSArray arrayWithObjects:@"上穷碧落下黄泉",@"两处茫茫皆不见",@"在天愿作比翼鸟",@"在地愿为连理枝",@"此恨绵绵无绝期", nil];
 
 _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -180, kMainScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@""]];
 _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
 _cycleScrollView.autoScroll = NO;
 _cycleScrollView.titleLabelHeight = 20.f;
 _cycleScrollView.titleLabelTextFont = Font_14;
 _cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#ffa055"];
 _cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
 _cycleScrollView.imageURLStringsGroup = _dataArrays;
 _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
 _cycleScrollView.titlesGroup = titleArrays;
 _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
 _cycleScrollView.autoresizingMask = YES;
 
 self.automaticallyAdjustsScrollViewInsets = NO;
 [self.tableView addSubview:_cycleScrollView];
 //    self.tableView.tableHeaderView = _cycleScrollView;
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 //    //y值向下拉的时候是负的值
 //    CGFloat yOffset = scrollView.contentOffset.y;
 //    //    NSLog(@"此时的Y坐标    %lf",y);
 //    if (yOffset < -180)
 //    {
 //        CGRect frame = _cycleScrollView.frame;
 //        frame.origin.y = yOffset;
 //        frame.size.height = - yOffset;
 //        _cycleScrollView.frame = frame;
 //    }
 }
 
 #pragma mark - SDCycleScrollViewDelegate
 - (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
 {
 DLog(@"---点击了第%ld张图片", (long)index);
 }

 
 
 */
@end
