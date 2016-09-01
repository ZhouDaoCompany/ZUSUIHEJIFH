//
//  data.m
//  周道
//
//  Created by _author on 16-07-01.
//  Copyright (c) _companyname. All rights reserved.
//  

/*
	
*/


#import "LayerFeesModel.h"
#import "DTApiBaseBean.h"
#import "AllProportionModel.h"


@implementation LayerFeesModel


-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(type, @"");
        DTAPI_DICT_ASSIGN_STRING(stage, @"");

        DTAPI_DICT_ASSIGN_ARRAY_BASICTYPE(allMoney);
        DTAPI_DICT_ASSIGN_ARRAY_BASICTYPE(allPerMoney);
//        DTAPI_DICT_ASSIGN_ARRAY_BASICTYPE(allPer);

        self.allPer = [DTApiBaseBean arrayForKey:@"allPer" inDictionary:dict withClass:[AllProportionModel class]];
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(type);
    DTAPI_DICT_EXPORT_BASICTYPE(stage);

    DTAPI_DICT_EXPORT_ARRAY_BEAN(allMoney);
    DTAPI_DICT_EXPORT_ARRAY_BEAN(allPerMoney);
    DTAPI_DICT_EXPORT_BASICTYPE(allPer);

    return md;
}
@end
