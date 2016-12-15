//
//  courtroom_linkman.h
//  周道
//
//  Created by _author on 16-12-15.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface Courtroom_linkman : NSObject
{
	NSString *_bid;
	NSString *_id;
	NSString *_name;
	NSString *_phone;
	NSString *_type;
}


@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
