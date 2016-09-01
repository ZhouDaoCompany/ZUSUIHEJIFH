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

@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *stage;

@property (nonatomic, strong) NSMutableArray *allMoney;//价格
@property (nonatomic, strong) NSMutableArray *allPer;//比例
@property (nonatomic, strong) NSMutableArray *allPerMoney;//比例价格(按照价格乘以比例运算)
//@property (nonatomic, copy)   NSString *text;//地区说明
//@property (nonatomic, copy)   NSString *isInterval;//是否是区间百分比 1不是 2是

-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;
@end
 