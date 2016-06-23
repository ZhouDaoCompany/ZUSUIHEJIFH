//
//  data.h
//  NewProject
//
//  Created by _author on 16-04-25.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface UserData : NSObject
{
	NSString *_is_certification;
	NSString *_mobile;
	NSString *_photo;
	NSString *_type;
	NSString *_uid;
    NSString *_name;
    NSString *_address;
}


@property (nonatomic, copy) NSString *is_certification;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 