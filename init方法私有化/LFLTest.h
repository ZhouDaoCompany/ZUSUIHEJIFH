//
//  LFLTest.h
//  init方法私有化
//
//  Created by vintop_xiaowei on 2016/10/27.
//  Copyright © 2016年 vintop_DragonLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFLTest : NSObject
// 1.

//- (instancetype)init __attribute__((unavailable("Disabled. Use +sharedInstance instead")));
//2.

//- (instancetype)init NS_UNAVAILABLE;


@end
