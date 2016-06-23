//
//  detailed.h
//  周道
//
//  Created by _author on 16-05-16.
//  Copyright (c) _companyname. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
/**
 *  法律顾问
 */


@interface ConsultantModel : NSObject
{
	NSString *_address;
	NSString *_business;
	NSString *_client;
	NSString *_contacts;
	NSString *_deputy;
	NSString *_id;
	NSString *_is_remind;
	NSString *_mail;
	NSString *_partner;
	NSString *_phone;
	NSString *_sign_time;
	NSString *_sign_year;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *business;
@property (nonatomic, copy) NSString *client;
@property (nonatomic, copy) NSString *contacts;
@property (nonatomic, copy) NSString *deputy;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_remind;
@property (nonatomic, copy) NSString *mail;
@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sign_time;
@property (nonatomic, copy) NSString *sign_year;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 