//
//  NSBundle+HTML.m
//  ZhouDao
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NSBundle+HTML.h"

@implementation NSBundle (HTML)
+ (NSString*)htmlFromFileName:(NSString*)fileName params:(NSDictionary*)dictionary {
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [NSString stringWithFormat:@"%@/%@" , resourcePath , fileName];
    NSError * error = nil;
    __block NSMutableString * body = [NSMutableString stringWithContentsOfFile:resourcePath
                                                                      encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        return nil;
    }
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString * keyStr = [NSString stringWithFormat:@"${%@}" , key];
        
        [body replaceOccurrencesOfString:keyStr
                              withString:(NSString *)obj
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, [body length])];
        
    }];
    
    return body;

}

@end
