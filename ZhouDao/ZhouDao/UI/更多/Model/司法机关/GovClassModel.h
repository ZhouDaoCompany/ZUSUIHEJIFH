//
//  data_1.h
//  周道
//
//  Created by _author on 16-05-06.
//  Copyright (c) _companyname. All rights reserved.
//

/*
	
*/


#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"
#import "GovClassData.h"


@interface GovClassModel: NSObject
{
	NSString *_ctname;
	NSMutableArray *_data;
	NSString *_id;
	NSString *_pid;
	NSString *_sorting;
    NSString *_court_category;
}

@property (nonatomic, copy) NSString *ctname;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sorting;
@property (nonatomic, copy) NSString *court_category;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 