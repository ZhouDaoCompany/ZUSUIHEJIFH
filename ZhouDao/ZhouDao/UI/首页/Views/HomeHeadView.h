//
//  HomeHeadView.h
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeHeadViewPro <NSObject>
//幻灯片
- (void)getSlideWithCount:(NSUInteger)count;
@end

@interface HomeHeadView : UIView

@property (nonatomic, strong) NSArray *dataArrays;//数据源
@property (nonatomic, copy) ZDIndexBlock indexBlock;
@property (nonatomic, weak) id<HomeHeadViewPro>delegate;

@end
