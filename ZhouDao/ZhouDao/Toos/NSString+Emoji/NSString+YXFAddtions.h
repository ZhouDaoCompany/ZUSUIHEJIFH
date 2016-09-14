//
//  NSString+YXFAddtions.h
//  DoubleXian
//
//  Created by sherlock on 15/1/8.
//  Copyright (c) 2015年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXFAddtions)
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;
@end
