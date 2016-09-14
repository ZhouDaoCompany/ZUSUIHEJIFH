//
//  data_1.m
//  周道
//
//  Created by _author on 16-05-06.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "GovClassModel.h"
#import "DTApiBaseBean.h"


@implementation GovClassModel

@synthesize ctname = _ctname;
@synthesize data = _data;
@synthesize id = _id;
@synthesize pid = _pid;
@synthesize sorting = _sorting;
@synthesize court_category = _court_category;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(ctname, @"");
		self.data = [DTApiBaseBean arrayForKey:@"data" inDictionary:dict withClass:[GovClassData class]];
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(pid, @"");
		DTAPI_DICT_ASSIGN_STRING(sorting, @"");
        DTAPI_DICT_ASSIGN_STRING(court_category, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(ctname);
	DTAPI_DICT_EXPORT_ARRAY_BEAN(data);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(pid);
	DTAPI_DICT_EXPORT_BASICTYPE(sorting);
    DTAPI_DICT_EXPORT_BASICTYPE(court_category);

    return md;
}
@end
