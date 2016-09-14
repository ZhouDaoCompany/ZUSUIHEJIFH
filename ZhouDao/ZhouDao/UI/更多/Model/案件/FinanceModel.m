//
//  data.m
//  周道
//
//  Created by _author on 16-06-30.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "FinanceModel.h"
#import "DTApiBaseBean.h"


@implementation FinanceModel

@synthesize aid = _aid;
@synthesize content = _content;
@synthesize id = _id;
@synthesize state = _state;
@synthesize title = _title;
@synthesize type = _type;
@synthesize uid = _uid;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(aid, @"");
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(state, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
        self.isExpanded = NO;
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(aid);
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    return md;
}
@end
