//
//  ZD_AlertWindow.h
//  ZhouDao
//
//  Created by apple on 16/8/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol ZD_AlertWindowPro;
typedef enum {
    
    ZD_AlertViewStyleNAV    = 0,//导航
    ZD_AlertViewStyleDEL    = 1,//删除
    ZD_AlertViewStyleRename = 3,//重命名
    ZD_AlertViewStyleReview = 2,//审查
    ZD_AlertViewStylePhone  = 4,//电话

    
}ZD_AlertViewStyle;

@interface ZD_AlertWindow : UIView


@property (nonatomic, assign) ZD_AlertViewStyle style;
/*!
 文本对齐方式
 */
@property (nonatomic, assign) NSTextAlignment contentAlignment;
@property (nonatomic, copy)       ZDBlock    cancelBlock;
@property (nonatomic, copy)       ZDBlock    confirmBlock;

@property (nonatomic, weak)   id<ZD_AlertWindowPro>delegate;
/*!
 @abstract      点击取消按钮的回调 驾车导航的回调
 @discussion    如果你不想用代理的方式来进行回调，可使用该方法
 @param         block  点击取消后执行的程序块
 */
- (void)setCancelBlock:(ZDBlock)block;

/*!
 @abstract      点击确定按钮的回调 步行导航的回调
 @discussion    如果你不想用代理的方式来进行回调，可使用该方法
 @param         block  点击确定后执行的程序块
 */
- (void)setConfirmBlock:(ZDBlock)block;


/**
 *   弹出框 导航，审查
 *
 *  @param style 样式
 *  @param title 标题
 *
 *  @return 弹出弹框
 */
- (id)initWithStyle:(ZD_AlertViewStyle)style
  withTextAlignment:(NSTextAlignment)contentAlignment
              Title:(NSString *)title WithOptionOne:(NSString *)optionOne WithOptionTwo:(NSString *)optionTwo;


- (id)initWithStyle:(ZD_AlertViewStyle)style
          withTitle:(NSString *)title
  withTextAlignment:(NSTextAlignment)contentAlignment
           delegate:(id <ZD_AlertWindowPro>)delegate
      withIndexPath:(NSIndexPath *)indexPath;

/*!
 @abstract      弹出
 */
//- (void)show;


//- (void)dismiss;

@end

@protocol ZD_AlertWindowPro <NSObject>

@optional
- (void)customAlertView:(ZD_AlertWindow *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertView:(ZD_AlertWindow *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withName:(NSString *)name withIndexPath:(NSIndexPath *)indexPath;

@end
