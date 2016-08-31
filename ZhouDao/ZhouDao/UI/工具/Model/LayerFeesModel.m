//
//  data.m
//  周道
//
//  Created by _author on 16-07-01.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "LayerFeesModel.h"
#import "DTApiBaseBean.h"


@implementation LayerFeesModel

@synthesize content = _content;
@synthesize id = _id;
@synthesize pic = _pic;
@synthesize source = _source;
@synthesize title = _title;
@synthesize viewtime = _viewtime;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(pic, @"");
		DTAPI_DICT_ASSIGN_STRING(source, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(viewtime, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(pic);
	DTAPI_DICT_EXPORT_BASICTYPE(source);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(viewtime);
    return md;
}
@end
