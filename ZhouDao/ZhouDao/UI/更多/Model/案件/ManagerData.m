//
//  data.m
//  周道
//
//  Created by _author on 16-05-16.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "ManagerData.h"
#import "DTApiBaseBean.h"


@implementation ManagerData

@synthesize add_time = _add_time;
@synthesize case_id = _case_id;
@synthesize end_time = _end_time;
@synthesize id = _id;
@synthesize name = _name;
@synthesize start_time = _start_time;
@synthesize state = _state;
@synthesize type = _type;
@synthesize uid = _uid;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(add_time, @"");
		DTAPI_DICT_ASSIGN_STRING(case_id, @"");
		DTAPI_DICT_ASSIGN_STRING(end_time, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(start_time, @"");
		DTAPI_DICT_ASSIGN_STRING(state, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(add_time);
	DTAPI_DICT_EXPORT_BASICTYPE(case_id);
	DTAPI_DICT_EXPORT_BASICTYPE(end_time);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(start_time);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    return md;
}
@end
