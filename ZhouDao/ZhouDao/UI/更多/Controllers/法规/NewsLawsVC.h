//
//  NewsLawsVC.h
//  ZhouDao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger ,NewsLawType)
{
    commonlyType = 0,
    newsSDType = 1,
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewsLawsVC : BaseViewController
@property (nonatomic, assign) NewsLawType lawType;
@end
