//
//  data.m
//  周道
//
//  Created by _author on 16-05-10.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "LawDetailModel.h"
#import "DTApiBaseBean.h"


@implementation LawDetailModel

@synthesize content = _content;
@synthesize creater = _creater;
@synthesize effect_level = _effect_level;
@synthesize effect_level_no = _effect_level_no;
@synthesize enact_date = _enact_date;
@synthesize enacted_by = _enacted_by;
@synthesize execute_date = _execute_date;
@synthesize id = _id;
@synthesize is_collection = _is_collection;
@synthesize is_common = _is_common;
@synthesize is_delete = _is_delete;
@synthesize is_new = _is_new;
@synthesize modify_time = _modify_time;
@synthesize modifyer = _modifyer;
@synthesize name = _name;
@synthesize orderNo = _orderNo;
@synthesize ref_no = _ref_no;
@synthesize status = _status;
@synthesize sync_time = _sync_time;
@synthesize time_limited = _time_limited;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(creater, @"");
		DTAPI_DICT_ASSIGN_STRING(effect_level, @"");
		DTAPI_DICT_ASSIGN_STRING(effect_level_no, @"");
		DTAPI_DICT_ASSIGN_STRING(enact_date, @"");
		DTAPI_DICT_ASSIGN_STRING(enacted_by, @"");
		DTAPI_DICT_ASSIGN_STRING(execute_date, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_NUMBER(is_collection, @"0");
		DTAPI_DICT_ASSIGN_STRING(is_common, @"");
		DTAPI_DICT_ASSIGN_STRING(is_delete, @"");
		DTAPI_DICT_ASSIGN_STRING(is_new, @"");
		DTAPI_DICT_ASSIGN_STRING(modify_time, @"");
		DTAPI_DICT_ASSIGN_STRING(modifyer, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(orderNo, @"");
		DTAPI_DICT_ASSIGN_STRING(ref_no, @"");
		DTAPI_DICT_ASSIGN_STRING(status, @"");
		DTAPI_DICT_ASSIGN_STRING(sync_time, @"");
		DTAPI_DICT_ASSIGN_STRING(time_limited, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(creater);
	DTAPI_DICT_EXPORT_BASICTYPE(effect_level);
	DTAPI_DICT_EXPORT_BASICTYPE(effect_level_no);
	DTAPI_DICT_EXPORT_BASICTYPE(enact_date);
	DTAPI_DICT_EXPORT_BASICTYPE(enacted_by);
	DTAPI_DICT_EXPORT_BASICTYPE(execute_date);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_collection);
	DTAPI_DICT_EXPORT_BASICTYPE(is_common);
	DTAPI_DICT_EXPORT_BASICTYPE(is_delete);
	DTAPI_DICT_EXPORT_BASICTYPE(is_new);
	DTAPI_DICT_EXPORT_BASICTYPE(modify_time);
	DTAPI_DICT_EXPORT_BASICTYPE(modifyer);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(orderNo);
	DTAPI_DICT_EXPORT_BASICTYPE(ref_no);
	DTAPI_DICT_EXPORT_BASICTYPE(status);
	DTAPI_DICT_EXPORT_BASICTYPE(sync_time);
	DTAPI_DICT_EXPORT_BASICTYPE(time_limited);
    return md;
}
@end
