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


@interface CaseModel : NSObject
{
	NSString *_id;
	NSString *_title;
}


@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 