//
//  AllProportionModel.h
//  ZhouDao
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"

@interface AllProportionModel : NSObject


@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *con;
@property (nonatomic, copy) NSString *conMax;
@property (nonatomic, copy) NSString *conMin;

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;

@end
