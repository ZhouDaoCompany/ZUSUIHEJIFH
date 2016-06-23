//
//  _root_.h
//  NewProject
//
//  Created by _author on 16-04-25.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
#import "UserData.h"


@interface UserModel : NSObject
{
	UserData *_data;
	NSString *_info;
	NSNumber *_state;
}


@property (nonatomic, retain) UserData *data;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSNumber *state;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 