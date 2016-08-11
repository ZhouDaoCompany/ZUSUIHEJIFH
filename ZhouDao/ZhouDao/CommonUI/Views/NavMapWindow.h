//
//  NavMapWindow.h
//  ZhouDao
//
//  Created by cqz on 16/3/24.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavMapWindow : UIView

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, copy) ZDStringBlock navBlock;
-(void)zd_Windowclose;

@end
