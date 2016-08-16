//
//  TaskModel.h
//  ZhouDao
//
//  Created by cqz on 16/3/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property(nonatomic, copy)  NSString *name;
@property(nonatomic, copy)  NSString *url;
@property(nonatomic, copy)  NSString *destinationPath;

@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *is_collection;

+(instancetype)model;


@end
