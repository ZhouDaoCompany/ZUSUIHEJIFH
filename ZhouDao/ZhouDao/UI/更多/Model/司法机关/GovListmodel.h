//
//  data.h
//  周道
//
//  Created by _author on 16-05-06.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface GovListmodel : NSObject<NSCoding>
{
	NSString *_address;
	NSString *_area_id;
	NSString *_city;
	NSString *_court_category;
	NSString *_court_class;
	NSString *_court_short_name;
	NSString *_id;
	NSString *_introduce;
	NSString *_is_certification;
	NSString *_is_delete;
	NSString *_is_sync;
	NSString *_name;
	NSString *_parent_id;
	NSString *_phone;
	NSString *_photo;
	NSString *_province;
	NSString *_sync_time;
	NSString *_zipcode;
    NSNumber *_is_collection;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *area_id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *court_category;
@property (nonatomic, copy) NSString *court_class;
@property (nonatomic, copy) NSString *court_short_name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *is_certification;
@property (nonatomic, copy) NSString *is_delete;
@property (nonatomic, copy) NSString *is_sync;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *sync_time;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSNumber *is_collection;
-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 