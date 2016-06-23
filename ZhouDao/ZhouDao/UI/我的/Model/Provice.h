//
//  Provice.h
//  ZhouDao
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Provice : NSObject

@property (nonatomic ,copy)NSString *idString;
@property (nonatomic ,copy)NSString *pid;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *type;
@property (nonatomic ,copy)NSString *py;

- (id)initWithaDic:(NSDictionary *)aDic;
@end
