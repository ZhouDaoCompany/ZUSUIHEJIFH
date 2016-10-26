//
//  VerticalMenuButton.h
//  ZhouDao
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalMenuButton : UIView

+ (instancetype)showWithImageNameArray:(NSArray *)nameArray clickBlock:(void (^)(NSInteger index))clickBlock bottomPosition:(CGPoint)point;

@end
