//
//  FinanceDesCell.h
//  ZhouDao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinanceModel.h"

@protocol FinanceDesCellPro <NSObject>

- (void)expandOrClose:(UITableViewCell *)cell;
//- (void)TheRefreshTableCell:(UITableViewCell *)cell;

@end

@interface FinanceDesCell : UITableViewCell
{
    CGSize ziTiSize;

}

@property (nonatomic, strong)  UILabel *titlab;//标题
@property (nonatomic, strong)  UILabel *lab;
@property (nonatomic, strong)  UIButton *showAllButton;
@property (nonatomic, assign)  BOOL expanded;     // 收起或展开操作
@property (nonatomic, copy)    NSString *desString;//商品介绍
//@property (nonatomic, assign)  CGFloat rowHeight;//高度

@property (nonatomic, strong)  FinanceModel *financeModel;

@property (nonatomic,assign)id<FinanceDesCellPro>delegate;//代理

- (void)setTitArr:(NSArray *)titArr withconArr:(NSArray*)conArr;

@end
