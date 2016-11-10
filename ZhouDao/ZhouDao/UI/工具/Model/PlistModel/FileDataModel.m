//
//  data.m
//  周道
//
//  Created by _author on 16-11-10.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "FileDataModel.h"
#import "DTApiBaseBean.h"
#import "PlistFileModel.h"


@implementation FileDataModel

@synthesize file = _file;
@synthesize txt = _txt;

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		self.file = [DTApiBaseBean arrayForKey:@"file" inDictionary:dict withClass:[PlistFileModel class]];
		DTAPI_DICT_ASSIGN_STRING(txt, @"");
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_ARRAY_BEAN(file);
	DTAPI_DICT_EXPORT_BASICTYPE(txt);
    return md;
}
@end
