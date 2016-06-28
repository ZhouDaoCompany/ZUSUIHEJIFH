//
//  MoreModel.m
//  ZhouDao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MoreModel.h"
#import "DTApiBaseBean.h"


@implementation MoreModel

@synthesize id = _id;
@synthesize pid = _pid;
@synthesize type = _type;
@synthesize content = _content;
@synthesize state = _state;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(pid, @"");
        DTAPI_DICT_ASSIGN_STRING(type, @"");
        DTAPI_DICT_ASSIGN_ARRAY_BASICTYPE(content);
        DTAPI_DICT_ASSIGN_STRING(state, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(id);
    DTAPI_DICT_EXPORT_BASICTYPE(pid);
    DTAPI_DICT_EXPORT_BASICTYPE(type);
    DTAPI_DICT_EXPORT_ARRAY_BEAN(content);
    DTAPI_DICT_EXPORT_BASICTYPE(state);
    
    return md;
}

@end
