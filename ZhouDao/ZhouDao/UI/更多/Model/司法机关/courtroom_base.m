//
//  courtroom_base.m
//  周道
//
//  Created by _author on 16-12-15.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "Courtroom_base.h"
#import "DTApiBaseBean.h"
#import "Courtroom_linkman.h"


@implementation Courtroom_base

@synthesize address = _address;
@synthesize courtroom_linkman = _courtroom_linkman;
@synthesize id = _id;
@synthesize jid = _jid;
@synthesize name = _name;
@synthesize open = _open;
@synthesize pic = _pic;
@synthesize uid = _uid;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		self.courtroom_linkman = [DTApiBaseBean arrayForKey:@"courtroom_linkman" inDictionary:dict withClass:[Courtroom_linkman class]];
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(jid, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(open, @"");
		DTAPI_DICT_ASSIGN_STRING(pic, @"");
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
        self.isFlag = NO;
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_ARRAY_BEAN(courtroom_linkman);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(jid);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(open);
	DTAPI_DICT_EXPORT_BASICTYPE(pic);
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    return md;
}
@end
