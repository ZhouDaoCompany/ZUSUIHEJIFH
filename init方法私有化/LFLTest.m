//
//  LFLTest.m
//  init方法私有化
//
//  Created by vintop_xiaowei on 2016/10/27.
//  Copyright © 2016年 vintop_DragonLi. All rights reserved.
//

#import "LFLTest.h"

@implementation LFLTest

//3. 内部不响应 不建议!
- (instancetype)init {
   // 抛出不识别,没有说明真的原因
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}

// 通过断言
- (instancetype)init1{
    NSAssert(false,@"unavailable, use sharedInstance instead");
    return nil;
}

// 通过异常
- (instancetype)init2{
    [NSException raise:NSGenericException format:@"Disabled. Use +[%@ %@] instead",
     NSStringFromClass([self class]),
     NSStringFromSelector(@selector(sharedInstance))];
    
    return nil;
}

@end
