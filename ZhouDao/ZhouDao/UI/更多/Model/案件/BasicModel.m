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


@synthesize number = _number;
@synthesize client_phone = _client_phone;
@synthesize client_mail = _client_mail;
@synthesize client_address = _client_address;
@synthesize plaintiff = _plaintiff;
@synthesize defendant = _defendant;
@synthesize someoneelse = _someoneelse;
@synthesize client = _client;
@synthesize thytake_time = _thytake_time;

@synthesize remarks = _remarks;
@synthesize thyend_time = _thyend_time;

@synthesize contacts = _contacts;
@synthesize mail = _mail;
@synthesize phone = _phone;
@synthesize sign_endtime = _sign_endtime;
@synthesize sign_time = _sign_time;


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
        
        DTAPI_DICT_ASSIGN_STRING(number, @"");
        DTAPI_DICT_ASSIGN_STRING(client_phone, @"");
        DTAPI_DICT_ASSIGN_STRING(client_mail, @"");
        DTAPI_DICT_ASSIGN_STRING(client_address, @"");
        DTAPI_DICT_ASSIGN_STRING(plaintiff, @"");
        DTAPI_DICT_ASSIGN_STRING(defendant, @"");
        DTAPI_DICT_ASSIGN_STRING(someoneelse, @"");
        DTAPI_DICT_ASSIGN_STRING(client, @"");
        DTAPI_DICT_ASSIGN_STRING(thytake_time, @"");
        DTAPI_DICT_ASSIGN_STRING(client, @"");
        DTAPI_DICT_ASSIGN_STRING(thytake_time, @"");

        DTAPI_DICT_ASSIGN_STRING(remarks, @"");
        DTAPI_DICT_ASSIGN_STRING(thyend_time, @"");
        
        DTAPI_DICT_ASSIGN_STRING(contacts, @"");
        DTAPI_DICT_ASSIGN_STRING(mail, @"");
        DTAPI_DICT_ASSIGN_STRING(phone, @"");
        DTAPI_DICT_ASSIGN_STRING(sign_time, @"");
        DTAPI_DICT_ASSIGN_STRING(sign_endtime, @"");

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
    DTAPI_DICT_EXPORT_BASICTYPE(client);
    DTAPI_DICT_EXPORT_BASICTYPE(thytake_time);


    DTAPI_DICT_EXPORT_BASICTYPE(remarks);
    DTAPI_DICT_EXPORT_BASICTYPE(thyend_time);

    
    DTAPI_DICT_EXPORT_BASICTYPE(contacts);
    DTAPI_DICT_EXPORT_BASICTYPE(mail);
    DTAPI_DICT_EXPORT_BASICTYPE(phone);
    DTAPI_DICT_EXPORT_BASICTYPE(sign_time);
    DTAPI_DICT_EXPORT_BASICTYPE(sign_endtime);
    
    DTAPI_DICT_EXPORT_BASICTYPE(number);
    DTAPI_DICT_EXPORT_BASICTYPE(client_phone);
    DTAPI_DICT_EXPORT_BASICTYPE(client_mail);
    DTAPI_DICT_EXPORT_BASICTYPE(client_address);
    DTAPI_DICT_EXPORT_BASICTYPE(plaintiff);
    DTAPI_DICT_EXPORT_BASICTYPE(defendant);
    DTAPI_DICT_EXPORT_BASICTYPE(someoneelse);

    return md;
}
WZLSERIALIZE_CODER_DECODER();

@end
