//
//  DateTimeView.h
//  TestDemo
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 zhongGe. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DateTimeBlock)(NSString *timeStr,NSString *sjcStr);

@interface DateTimeView : UIView

@property (nonatomic, copy) DateTimeBlock  timeBlock;
@end
