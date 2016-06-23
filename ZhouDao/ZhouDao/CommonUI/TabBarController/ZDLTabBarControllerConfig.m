//
//  ZDLTabBarControllerConfig.m
//  ZhouDao
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ZDLTabBarControllerConfig.h"

@import Foundation;
@import UIKit;
@interface CYLBaseNavigationController : UINavigationController
@end
@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    self.navigationBarHidden = YES;
    // fix strange animate when use `-[UIViewController cyl_jumpToOtherTabBarControllerItem:(Class)ClassType performSelector:arguments:returnValue:]` ,like this http://i63.tinypic.com/bg766g.jpg . If you have not used this method delete this line blow.
    [(CYLTabBarController *)self.tabBarController rootWindow].backgroundColor = [UIColor whiteColor];
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

#import "HomeViewController.h"
#import "RecomViewController.h"
#import "ToolsViewController.h"
#import "MeViewController.h"

@interface ZDLTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end
@implementation ZDLTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        HomeViewController *firstViewController = [[HomeViewController alloc] init];
        UIViewController *firstNavigationController = [[CYLBaseNavigationController alloc]
                                                       initWithRootViewController:firstViewController];
        
        RecomViewController *secondViewController = [[RecomViewController alloc] init];
        UIViewController *secondNavigationController = [[CYLBaseNavigationController alloc]
                                                        initWithRootViewController:secondViewController];
        
        ToolsViewController *thirdViewController = [[ToolsViewController alloc] init];
        UIViewController *thirdNavigationController = [[CYLBaseNavigationController alloc]
                                                       initWithRootViewController:thirdViewController];
        
        MeViewController *fourthViewController = [[MeViewController alloc] init];
        UIViewController *fourthNavigationController = [[CYLBaseNavigationController alloc]
                                                        initWithRootViewController:fourthViewController];
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        
        // 在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
        [self setUpTabBarItemsAttributesForController:tabBarController];
        
        [tabBarController setViewControllers:@[
                                               firstNavigationController,
                                               secondNavigationController,
                                               thirdNavigationController,
                                               fourthNavigationController
                                               ]];
        // 更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
// IF YOU NEED CUSTOMIZE TABBAR APPEARANCE, REMOVE THE COMMENT '//'
        [[self class] customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

/**
 *  在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
 */
- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"homeUnselect",
                            CYLTabBarItemSelectedImage : @"homeSelect",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"推荐",
                            CYLTabBarItemImage : @"recommentUnSelect",
                            CYLTabBarItemSelectedImage : @"recommentSelect",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"工具",
                            CYLTabBarItemImage : @"ToolsUnSelect",
                            CYLTabBarItemSelectedImage : @"ToolsSelect",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"mineUnSelect",
                            CYLTabBarItemSelectedImage : @"mineSelect"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4
                                       ];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
+ (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] =  [UIColor colorWithHexString:@"#666666"];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = KNavigationBarColor;
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
//    NSUInteger allItemsInTabBarCount = [CYLTabBarController allItemsInTabBarCount];
//    [[UITabBar appearance] setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithHexString:@"#F2"] forSize:CGSizeMake([UIScreen mainScreen].bounds.size.width / allItemsInTabBarCount, 49.f) withCornerRadius:0]];
    
    // set the bar background color
    // 设置背景图片
//     UITabBar *tabBarAppearance = [UITabBar appearance];
//     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background_ios7"]];
    [[UITabBar appearance] setBackgroundImage:[QZManager createImageWithColor:RGBACOLOR(248, 248, 248, 1) size:CGSizeMake(kMainScreenWidth,kTabBarHeight)]];//设置背景，修改颜色是没有用的
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];

}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    return image;
}
@end
