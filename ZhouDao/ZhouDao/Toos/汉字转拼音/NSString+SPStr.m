//
//  NSString+SPStr.m
//  searchTest
//
//  Created by 孙鹏 on 14-8-29.
//  Copyright (c) 2014年 ___sp___. All rights reserved.
//

#import "NSString+SPStr.h"

@implementation NSString (SPStr)

+ (NSString*)HanZiZhuanPinYin:(NSString*)HanZistr
{
    //NSString *Astr = @"中国abc人民共和国";
    CFStringRef aCFString = (__bridge CFStringRef)HanZistr;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, aCFString);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    //NSLog(@"中国 = %@", string);
    //CFRelease(string);
    
    return (__bridge NSString*)string;
    
}

@end
