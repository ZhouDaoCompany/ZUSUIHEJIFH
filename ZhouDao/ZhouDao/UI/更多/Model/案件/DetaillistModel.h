//
//  data.h
//  周道
//
//  Created by _author on 16-05-19.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface DetaillistModel : NSObject
{
	NSString *_cid;
	NSString *_id;
	NSString *_name;
	NSString *_pid;
	NSString *_qiniu_name;
	NSString *_type_file;
	NSString *_type_format;
	NSString *_uid;
}


@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *qiniu_name;
@property (nonatomic, copy) NSString *type_file;
@property (nonatomic, copy) NSString *type_format;
@property (nonatomic, copy) NSString *uid;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 