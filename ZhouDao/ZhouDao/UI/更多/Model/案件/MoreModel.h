//
//  MoreModel.h
//  ZhouDao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTApiBaseBean.h"

@interface MoreModel : NSObject
{
    NSString *_id;
    NSString *_pid;
    NSString *_type;
    NSMutableArray *_content;
    NSString *_state;
}

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, copy) NSString *state;


-(id)initWithDictionary:(NSDictionary*)dict;
-(NSDictionary*)dictionaryValue;

@end
