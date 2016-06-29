//
//  FinanceDesCell.h
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FinanceDesCellPro <NSObject>

- (void)expandOrClose:(UITableViewCell *)cell;

@end

@interface FinanceDesCell : UITableViewCell
{
    CGSize ziTiSize;

}

@property (nonatomic,strong) UILabel *lab;
@property (nonatomic,strong) UIButton *showAllButton;
@property (nonatomic,assign) BOOL isExpandable;    // 是否显示"收起"按钮
@property (nonatomic,assign) BOOL expanded;     // 收起或展开操作
@property (nonatomic,copy) NSString *desString;//商品介绍
@property (nonatomic,assign) CGFloat rowHeight;//高度


@property (nonatomic,assign)id<FinanceDesCellPro>delegate;//代理

@end
