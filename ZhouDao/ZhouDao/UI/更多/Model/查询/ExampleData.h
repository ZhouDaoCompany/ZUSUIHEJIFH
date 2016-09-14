//
//  data.h
//  周道
//
//  Created by _author on 16-05-11.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface ExampleData : NSObject<NSCoding>
{
	NSString *_id;
	NSString *_name;
	NSString *_nozzle_id;
	NSString *_pic;
	NSString *_pid;
}


@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nozzle_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pid;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 