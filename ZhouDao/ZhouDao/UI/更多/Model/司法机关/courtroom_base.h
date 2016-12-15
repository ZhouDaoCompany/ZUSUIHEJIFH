//
//  courtroom_base.h
//  周道
//
//  Created by _author on 16-12-15.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
@class Courtroom_linkman;


@interface Courtroom_base : NSObject
{
	NSString *_address;
	NSMutableArray *_courtroom_linkman;
	NSString *_id;
	NSString *_jid;
	NSString *_name;
	NSString *_open;
	NSString *_pic;
	NSString *_uid;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, retain) NSMutableArray *courtroom_linkman;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *open;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isFlag;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
