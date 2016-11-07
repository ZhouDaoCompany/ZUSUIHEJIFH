//
//  ProvinceModel.m
//  AlertWindow
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "ProvinceModel.h"
#import "CityModel.h"

@implementation ProvinceModel

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(name, @"");
        self.city = [DTApiBaseBean arrayForKey:@"city" inDictionary:dict withClass:[CityModel class]];
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(id);
    DTAPI_DICT_EXPORT_BASICTYPE(name);
    DTAPI_DICT_EXPORT_ARRAY_BEAN(city);

    return md;
}

@end
