//
//  data.h
//  周道
//
//  Created by _author on 16-05-16.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface ManagerData : NSObject
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
}


@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *case_id;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 