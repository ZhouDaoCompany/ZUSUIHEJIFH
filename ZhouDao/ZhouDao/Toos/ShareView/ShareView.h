//
//  ShareView.h
//  ZhouDao
//
//  Created by cqz on 16/5/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "ImageView.h"
@class MenuLabel;

typedef void(^SelectdCompletionBlock)(MenuLabel *menuLabel,NSInteger index);

@interface ShareView : UIView

/**
 *  类方法,一句代码弹出PopMenuView
 *
 *  @param Items                      传入MenuLabel的实例数组
 *  @param topView                    顶部View的自定义 (可为nil)
 *  @param openOrCloseAudioDictionary 音频 (可为nil)
 *  @param block                      回调block
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
 *  @param Itmes 传入MenuLabel的实例数组
 *
 *  @return 返回HyPopMenuView对象
 */
-(instancetype) initWithItmes:(NSArray<MenuLabel *> *)Itmes
                   withArrays:(NSArray *)arrsys
                       withVC:(UIViewController *)superVC;


@end
