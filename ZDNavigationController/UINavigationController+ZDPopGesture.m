//
//  UINavigationController+ZDPopGesture.m
//  ZhouDao
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//


#import "UINavigationController+ZDPopGesture.h"
#import <objc/runtime.h>

@implementation UINavigationController (ZDPopGesture)


- (BOOL)fd_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(fd_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

