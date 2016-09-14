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


@interface TemplateData : NSObject
{
	NSString *_cid;
	NSString *_content;
	NSString *_describe;
	NSString *_download;
	NSString *_id;
	NSNumber *_is_collection;
	NSString *_is_common;
	NSString *_is_recommend;
	NSString *_is_show;
	NSString *_keywords;
	NSString *_posttime;
	NSString *_scid;
	NSString *_title;
	NSString *_view;
}


@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSNumber *is_collection;
@property (nonatomic, copy) NSString *is_common;
@property (nonatomic, copy) NSString *is_recommend;
@property (nonatomic, copy) NSString *is_show;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *posttime;
@property (nonatomic, copy) NSString *scid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *view;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 