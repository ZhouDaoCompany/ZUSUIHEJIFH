//
//  data.h
//  周道
//
//  Created by _author on 16-05-10.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface IndemnityData : NSObject
{
	NSString *_content;
	NSString *_id;
	NSNumber *_is_collection;
	NSString *_is_recommend;
	NSString *_posttime;
	NSString *_provinces;
	NSString *_sorting;
	NSString *_title;
	NSString *_type;
	NSString *_view;
	NSString *_year;
}


@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSNumber *is_collection;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *posttime;
@property (nonatomic, copy) NSString *provinces;
@property (nonatomic, copy) NSString *sorting;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *view;
@property (nonatomic, copy) NSString *year;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 