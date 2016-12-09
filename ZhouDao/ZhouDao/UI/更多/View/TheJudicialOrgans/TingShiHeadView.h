//
//  TingShiHeadView.h
//  ZhouDao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TingShiHeadViewPro;

@interface TingShiHeadView : UIView


@property (weak, nonatomic) id<TingShiHeadViewPro>delegate;

//庭室
- (instancetype)initTingShiHeadViewWithDelegate:(id<TingShiHeadViewPro>)delegate;

//行政审判庭
- (instancetype)initAdministrativeTrialWithSection:(NSUInteger)section withUpOrDown:(BOOL)isUp withDelegate:(id<TingShiHeadViewPro>)delegate;

//简介
- (instancetype)initIntroductionToThe;

//邮箱纠错
- (instancetype)initEmailErrorCorrectionWithFrame:(CGRect)frame;

@end

@protocol TingShiHeadViewPro <NSObject>

- (void)selectTingShiItem;
- (void)onAddOffClickWithSection:(NSUInteger)section;

@end
