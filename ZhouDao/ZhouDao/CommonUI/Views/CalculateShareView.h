//
//  CalculateShareView.h
//  ZhouDao
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CalculateShareDelegate;

@interface CalculateShareView : UIView

@property (nonatomic, weak) id<CalculateShareDelegate>delegate;


- (id)initWithDelegate:(id<CalculateShareDelegate>)delegate;
- (void)show;

@end

@protocol CalculateShareDelegate <NSObject>

@optional

- (void)clickIsWhichOne:(NSInteger)index;
@end
