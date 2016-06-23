//
//  ZD_SelectDateWindow.h
//  ZhouDao
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

typedef  void(^WindowBlock)(NSString *start,NSString *end);

#import <UIKit/UIKit.h>

@interface ZD_SelectDateWindow : UIWindow

@property (nonatomic,strong) UILabel *endLab;
@property (nonatomic,strong) UILabel *startLab;

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, copy) WindowBlock selectBlock;
-(void)zd_Windowclose;

@end
