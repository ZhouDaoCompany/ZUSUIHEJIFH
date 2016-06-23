//
//  TheCaseWindow.h
//  TestDemo
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 zhongGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZD_CaseWindow : UIWindow

@property (nonatomic ,strong) UIView *zd_superView;

-(void)zd_Windowclose;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title WithContent:(NSString *)contentStr;

@end
