//
//  data.m
//  NewProject
//
//  Created by _author on 16-04-25.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "UserData.h"
#import "DTApiBaseBean.h"


@implementation UserData

@synthesize is_certification = _is_certification;
@synthesize mobile = _mobile;
@synthesize photo = _photo;
@synthesize type = _type;
@synthesize uid = _uid;
@synthesize name = _name;
@synthesize address = _address;
@synthesize qq_au = _qq_au;
@synthesize wb_au = _wb_au;
@synthesize wx_au = _wx_au;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(is_certification, @"");
		DTAPI_DICT_ASSIGN_STRING(mobile, @"");
		DTAPI_DICT_ASSIGN_STRING(photo, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
        DTAPI_DICT_ASSIGN_STRING(name, @"");
        DTAPI_DICT_ASSIGN_STRING(address, @"");
        DTAPI_DICT_ASSIGN_STRING(qq_au, @"");
        DTAPI_DICT_ASSIGN_STRING(wb_au, @"");
        DTAPI_DICT_ASSIGN_STRING(wx_au, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
	DTAPI_DICT_EXPORT_BASICTYPE(is_certification);
	DTAPI_DICT_EXPORT_BASICTYPE(mobile);
	DTAPI_DICT_EXPORT_BASICTYPE(photo);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    DTAPI_DICT_EXPORT_BASICTYPE(name);
    DTAPI_DICT_EXPORT_BASICTYPE(address);
    DTAPI_DICT_EXPORT_BASICTYPE(qq_au);
    DTAPI_DICT_EXPORT_BASICTYPE(wb_au);
    DTAPI_DICT_EXPORT_BASICTYPE(wx_au);

    return md;
}
@end
