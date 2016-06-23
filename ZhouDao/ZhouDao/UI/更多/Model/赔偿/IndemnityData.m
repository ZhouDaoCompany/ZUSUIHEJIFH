//
//  data.m
//  周道
//
//  Created by _author on 16-05-10.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "IndemnityData.h"
#import "DTApiBaseBean.h"


@implementation IndemnityData

@synthesize content = _content;
@synthesize id = _id;
@synthesize is_collection = _is_collection;
@synthesize is_recommend = _is_recommend;
@synthesize posttime = _posttime;
@synthesize provinces = _provinces;
@synthesize sorting = _sorting;
@synthesize title = _title;
@synthesize type = _type;
@synthesize view = _view;
@synthesize year = _year;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_NUMBER(is_collection, @"0");
		DTAPI_DICT_ASSIGN_STRING(is_recommend, @"");
		DTAPI_DICT_ASSIGN_STRING(posttime, @"");
		DTAPI_DICT_ASSIGN_STRING(provinces, @"");
		DTAPI_DICT_ASSIGN_STRING(sorting, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(view, @"");
		DTAPI_DICT_ASSIGN_STRING(year, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_collection);
	DTAPI_DICT_EXPORT_BASICTYPE(is_recommend);
	DTAPI_DICT_EXPORT_BASICTYPE(posttime);
	DTAPI_DICT_EXPORT_BASICTYPE(provinces);
	DTAPI_DICT_EXPORT_BASICTYPE(sorting);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(view);
	DTAPI_DICT_EXPORT_BASICTYPE(year);
    return md;
}
@end
