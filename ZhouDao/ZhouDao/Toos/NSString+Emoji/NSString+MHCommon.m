//
//  NSString+MHCommon.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "NSString+MHCommon.h"

// MD5加密
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (MHCommon)

#pragma mark - 过滤html特殊字符
- (NSString *)ignoreHTMLSpecialString
{
    NSString *returnStr = [self stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    // 如果还有别的特殊字符，请添加在这里
    // ...
    /*
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&ge;" withString:@"—"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"®"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
     returnStr = [returnStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
     */
    
    return returnStr;
}


#pragma mark - MD5加密
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark - URL编码
- (NSString *)urlCodingToUTF8
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - URL解码
- (NSString *)urlDecodingToUrlString
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - 文本国际化
+ (NSString *)stringByI18nDict:(NSDictionary *)dict
{
    NSString *language  = [QZManager currentLanguage];
    NSString *text      = dict[language];
    if (text && [text respondsToSelector:@selector(lowercaseString)]) {
        return text;
    }
    // 没有在当前语言下找到合适的文字，去找临近的语言，最后实在不行就返回英语版本的
    if ([@"chs" isEqualToString:language]
        && ( text = dict[@"cht"] ) != nil
        ) {
        return text;
    }
    
    if ([@"cht" isEqualToString:language]
        && ( text = dict[@"chs"] ) != nil
        ) {
        return text;
    }
    
    text = dict[@"en"];
    
    if (text)
    {
        // 英语版本的在，只能凑合一下了
        return text;
    }
    
    // 实在没有合适的语言，返回nil
    return nil;
}

@end
