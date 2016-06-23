//
//  detailed.m
//  周道
//
//  Created by _author on 16-05-17.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "AccusModel.h"
#import "DTApiBaseBean.h"


@implementation AccusModel

@synthesize client = _client;
@synthesize client_address = _client_address;
@synthesize client_mail = _client_mail;
@synthesize client_phone = _client_phone;
@synthesize id = _id;
@synthesize name = _name;
@synthesize thyend_shape = _thyend_shape;
@synthesize thyend_time = _thyend_time;
@synthesize thytake_time = _thytake_time;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(client, @"");
		DTAPI_DICT_ASSIGN_STRING(client_address, @"");
		DTAPI_DICT_ASSIGN_STRING(client_mail, @"");
		DTAPI_DICT_ASSIGN_STRING(client_phone, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(thyend_shape, @"");
		DTAPI_DICT_ASSIGN_STRING(thyend_time, @"");
		DTAPI_DICT_ASSIGN_STRING(thytake_time, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(client);
	DTAPI_DICT_EXPORT_BASICTYPE(client_address);
	DTAPI_DICT_EXPORT_BASICTYPE(client_mail);
	DTAPI_DICT_EXPORT_BASICTYPE(client_phone);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(thyend_shape);
	DTAPI_DICT_EXPORT_BASICTYPE(thyend_time);
	DTAPI_DICT_EXPORT_BASICTYPE(thytake_time);
    return md;
}
@end
