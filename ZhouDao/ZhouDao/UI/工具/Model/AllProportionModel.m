//
//  AllProportionModel.m
//  ZhouDao
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AllProportionModel.h"

@implementation AllProportionModel

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        DTAPI_DICT_ASSIGN_STRING(type, @"");
        DTAPI_DICT_ASSIGN_STRING(con, @"");
        DTAPI_DICT_ASSIGN_STRING(conMax, @"");
        DTAPI_DICT_ASSIGN_STRING(conMin, @"");

    }
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(type);
    DTAPI_DICT_EXPORT_BASICTYPE(con);
    DTAPI_DICT_EXPORT_BASICTYPE(conMax);
    DTAPI_DICT_EXPORT_BASICTYPE(conMin);

    return md;
}

@end
