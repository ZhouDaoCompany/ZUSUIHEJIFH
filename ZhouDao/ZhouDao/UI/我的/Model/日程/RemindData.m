//
//  data.m
//  周道
//
//  Created by _author on 16-04-29.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "RemindData.h"
#import "DTApiBaseBean.h"


@implementation RemindData

@synthesize bell = _bell;
@synthesize content = _content;
@synthesize id = _id;
@synthesize mode_type = _mode_type;
@synthesize regtime = _regtime;
@synthesize repeat_time = _repeat_time;
@synthesize time = _time;
@synthesize title = _title;
@synthesize uid = _uid;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(bell, @"");
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(mode_type, @"");
		DTAPI_DICT_ASSIGN_STRING(regtime, @"");
		DTAPI_DICT_ASSIGN_STRING(repeat_time, @"");
		DTAPI_DICT_ASSIGN_STRING(time, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(bell);
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(mode_type);
	DTAPI_DICT_EXPORT_BASICTYPE(regtime);
	DTAPI_DICT_EXPORT_BASICTYPE(repeat_time);
	DTAPI_DICT_EXPORT_BASICTYPE(time);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    return md;
}
@end
