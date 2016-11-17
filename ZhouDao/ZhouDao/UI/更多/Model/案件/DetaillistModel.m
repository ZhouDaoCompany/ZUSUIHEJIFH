//
//  data.m
//  周道
//
//  Created by _author on 16-05-19.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "DetaillistModel.h"
#import "DTApiBaseBean.h"


@implementation DetaillistModel

@synthesize cid = _cid;
@synthesize id = _id;
@synthesize name = _name;
@synthesize pid = _pid;
@synthesize qiniu_name = _qiniu_name;
@synthesize type_file = _type_file;
@synthesize type_format = _type_format;
@synthesize uid = _uid;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(cid, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(pid, @"");
		DTAPI_DICT_ASSIGN_STRING(qiniu_name, @"");
		DTAPI_DICT_ASSIGN_STRING(type_file, @"");
		DTAPI_DICT_ASSIGN_STRING(type_format, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
        DTAPI_DICT_ASSIGN_STRING(thumbnail, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(cid);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(pid);
	DTAPI_DICT_EXPORT_BASICTYPE(qiniu_name);
	DTAPI_DICT_EXPORT_BASICTYPE(type_file);
	DTAPI_DICT_EXPORT_BASICTYPE(type_format);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    DTAPI_DICT_EXPORT_BASICTYPE(thumbnail);
    return md;
}
@end
