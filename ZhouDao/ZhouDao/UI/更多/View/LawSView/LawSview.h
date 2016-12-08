//
//  LawSview.h
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPHorizontalScrollView.h"

@interface LawSview : UIView
@property(nonatomic,strong) DPHorizontalScrollView *horizontalScrollView;
@property (nonatomic, copy) ZDBlock searchBlock;
@property (nonatomic, copy) ZDIndexBlock indexBlock;

@end
