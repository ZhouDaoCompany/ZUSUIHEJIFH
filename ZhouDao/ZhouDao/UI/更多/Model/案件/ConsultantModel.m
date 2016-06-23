//
//  detailed.m
//  周道
//
//  Created by _author on 16-05-16.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "ConsultantModel.h"
#import "DTApiBaseBean.h"


@implementation ConsultantModel

@synthesize address = _address;
@synthesize business = _business;
@synthesize client = _client;
@synthesize contacts = _contacts;
@synthesize deputy = _deputy;
@synthesize id = _id;
@synthesize is_remind = _is_remind;
@synthesize mail = _mail;
@synthesize partner = _partner;
@synthesize phone = _phone;
@synthesize sign_time = _sign_time;
@synthesize sign_year = _sign_year;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(business, @"");
		DTAPI_DICT_ASSIGN_STRING(client, @"");
		DTAPI_DICT_ASSIGN_STRING(contacts, @"");
		DTAPI_DICT_ASSIGN_STRING(deputy, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(is_remind, @"");
		DTAPI_DICT_ASSIGN_STRING(mail, @"");
		DTAPI_DICT_ASSIGN_STRING(partner, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(sign_time, @"");
		DTAPI_DICT_ASSIGN_STRING(sign_year, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(business);
	DTAPI_DICT_EXPORT_BASICTYPE(client);
	DTAPI_DICT_EXPORT_BASICTYPE(contacts);
	DTAPI_DICT_EXPORT_BASICTYPE(deputy);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_remind);
	DTAPI_DICT_EXPORT_BASICTYPE(mail);
	DTAPI_DICT_EXPORT_BASICTYPE(partner);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(sign_time);
	DTAPI_DICT_EXPORT_BASICTYPE(sign_year);
    return md;
}
@end
