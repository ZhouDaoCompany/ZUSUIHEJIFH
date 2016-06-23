//
//  CommonDetailHead.h
//  ZhouDao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSInteger, HeadType)
{
    AccusingHead = 0,//非讼业务
    ConsultantHead =1,//法律顾问
    LitigationHead =2,//诉讼业务
};

#import <UIKit/UIKit.h>

@interface CommonDetailHead : UIView

@property (nonatomic, assign) HeadType type;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, copy) ZDFloatBlock comBlock;

- (id)initWithFrame:(CGRect)frame withArr:(NSArray *)arrays withType:(HeadType)type;

@end
