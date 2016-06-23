//
//  data.h
//  周道
//
//  Created by _author on 16-05-04.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"

@interface TheContractData : NSObject<NSCoding>
{
	NSString *_ctname;
	NSString *_id;
	NSString *_pic;
	NSString *_pid;
	NSString *_sorting;
}

@property (nonatomic, copy) NSString *ctname;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sorting;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 