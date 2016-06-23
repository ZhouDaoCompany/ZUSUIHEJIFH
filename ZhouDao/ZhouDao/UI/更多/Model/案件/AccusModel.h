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
 *  非诉
 */

@interface AccusModel : NSObject
{
	NSString *_client;
	NSString *_client_address;
	NSString *_client_mail;
	NSString *_client_phone;
	NSString *_id;
	NSString *_name;
	NSString *_thyend_shape;
	NSString *_thyend_time;
	NSString *_thytake_time;
}


@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *client_address;
@property (nonatomic, copy) NSString *client_mail;
@property (nonatomic, copy) NSString *client_phone;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *thyend_shape;
@property (nonatomic, copy) NSString *thyend_time;
@property (nonatomic, copy) NSString *thytake_time;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 