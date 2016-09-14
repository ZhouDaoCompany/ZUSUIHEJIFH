//
//  _root_.h
//  周道
//
//  Created by _author on 16-04-29.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
#import "RemindData.h"


@interface RemindModel : NSObject
{
	NSMutableArray *_data;
	NSString *_info;
	NSNumber *_state;
}


@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSNumber *state;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 