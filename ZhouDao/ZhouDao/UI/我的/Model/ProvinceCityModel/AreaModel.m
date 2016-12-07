//
//  AreaModel.m
//  AlertWindow
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(name, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(id);
    DTAPI_DICT_EXPORT_BASICTYPE(name);
    
    return md;
}

@end
