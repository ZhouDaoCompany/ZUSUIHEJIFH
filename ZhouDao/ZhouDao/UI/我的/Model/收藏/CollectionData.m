//
//  data.m
//  周道
//
//  Created by _author on 16-05-12.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "CollectionData.h"
#import "DTApiBaseBean.h"


@implementation CollectionData

@synthesize article_id = _article_id;
@synthesize article_subtitle = _article_subtitle;
@synthesize article_time = _article_time;
@synthesize article_title = _article_title;
@synthesize id = _id;
@synthesize is_top = _is_top;
@synthesize top_time = _top_time;
@synthesize type = _type;
@synthesize uid = _uid;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(article_id, @"");
		DTAPI_DICT_ASSIGN_STRING(article_subtitle, @"");
		DTAPI_DICT_ASSIGN_STRING(article_time, @"");
		DTAPI_DICT_ASSIGN_STRING(article_title, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(is_top, @"");
		DTAPI_DICT_ASSIGN_STRING(top_time, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(article_id);
	DTAPI_DICT_EXPORT_BASICTYPE(article_subtitle);
	DTAPI_DICT_EXPORT_BASICTYPE(article_time);
	DTAPI_DICT_EXPORT_BASICTYPE(article_title);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_top);
	DTAPI_DICT_EXPORT_BASICTYPE(top_time);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    return md;
}
@end
