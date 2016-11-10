//
//  file.m
//  周道
//
//  Created by _author on 16-11-10.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "PlistFileModel.h"
#import "DTApiBaseBean.h"


@implementation PlistFileModel

@synthesize address = _address;
@synthesize name = _name;
@synthesize version = _version;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(version, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(version);
    return md;
}
@end
