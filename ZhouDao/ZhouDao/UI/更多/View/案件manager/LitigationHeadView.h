//
//  LitigationHeadView.h
//  ZhouDao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 诉讼业务
 */

@interface LitigationHeadView : UIView

@property (nonatomic, strong) NSMutableArray *conArrays;
@property (nonatomic, strong) UILabel *expandLab;

@property (nonatomic, copy) ZDBlock caseBlock;

@end
