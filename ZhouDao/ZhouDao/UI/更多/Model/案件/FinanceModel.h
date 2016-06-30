//
//  data.h
//  周道
//
//  Created by _author on 16-06-30.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface FinanceModel : NSObject
{
	NSString *_aid;
	NSString *_content;
	NSString *_id;
	NSString *_state;
	NSString *_title;
	NSString *_type;
	NSString *_uid;
}


@property (nonatomic, copy) NSString *aid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isExpanded;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 