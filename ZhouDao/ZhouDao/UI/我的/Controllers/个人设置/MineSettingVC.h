//
//  MineSettingVC.h
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void(^ProBlock)();

@interface MineSettingVC : BaseViewController

@property (nonatomic, copy) ZDBlock exitBlock;
/**
 *  认证 @property (nonatomic, copy) ProBlock profBlock;
 */

//@property (nonatomic, copy) ZDBlock headBlock;//修改头像
@end
