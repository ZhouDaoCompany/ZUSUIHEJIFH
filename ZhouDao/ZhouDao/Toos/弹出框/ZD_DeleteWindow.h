//
//  ZD_DeleteWindow.h
//  ZhouDao
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, WindowType)
{
    DelType = 0,//删除
    RenameType =1,//重命名
};

#import <UIKit/UIKit.h>

@interface ZD_DeleteWindow : UIView

@property (nonatomic ,strong) UIView *zd_superView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic, copy) ZDBlock DelBlock;
@property (nonatomic,strong) UITextField *nameTextF;
@property (nonatomic, copy) ZDStringBlock renameBlock;
@property (nonatomic, assign) WindowType cusType;
-(void)zd_Windowclose;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withType:(WindowType)type;

@end
