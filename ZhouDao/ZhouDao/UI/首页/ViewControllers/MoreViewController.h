//
//  MoreViewController.h
//  ZhouDao
//
//  Created by cqz on 16/5/23.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, MoreType){
    RecomType    = 0,
    ToolsWebType = 1,
};
@interface MoreViewController : BaseViewController

@property (nonatomic, assign) MoreType moreType;

@end
