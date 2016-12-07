//
//  ProvinceModel.h
//  AlertWindow
//
//  Created by apple on 16/11/7.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"

@interface ProvinceModel : NSObject


@property (nonatomic, strong) NSMutableArray *city;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;



-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;

@end
