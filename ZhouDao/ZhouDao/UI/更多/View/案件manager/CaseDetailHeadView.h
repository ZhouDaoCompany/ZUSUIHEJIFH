//
//  CaseDetailHeadView.h
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 非诉讼业务
 */
@interface CaseDetailHeadView : UIView

@property (nonatomic, strong) NSMutableArray *conArrays;
@property (nonatomic, strong) UILabel *expandLab;

@property (nonatomic, copy) ZDBlock caseBlock;
@end
