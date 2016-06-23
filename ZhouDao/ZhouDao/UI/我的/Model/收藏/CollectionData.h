//
//  data.h
//  周道
//
//  Created by _author on 16-05-12.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface CollectionData : NSObject
{
	NSString *_article_id;
	NSString *_article_subtitle;
	NSString *_article_time;
	NSString *_article_title;
	NSString *_id;
	NSString *_is_top;
	NSString *_top_time;
	NSString *_type;
	NSString *_uid;
}


@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *article_subtitle;
@property (nonatomic, copy) NSString *article_time;
@property (nonatomic, copy) NSString *article_title;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *is_top;
@property (nonatomic, copy) NSString *top_time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 