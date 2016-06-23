//
//  detailed.m
//  周道
//
//  Created by _author on 16-05-17.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "LitigationModel.h"
#import "DTApiBaseBean.h"


@implementation LitigationModel

@synthesize apply_execute_time = _apply_execute_time;
@synthesize court_time = _court_time;
@synthesize defendant = _defendant;
@synthesize execute_court = _execute_court;
@synthesize execute_judge = _execute_judge;
@synthesize execute_phone = _execute_phone;
@synthesize firs_address = _firs_address;
@synthesize firs_court = _firs_court;
@synthesize firs_judge = _firs_judge;
@synthesize firs_phone = _firs_phone;
@synthesize firs_result = _firs_result;
@synthesize id = _id;
@synthesize name = _name;
@synthesize plaintiff = _plaintiff;
@synthesize someoneelse = _someoneelse;
@synthesize thyend = _thyend;
@synthesize thyend_time = _thyend_time;
@synthesize thytake = _thytake;
@synthesize thytake_time = _thytake_time;
@synthesize two_address = _two_address;
@synthesize two_court = _two_court;
@synthesize two_judge = _two_judge;
@synthesize two_phone = _two_phone;
@synthesize two_result = _two_result;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(apply_execute_time, @"");
		DTAPI_DICT_ASSIGN_STRING(court_time, @"");
		DTAPI_DICT_ASSIGN_STRING(defendant, @"");
		DTAPI_DICT_ASSIGN_STRING(execute_court, @"");
		DTAPI_DICT_ASSIGN_STRING(execute_judge, @"");
		DTAPI_DICT_ASSIGN_STRING(execute_phone, @"");
		DTAPI_DICT_ASSIGN_STRING(firs_address, @"");
		DTAPI_DICT_ASSIGN_STRING(firs_court, @"");
		DTAPI_DICT_ASSIGN_STRING(firs_judge, @"");
		DTAPI_DICT_ASSIGN_STRING(firs_phone, @"");
		DTAPI_DICT_ASSIGN_STRING(firs_result, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(plaintiff, @"");
		DTAPI_DICT_ASSIGN_STRING(someoneelse, @"");
		DTAPI_DICT_ASSIGN_STRING(thyend, @"");
		DTAPI_DICT_ASSIGN_STRING(thyend_time, @"");
		DTAPI_DICT_ASSIGN_STRING(thytake, @"");
		DTAPI_DICT_ASSIGN_STRING(thytake_time, @"");
		DTAPI_DICT_ASSIGN_STRING(two_address, @"");
		DTAPI_DICT_ASSIGN_STRING(two_court, @"");
		DTAPI_DICT_ASSIGN_STRING(two_judge, @"");
		DTAPI_DICT_ASSIGN_STRING(two_phone, @"");
		DTAPI_DICT_ASSIGN_STRING(two_result, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(apply_execute_time);
	DTAPI_DICT_EXPORT_BASICTYPE(court_time);
	DTAPI_DICT_EXPORT_BASICTYPE(defendant);
	DTAPI_DICT_EXPORT_BASICTYPE(execute_court);
	DTAPI_DICT_EXPORT_BASICTYPE(execute_judge);
	DTAPI_DICT_EXPORT_BASICTYPE(execute_phone);
	DTAPI_DICT_EXPORT_BASICTYPE(firs_address);
	DTAPI_DICT_EXPORT_BASICTYPE(firs_court);
	DTAPI_DICT_EXPORT_BASICTYPE(firs_judge);
	DTAPI_DICT_EXPORT_BASICTYPE(firs_phone);
	DTAPI_DICT_EXPORT_BASICTYPE(firs_result);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(plaintiff);
	DTAPI_DICT_EXPORT_BASICTYPE(someoneelse);
	DTAPI_DICT_EXPORT_BASICTYPE(thyend);
	DTAPI_DICT_EXPORT_BASICTYPE(thyend_time);
	DTAPI_DICT_EXPORT_BASICTYPE(thytake);
	DTAPI_DICT_EXPORT_BASICTYPE(thytake_time);
	DTAPI_DICT_EXPORT_BASICTYPE(two_address);
	DTAPI_DICT_EXPORT_BASICTYPE(two_court);
	DTAPI_DICT_EXPORT_BASICTYPE(two_judge);
	DTAPI_DICT_EXPORT_BASICTYPE(two_phone);
	DTAPI_DICT_EXPORT_BASICTYPE(two_result);
    return md;
}
@end
