//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "CYLTabBarController.h"
#import "MenuLabel.h"
#import "HyPopMenuView.h"
#import "LawsViewController.h" //法规
#import "GovermentVC.h" //司法机关
#import "TemplateViewController.h"
#import "CompensationVC.h" //赔偿标准
#import "TheCaseManageVC.h"//案件管理
#import "ExampleSearchVC.h"//案例查询
#import "LoginViewController.h"

#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view

#define Objs @[[MenuLabel CreatelabelIconName:@"tabbar_LawsRegular" Title:@"法律法规"],[MenuLabel CreatelabelIconName:@"tabbar_judicial" Title:@"司法机关"],[MenuLabel CreatelabelIconName:@"tabbar_template" Title:@"合同模版"],[MenuLabel CreatelabelIconName:@"home_peichangbiaozhun" Title:@"赔偿标准"],[MenuLabel CreatelabelIconName:@"tabbar_CaseQuery" Title:@"查询案例"],[MenuLabel CreatelabelIconName:@"tabbar_management" Title:@"案件管理"]]


@interface CYLPlusButtonSubclass () {
    CGFloat _buttonImageHeight;
}

@end

@implementation CYLPlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+ (void)load {
    [super registerSubclass];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//上下结构的 button
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    // 控件大小,间距大小
//    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
//    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth * 0.9;
//    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
//    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
//    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdgeWidth;
//    CGFloat const verticalMargin  = verticalMarginT / 2;
//    
//    // imageView 和 titleLabel 中心的 Y 值
//    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeWidth * 0.5;
//    CGFloat const centerOfTitleLabel = imageViewEdgeWidth  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
//    
//    //imageView position 位置
//    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
//    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
//    
//    //title position 位置
//    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
//    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

#pragma mark -
#pragma mark - CYLPlusButtonSubclassing Methods

/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
//+ (instancetype)plusButton {
//    CYLPlusButtonSubclass *button = [[CYLPlusButtonSubclass alloc] init];
//    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"更多" forState:UIControlStateNormal];
//    [button setTitleColor:RGBACOLOR(248, 248, 248, 1) forState:UIControlStateNormal];
//    
////    [button setTitle:@"选中" forState:UIControlStateSelected];
////    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
//    [button addTarget:button action:@selector(clickPublish:) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (instancetype)plusButton
{

    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];

    CYLPlusButtonSubclass* button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];

    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];

//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(clickPublish:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPublish:(id)sender {
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabBarController.selectedViewController;
    
    [HyPopMenuView CreatingPopMenuObjectItmes:Objs SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        DLog(@"index:%ld ItmeNmae:%@",(long)index,menuLabel.title);
        if (index == 0)
        {
            LawsViewController *lawVC = [LawsViewController new];
            lawVC.lawType = LawFromAdd;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lawVC];
            //            lawVC.modalPresentationStyle = UIModalPresentationNone;/*设置这个属性背景就是透明的，而不是黑色的了*/
            [viewController presentViewController:nav animated:NO completion:nil];
        }else if (index == 1){
            GovermentVC *govVC = [GovermentVC new];
            govVC.Govtype = GovFromAdd;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:govVC];
            [viewController presentViewController:nav animated:NO completion:nil];
        }else if (index == 2){
            
            TemplateViewController *templateVC = [TemplateViewController new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:templateVC];
            [viewController presentViewController:nav animated:NO completion:nil];
        }else if (index == 3){
            
            CompensationVC *vc = [CompensationVC new];
            vc.pType = CompensationFromAdd;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [viewController presentViewController:nav animated:NO completion:nil];
        }else if (index == 4){
            ExampleSearchVC *vc = [ExampleSearchVC new];
            vc.sType = SearchFromAdd;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [viewController presentViewController:nav animated:NO completion:nil];
        }else if (index == 5){
            //            [JKPromptView showWithImageName:nil message:@"功能正在开发中,敬请期待"];
            if ([PublicFunction ShareInstance].m_bLogin == YES) {
                TheCaseManageVC *vc = [TheCaseManageVC new];
                vc.type = FromAddType;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [viewController presentViewController:nav animated:NO completion:nil];
            }else{
                LoginViewController *loginVc = [LoginViewController new];
                loginVc.closeBlock = ^{
                    if ([PublicFunction ShareInstance].m_bLogin == YES)
                    {
                        TheCaseManageVC *vc = [TheCaseManageVC new];
                        vc.type = FromAddType;
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                        [viewController presentViewController:nav animated:NO completion:nil];
                    }
                };
                [viewController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVc] animated:YES completion:nil];
                
            }
        }

    }];
    
}


#pragma mark - CYLPlusButtonSubclassing

//+ (UIViewController *)plusChildViewController {
//    UIViewController *plusChildViewController = [[UIViewController alloc] init];
//    plusChildViewController.view.backgroundColor = [UIColor redColor];
//    plusChildViewController.navigationItem.title = @"PlusChildViewController";
//    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:plusChildViewController];
//    return plusChildNavigationController;
//}
//
//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 2;
//}

+ (CGFloat)multiplerInCenterY {
    return  0.3;
}

@end
