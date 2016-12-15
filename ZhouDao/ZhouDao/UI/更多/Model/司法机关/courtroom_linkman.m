//
//  courtroom_linkman.m
//  周道
//
//  Created by _author on 16-12-15.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "Courtroom_linkman.h"
#import "DTApiBaseBean.h"


@implementation Courtroom_linkman

@synthesize bid = _bid;
@synthesize id = _id;
@synthesize name = _name;
@synthesize phone = _phone;
@synthesize type = _type;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(bid, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(bid);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
    return md;
}
@end
