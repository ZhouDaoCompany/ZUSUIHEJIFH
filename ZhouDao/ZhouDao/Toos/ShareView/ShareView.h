//
//  ShareView.h
//  ZhouDao
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuLabel;

typedef void(^SelectdCompletionBlock)(MenuLabel *menuLabel,NSInteger index);
@interface ShareView : UIView

/**
 *  类方法,一句代码弹出ShareView
 *
 *  @param Items       传入MenuLabel的实例数组
 *  @param arrays      分享内容
 *  @param presentedVC 所在试图控制器
 *  @param block       回调block
 */
+(void)CreatingPopMenuObjectItmes:(NSArray<MenuLabel *> *)Items
                    contentArrays:(NSArray *)arrays
          withPresentedController:(UIViewController *)presentedVC
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
 *  @param Itmes   @param Itmes 传入MenuLabel的实例数组
 *  @param arrsys  分享内容
 *  @param superVC 所在试图控制器
 *
 *  @return @return 返回ShareView对象
 */
-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes
                   withArrays:(NSArray *)arrsys
                       withVC:(UIViewController *)superVC;


@end
