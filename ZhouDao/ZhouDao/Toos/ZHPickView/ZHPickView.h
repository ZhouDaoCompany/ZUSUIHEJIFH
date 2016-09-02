//
//  HLPickView.h
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickView;
typedef void (^HLPickViewSubmit)(NSString*name,NSString *typeS);

@interface ZHPickView : UIView<UIPickerViewDelegate>

- (void)setDateViewWithTitle:(NSString *)title;

- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title;
- (void)showPickView:(UIViewController *)vc;
- (void)showWindowPickView:(UIWindow *)window;

@property(nonatomic, copy) HLPickViewSubmit block;
@property(nonatomic, copy) ZDStringBlock alertBlock;
@end
