//
//  FinanceFrameItem.h
//  ZhouDao
//
//  Created by cqz on 16/7/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinanceModel.h"

@interface FinanceFrameItem : NSObject


@property (nonatomic,assign) CGRect titleLabelF;// 标题坐标
@property (nonatomic,assign) CGRect tagViewF;// 标签坐标
@property (nonatomic,assign) CGRect ContentF1;// 内容坐标
@property (nonatomic,assign) CGRect ContentF2;// 展开内容坐标

@property (nonatomic,copy)    NSString *desString;// 内容
@property (nonatomic,strong)  NSArray *labArrays;// 标签数组

/** 行高 */
@property (nonatomic, assign) CGFloat cellHeight1;
@property (nonatomic, assign) CGFloat cellHeight2;//展开行高

/** 所有控件的尺寸都可以通过Status来计算得出 */
@property (nonatomic, strong)  FinanceModel *financeModel;


+ (NSMutableArray *)financeFramesWithDataArr:(NSArray *)dataArr;

@end
