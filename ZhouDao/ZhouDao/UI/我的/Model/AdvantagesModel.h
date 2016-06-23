//
//  房地产.h
//  zd
//
//  Created by _author on 16-03-18.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"


@interface AdvantagesModel : NSObject
{
	NSString *_cname;
	NSString *_cnameid;
	NSString *_id;
	NSString *_sname;
	NSString *_sorting;
}


@property (nonatomic, copy) NSString *cname;
@property (nonatomic, copy) NSString *cnameid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sname;
@property (nonatomic, copy) NSString *sorting;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 