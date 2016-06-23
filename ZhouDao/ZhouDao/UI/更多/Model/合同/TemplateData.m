//
//  data.m
//  周道
//
//  Created by _author on 16-05-04.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "TemplateData.h"
#import "DTApiBaseBean.h"


@implementation TemplateData

@synthesize cid = _cid;
@synthesize content = _content;
@synthesize describe = _describe;
@synthesize download = _download;
@synthesize id = _id;
@synthesize is_collection = _is_collection;
@synthesize is_common = _is_common;
@synthesize is_recommend = _is_recommend;
@synthesize is_show = _is_show;
@synthesize keywords = _keywords;
@synthesize posttime = _posttime;
@synthesize scid = _scid;
@synthesize title = _title;
@synthesize view = _view;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(cid, @"");
		DTAPI_DICT_ASSIGN_STRING(content, @"");
		DTAPI_DICT_ASSIGN_STRING(describe, @"");
		DTAPI_DICT_ASSIGN_STRING(download, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_NUMBER(is_collection, @"0");
		DTAPI_DICT_ASSIGN_STRING(is_common, @"");
		DTAPI_DICT_ASSIGN_STRING(is_recommend, @"");
		DTAPI_DICT_ASSIGN_STRING(is_show, @"");
		DTAPI_DICT_ASSIGN_STRING(keywords, @"");
		DTAPI_DICT_ASSIGN_STRING(posttime, @"");
		DTAPI_DICT_ASSIGN_STRING(scid, @"");
		DTAPI_DICT_ASSIGN_STRING(title, @"");
		DTAPI_DICT_ASSIGN_STRING(view, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(cid);
	DTAPI_DICT_EXPORT_BASICTYPE(content);
	DTAPI_DICT_EXPORT_BASICTYPE(describe);
	DTAPI_DICT_EXPORT_BASICTYPE(download);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(is_collection);
	DTAPI_DICT_EXPORT_BASICTYPE(is_common);
	DTAPI_DICT_EXPORT_BASICTYPE(is_recommend);
	DTAPI_DICT_EXPORT_BASICTYPE(is_show);
	DTAPI_DICT_EXPORT_BASICTYPE(keywords);
	DTAPI_DICT_EXPORT_BASICTYPE(posttime);
	DTAPI_DICT_EXPORT_BASICTYPE(scid);
	DTAPI_DICT_EXPORT_BASICTYPE(title);
	DTAPI_DICT_EXPORT_BASICTYPE(view);
    return md;
}
@end
