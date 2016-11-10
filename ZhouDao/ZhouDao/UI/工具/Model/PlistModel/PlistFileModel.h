//
//  file.h
//  周道
//
//  Created by _author on 16-11-10.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface PlistFileModel : NSObject
{
	NSString *_address;
	NSString *_name;
	NSString *_version;
}


@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 
