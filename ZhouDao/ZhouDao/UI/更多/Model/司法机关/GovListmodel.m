//
//  GovListmodel.m
//  周道
//
//  Created by _author on 16-12-15.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "GovListmodel.h"
#import "DTApiBaseBean.h"
#import "Courtroom_base.h"


@implementation GovListmodel

@synthesize address = _address;
@synthesize area_id = _area_id;
@synthesize city = _city;
@synthesize court_category = _court_category;
@synthesize court_class = _court_class;
@synthesize court_short_name = _court_short_name;
@synthesize courtroom_base = _courtroom_base;
@synthesize id = _id;
@synthesize introduce = _introduce;
@synthesize is_audit = _is_audit;
@synthesize is_certification = _is_certification;
@synthesize is_collection = _is_collection;
@synthesize is_delete = _is_delete;
@synthesize name = _name;
@synthesize parent_id = _parent_id;
@synthesize phone = _phone;
@synthesize photo = _photo;
@synthesize province = _province;
@synthesize zipcode = _zipcode;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(area_id, @"");
		DTAPI_DICT_ASSIGN_STRING(city, @"");
		DTAPI_DICT_ASSIGN_STRING(court_category, @"");
		DTAPI_DICT_ASSIGN_STRING(court_class, @"");
		DTAPI_DICT_ASSIGN_STRING(court_short_name, @"");
		self.courtroom_base = [DTApiBaseBean arrayForKey:@"courtroom_base" inDictionary:dict withClass:[Courtroom_base class]];
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(introduce, @"");
		DTAPI_DICT_ASSIGN_STRING(is_audit, @"");
		DTAPI_DICT_ASSIGN_STRING(is_certification, @"");
		DTAPI_DICT_ASSIGN_NUMBER(is_collection, @"0");
		DTAPI_DICT_ASSIGN_STRING(is_delete, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(parent_id, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(photo, @"");
		DTAPI_DICT_ASSIGN_STRING(province, @"");
		DTAPI_DICT_ASSIGN_STRING(zipcode, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(area_id);
	DTAPI_DICT_EXPORT_BASICTYPE(city);
	DTAPI_DICT_EXPORT_BASICTYPE(court_category);
	DTAPI_DICT_EXPORT_BASICTYPE(court_class);
	DTAPI_DICT_EXPORT_BASICTYPE(court_short_name);
	DTAPI_DICT_EXPORT_ARRAY_BEAN(courtroom_base);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(introduce);
	DTAPI_DICT_EXPORT_BASICTYPE(is_audit);
	DTAPI_DICT_EXPORT_BASICTYPE(is_certification);
	DTAPI_DICT_EXPORT_BASICTYPE(is_collection);
	DTAPI_DICT_EXPORT_BASICTYPE(is_delete);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(parent_id);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(photo);
	DTAPI_DICT_EXPORT_BASICTYPE(province);
	DTAPI_DICT_EXPORT_BASICTYPE(zipcode);
    return md;
}
@end
