//
//  data.m
//  周道
//
//  Created by _author on 16-05-11.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "ExampleData.h"
#import "DTApiBaseBean.h"
#import <objc/runtime.h>
#import "WZLSerializeKit.h"

//是否使用通用的encode/decode代码一次性encode/decode
#define USING_ENCODE_KIT            1

@implementation ExampleData

@synthesize id = _id;
@synthesize name = _name;
@synthesize nozzle_id = _nozzle_id;
@synthesize pic = _pic;
@synthesize pid = _pid;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(nozzle_id, @"");
		DTAPI_DICT_ASSIGN_STRING(pic, @"");
		DTAPI_DICT_ASSIGN_STRING(pid, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(nozzle_id);
	DTAPI_DICT_EXPORT_BASICTYPE(pic);
	DTAPI_DICT_EXPORT_BASICTYPE(pid);
    return md;
}
WZLSERIALIZE_CODER_DECODER();

@end
