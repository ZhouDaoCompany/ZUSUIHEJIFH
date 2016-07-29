//
//  BaseViewController.h
//  GNETS
//
//  Created by tcnj on 16/2/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BaseRightBtn.h"
enum{
    NaviLeftBtn = 101,//自定义NavBar左侧的按钮tag值
    NaviRightBtn,//自定义NavBar右侧的按钮tag值
};
typedef NSUInteger NaviBarBtn;

@interface BaseViewController : UIViewController


@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIView *naviBarView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) BaseRightBtn *rightBtn;

//底部划线
@property (strong, nonatomic) UIView *tarBarBgView;
@property (strong, nonatomic) UIView *tarBarGrayView;
@property (strong, nonatomic) UIView *tarBarRoundView;

//设置StatusBar和navBar的颜色和是否隐藏。
- (void)setupStatusBarWithColor:(UIColor *)color;
- (void)setupStatusBarHidden:(BOOL)hidden;
- (void)setupNaviBarWithColor:(UIColor *)color;
- (void)setupNaviBarHidden:(BOOL)hidden;

//设置NavBar中间的title显示文字，
- (void)setupNaviBarWithTitle:(NSString *)title;
//由于创建的时候默认自定义NavBar的左右两边的按钮都是隐藏的所以可用下面的方法设置是否显示。
//setupNaviBarWithBtn:title:img:方法不用管现在隐藏与否直接调用就会显示
- (void)setupNaviBarHiddenBtnWithLeft:(BOOL)left
                                right:(BOOL)right;
//设置左侧的pop样式为箭头加返回
- (void)setupNaviBarWithBackAndTitle:(NSString *)title;
- (void)setupNaviBarWithBtn:(NaviBarBtn)btnTag
                      title:(NSString *)title
                        img:(NSString *)imgName;
- (void)setupNaviBarWithCustomView:(UIView *)view;

- (CGFloat)getNaviBarHeight;
- (CGFloat)getContentHeight;

- (UIView *)getNaviBarView;
- (UILabel *)getTitleLabel;

// Override 子类必须重载在有右按钮显示时。
- (void)handleBtnAction:(UIButton *)btn;
//子类使用，延时加载，避免页面卡顿
-(void)delayInitialLoading;
//子类继承实现右侧按钮
- (void)rightBtnAction;
- (void)leftBtnAction;


@end
