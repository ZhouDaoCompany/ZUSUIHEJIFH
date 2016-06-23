//
//  data.m
//  周道
//
//  Created by _author on 16-05-04.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/

#import "TheContractData.h"
#import "DTApiBaseBean.h"
#import "WZLSerializeKit.h"
#import <objc/runtime.h>

@implementation TheContractData

@synthesize ctname = _ctname;
@synthesize id = _id;
@synthesize pic = _pic;
@synthesize pid = _pid;
@synthesize sorting = _sorting;

//是否使用通用的encode/decode代码一次性encode/decode
#define USING_ENCODE_KIT            1

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(ctname, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(pic, @"");
		DTAPI_DICT_ASSIGN_STRING(pid, @"");
		DTAPI_DICT_ASSIGN_STRING(sorting, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(ctname);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(pic);
	DTAPI_DICT_EXPORT_BASICTYPE(pid);
	DTAPI_DICT_EXPORT_BASICTYPE(sorting);
    return md;
}
WZLSERIALIZE_CODER_DECODER();

@end
