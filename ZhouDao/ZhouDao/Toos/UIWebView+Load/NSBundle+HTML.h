//
//  NSBundle+HTML.h
//  ZhouDao
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (HTML)

+ (NSString*)htmlFromFileName:(NSString*)fileName params:(NSDictionary*)dictionary;

@end
