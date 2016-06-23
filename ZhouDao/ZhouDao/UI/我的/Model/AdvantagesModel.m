//
//  房地产.m
//  zd
//
//  Created by _author on 16-03-18.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "AdvantagesModel.h"
#import "DTApiBaseBean.h"


@implementation AdvantagesModel

@synthesize cname = _cname;
@synthesize cnameid = _cnameid;
@synthesize id = _id;
@synthesize sname = _sname;
@synthesize sorting = _sorting;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(cname, @"");
		DTAPI_DICT_ASSIGN_STRING(cnameid, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(sname, @"");
		DTAPI_DICT_ASSIGN_STRING(sorting, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(cname);
	DTAPI_DICT_EXPORT_BASICTYPE(cnameid);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(sname);
	DTAPI_DICT_EXPORT_BASICTYPE(sorting);
    return md;
}
@end
