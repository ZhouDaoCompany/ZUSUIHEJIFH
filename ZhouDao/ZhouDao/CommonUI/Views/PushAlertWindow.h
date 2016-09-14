//
//  PushAlertWindow.h
//  ZhouDao
//
//  Created by apple on 16/6/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger,PushAlertType) {
    
    ElseType = 0,        //时事热点
    ScheduleType = 1,    //日程
    EveryType = 2,        //每日轮播
    Custommsg   = 3,     //自定义消息
};
#import <UIKit/UIKit.h>

@interface PushAlertWindow : UIView

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic, copy)   ZDBlock pushBlock;
@property (nonatomic, assign) PushAlertType type;

-(void)zd_Windowclose;
- (id)initWithFrame:(CGRect)frame
          WithTitle:(NSString *)title
        WithContent:(NSString *)contentStr
           withType:(NSUInteger)type;

@end
