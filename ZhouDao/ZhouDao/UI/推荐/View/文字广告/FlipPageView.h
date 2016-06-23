//
//  FlipPageView.h
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipPageView : UIView

@property(nonatomic,assign)NSInteger                iDisplayTime; //广告文字轮播时停留的时间，默认0秒不会轮播

/**
 *  启动函数
 *
 *  @param imageArray 设置文字数组
 *  @param block      block，回调点击
 */

- (void)startAdsWithBlock:(NSArray*)textArray block:(ZDIndexBlock)block;
/**
 *  停止广告轮播，释放内存
 *  不再使用 FlipPageView 时，先调用 stopAds，释放 timer占用，从runloop中退出。否则会常驻内存。
 */
- (void)stopAds;

@end
