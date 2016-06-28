//
//  basic.h
//  周道
//
//  Created by _author on 16-05-17.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface BasicModel : NSObject<NSCoding>
{
	NSString *_add_time;
	NSString *_case_id;
	NSString *_end_time;
	NSString *_id;
	NSString *_name;
	NSString *_start_time;
	NSString *_state;
	NSString *_type;
	NSString *_uid;
    
    //诉讼业务

    NSString *_number;
    NSString *_client_phone;
    NSString *_client_mail;
    NSString  *_client_address;
    NSString *_plaintiff;
    NSString *_defendant;
    NSString *_someoneelse;
    NSString *_client;
    NSString *_thytake_time;
    
    //非诉
    NSString *_remarks;
    NSString *_thyend_time;
    
    //法律顾问
    NSString *_contacts;
    NSString *_mail;
    NSString *_phone;
    NSString *_sign_endtime;
    NSString *_sign_time;

    NSString *_title;
    NSString *_py;
    NSString *_app_icon;
    
    //幻灯片 焦点图片
    NSString *_slide_id;
    NSString *_slide_name;
    NSString *_slide_pic;
    NSString *_slide_url;
    
    //实事热点
    NSString *_pic;
    NSString *_content;

}

@property (nonatomic, copy) NSString *slide_id;
@property (nonatomic, copy) NSString *slide_name;
@property (nonatomic, copy) NSString *slide_pic;
@property (nonatomic, copy) NSString *slide_url;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *content;

//诉讼
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *client_phone;
@property (nonatomic, copy) NSString *client_mail;
@property (nonatomic, copy) NSString *client_address;
@property (nonatomic, copy) NSString *plaintiff;
@property (nonatomic, copy) NSString *defendant;
@property (nonatomic, copy) NSString *someoneelse;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *thytake_time;

//非诉
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *thyend_time;

//法律顾问
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *mail;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sign_endtime;
@property (nonatomic, copy) NSString *sign_time;



@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *case_id;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *py;
@property (nonatomic, copy) NSString *app_icon;


-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 