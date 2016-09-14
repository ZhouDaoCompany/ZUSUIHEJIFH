//
//  _root_.m
//  NewProject
//
//  Created by _author on 16-04-25.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "UserModel.h"
#import "DTApiBaseBean.h"


@implementation UserModel

@synthesize data = _data;
@synthesize info = _info;
@synthesize state = _state;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		self.data = [DTApiBaseBean objectForKey:@"data" inDictionary:dict withClass:[UserData class]];
		DTAPI_DICT_ASSIGN_STRING(info, @"");
		DTAPI_DICT_ASSIGN_NUMBER(state, @"0");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BEAN(data);
	DTAPI_DICT_EXPORT_BASICTYPE(info);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
    return md;
}
@end
