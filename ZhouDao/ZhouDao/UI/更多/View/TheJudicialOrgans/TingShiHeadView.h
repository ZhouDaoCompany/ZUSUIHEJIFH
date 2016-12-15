//
//  TingShiHeadView.h
//  ZhouDao
//
//  Created by apple on 16/12/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Courtroom_base.h"

@protocol TingShiHeadViewPro;

@interface TingShiHeadView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *delBtn;
@property (assign, nonatomic) NSUInteger section;
@property (weak, nonatomic) id<TingShiHeadViewPro>delegate;

//庭室
- (instancetype)initTingShiHeadViewWithDelegate:(id<TingShiHeadViewPro>)delegate;

//行政审判庭
- (instancetype)initAdministrativeTrialWithSection:(NSUInteger)section withCourtroom_base:(Courtroom_base *)baseModel withDelegate:(id<TingShiHeadViewPro>)delegate;

//简介
- (instancetype)initIntroductionToThe;

//邮箱纠错
- (instancetype)initEmailErrorCorrectionWithFrame:(CGRect)frame;

//表头
- (instancetype)initTingShiListHeadViewWithTitleString:(NSString *)titleString
                                            withSetion:(NSUInteger)section
                                          withDelegate:(id<TingShiHeadViewPro>)delegate;
// 庭室列表页
- (instancetype)initTingShiListPageHeadViewWithState:(NSString *)stateString
                                     withTitleString:(NSString *)titleString
                                          withSetion:(NSUInteger)section
                                        withDelegate:(id<TingShiHeadViewPro>)delegate;
@end

@protocol TingShiHeadViewPro <NSObject>

@optional
- (void)selectTingShiItem;
- (void)onAddOffClickWithSection:(NSUInteger)section;
- (void)deleteRedundantTingShiSectionView:(NSUInteger)section;
- (void)editTingShiListView:(NSUInteger)section;
@end
