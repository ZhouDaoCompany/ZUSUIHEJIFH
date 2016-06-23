//
//  basic.m
//  周道
//
//  Created by _author on 16-05-17.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "BasicModel.h"
#import "DTApiBaseBean.h"

#import <objc/runtime.h>
#import "WZLSerializeKit.h"

//是否使用通用的encode/decode代码一次性encode/decode
#define USING_ENCODE_KIT            1

@implementation BasicModel

@synthesize add_time = _add_time;
@synthesize case_id = _case_id;
@synthesize end_time = _end_time;
@synthesize id = _id;
@synthesize name = _name;
@synthesize start_time = _start_time;
@synthesize state = _state;
@synthesize type = _type;
@synthesize uid = _uid;
@synthesize title = _title;
@synthesize py = _py;
@synthesize app_icon = _app_icon;

@synthesize slide_id = _slide_id;
@synthesize slide_name = _slide_name;
@synthesize slide_pic = _slide_pic;
@synthesize slide_url = _slide_url;
@synthesize pic = _pic;
@synthesize content = _content;


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(add_time, @"");
		DTAPI_DICT_ASSIGN_STRING(case_id, @"");
		DTAPI_DICT_ASSIGN_STRING(end_time, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(start_time, @"");
		DTAPI_DICT_ASSIGN_STRING(state, @"");
		DTAPI_DICT_ASSIGN_STRING(type, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
        DTAPI_DICT_ASSIGN_STRING(title, @"");
        DTAPI_DICT_ASSIGN_STRING(py, @"");
        DTAPI_DICT_ASSIGN_STRING(app_icon, @"");
        
        DTAPI_DICT_ASSIGN_STRING(slide_id, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_name, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_pic, @"");
        DTAPI_DICT_ASSIGN_STRING(slide_url, @"");
        DTAPI_DICT_ASSIGN_STRING(pic, @"");
        DTAPI_DICT_ASSIGN_STRING(content, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(add_time);
	DTAPI_DICT_EXPORT_BASICTYPE(case_id);
	DTAPI_DICT_EXPORT_BASICTYPE(end_time);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(start_time);
	DTAPI_DICT_EXPORT_BASICTYPE(state);
	DTAPI_DICT_EXPORT_BASICTYPE(type);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    DTAPI_DICT_EXPORT_BASICTYPE(title);
    DTAPI_DICT_EXPORT_BASICTYPE(py);
    DTAPI_DICT_EXPORT_BASICTYPE(app_icon);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_id);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_name);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_pic);
    DTAPI_DICT_EXPORT_BASICTYPE(slide_url);
    DTAPI_DICT_EXPORT_BASICTYPE(pic);
    DTAPI_DICT_EXPORT_BASICTYPE(content);

    return md;
}
WZLSERIALIZE_CODER_DECODER();

@end
