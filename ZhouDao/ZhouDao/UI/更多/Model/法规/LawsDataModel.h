//
//  data.h
//  周道
//
//  Created by _author on 16-05-09.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface LawsDataModel : NSObject<NSCoding>
{
	NSString *_creater;
	NSString *_effect_level;
	NSString *_effect_level_no;
	NSString *_enact_date;
	NSString *_enacted_by;
	NSString *_execute_date;
	NSString *_id;
	NSString *_is_common;
	NSString *_is_delete;
	NSString *_is_new;
	NSString *_modify_time;
	NSString *_modifyer;
	NSString *_name;
	NSString *_orderNo;
	NSString *_ref_no;
	NSString *_status;
	NSString *_sync_time;
	NSString *_time_limited;
}


@property (nonatomic, copy) NSString *creater;
@property (nonatomic, copy) NSString *effect_level;
@property (nonatomic, copy) NSString *effect_level_no;
@property (nonatomic, copy) NSString *enact_date;
@property (nonatomic, copy) NSString *enacted_by;
@property (nonatomic, copy) NSString *execute_date;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_common;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *is_new;
@property (nonatomic, copy) NSString *modify_time;
@property (nonatomic, copy) NSString *modifyer;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *ref_no;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *sync_time;
@property (nonatomic, copy) NSString *time_limited;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 