//
//  data.h
//  周道
//
//  Created by _author on 16-07-01.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface LayerFeesModel : NSObject
{
	NSString *_content;
	NSString *_id;
	NSString *_pic;
	NSString *_source;
	NSString *_title;
	NSString *_viewtime;
}


@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *viewtime;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 