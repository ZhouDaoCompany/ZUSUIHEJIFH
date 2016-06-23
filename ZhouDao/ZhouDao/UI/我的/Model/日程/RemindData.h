//
//  data.h
//  周道
//
//  Created by _author on 16-04-29.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface RemindData : NSObject
{
	NSString *_bell;
	NSString *_content;
	NSString *_id;
	NSString *_mode_type;
	NSString *_regtime;
	NSString *_repeat_time;
	NSString *_time;
	NSString *_title;
	NSString *_uid;
}


@property (nonatomic, copy) NSString *bell;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mode_type;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *repeat_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *uid;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 