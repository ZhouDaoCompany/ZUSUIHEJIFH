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
 