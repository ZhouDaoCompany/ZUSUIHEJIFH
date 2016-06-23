//
//  data.m
//  周道
//
//  Created by _author on 16-05-11.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/

#import "CaseModel.h"
#import "DTApiBaseBean.h"


@implementation CaseModel

@synthesize id = _id;
@synthesize title = _title;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
    return md;
}
@end
