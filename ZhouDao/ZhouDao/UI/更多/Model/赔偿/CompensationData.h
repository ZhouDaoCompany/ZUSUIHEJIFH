//
//  data.h
//  周道
//
//  Created by _author on 16-05-05.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface CompensationData : NSObject
{
	NSString *_city;
	NSString *_id;
	NSString *_posttime;
	NSString *_title;
}


@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *posttime;
@property (nonatomic, copy) NSString *title;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 