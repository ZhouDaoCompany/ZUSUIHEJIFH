//
//  detailed.h
//  周道
//
//  Created by _author on 16-05-17.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
/**
 *  诉讼业务
 */

@interface LitigationModel : NSObject
{
	NSString *_apply_execute_time;
	NSString *_court_time;
	NSString *_defendant;
	NSString *_execute_court;
	NSString *_execute_judge;
	NSString *_execute_phone;
	NSString *_firs_address;
	NSString *_firs_court;
	NSString *_firs_judge;
	NSString *_firs_phone;
	NSString *_firs_result;
	NSString *_id;
	NSString *_name;
	NSString *_plaintiff;
	NSString *_someoneelse;
	NSString *_thyend;
	NSString *_thyend_time;
	NSString *_thytake;
	NSString *_thytake_time;
	NSString *_two_address;
	NSString *_two_court;
	NSString *_two_judge;
	NSString *_two_phone;
	NSString *_two_result;
}


@property (nonatomic, copy) NSString *apply_execute_time;
@property (nonatomic, copy) NSString *court_time;
@property (nonatomic, copy) NSString *defendant;
@property (nonatomic, copy) NSString *execute_court;
@property (nonatomic, copy) NSString *execute_judge;
@property (nonatomic, copy) NSString *execute_phone;
@property (nonatomic, copy) NSString *firs_address;
@property (nonatomic, copy) NSString *firs_court;
@property (nonatomic, copy) NSString *firs_judge;
@property (nonatomic, copy) NSString *firs_phone;
@property (nonatomic, copy) NSString *firs_result;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *plaintiff;
@property (nonatomic, copy) NSString *someoneelse;
@property (nonatomic, copy) NSString *thyend;
@property (nonatomic, copy) NSString *thyend_time;
@property (nonatomic, copy) NSString *thytake;
@property (nonatomic, copy) NSString *thytake_time;
@property (nonatomic, copy) NSString *two_address;
@property (nonatomic, copy) NSString *two_court;
@property (nonatomic, copy) NSString *two_judge;
@property (nonatomic, copy) NSString *two_phone;
@property (nonatomic, copy) NSString *two_result;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 