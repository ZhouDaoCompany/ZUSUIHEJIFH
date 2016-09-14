//
//  _root_.m
//  周道
//
//  Created by _author on 16-04-29.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "RemindModel.h"
#import "DTApiBaseBean.h"


@implementation RemindModel

@synthesize data = _data;
@synthesize info = _info;
@synthesize state = _state;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		self.data = [DTApiBaseBean arrayForKey:@"data" inDictionary:dict withClass:[RemindData class]];
		DTAPI_DICT_ASSIGN_STRING(info, @"");
		DTAPI_DICT_ASSIGN_NUMBER(state, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_ARRAY_BEAN(data);
	DTAPI_DICT_EXPORT_BASICTYPE(info);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
    return md;
}
@end
