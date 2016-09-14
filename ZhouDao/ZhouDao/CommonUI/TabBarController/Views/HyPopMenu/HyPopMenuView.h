//
//  HyPopMenuView.h
//  ZhouDao
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuLabel;

typedef void(^SelectdCompletionBlock)(MenuLabel *menuLabel,NSInteger index);

@interface HyPopMenuView : UIView
/**
 *  类方法,一句代码弹出HyPopMenuView
 *
 *  @param Items 传入MenuLabel的实例数组
 *  @param block  回调block
 */
+(void)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
           SelectdCompletionBlock:(SelectdCompletionBlock)block;

/**
 *  block回调
 *
 *  @param block block
 */
-(void)SelectdCompletionBlock:(SelectdCompletionBlock)block;


/**
 *  对象方法
 *
 *  @param Itmes 传入MenuLabel的实例数组
 *
 *  @return 返回HyPopMenuView对象
 */
-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes;

@end
