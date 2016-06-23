//
//  RecomHeadView.h
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol RecomHeadViewPro <NSObject>
//幻灯片
- (void)getSlideWithCount:(NSUInteger)count;
//常用法规
- (void)commonRegulations;
//赔偿标准
- (void)theCompensationStandard;
//气质文章
- (void)recommendTheArticle;
//滚动条点击
- (void)startAdsClick:(NSString *)idString;
@end

@interface RecomHeadView : UIView

@property (nonatomic, strong) NSArray *recomArrays;//数据源
@property (nonatomic, strong) NSArray *jdArrays;//焦点图片
@property (nonatomic, weak) id<RecomHeadViewPro>delegate;
@property (nonatomic, strong) NSArray *flipPageArr;//滚动条
@end
