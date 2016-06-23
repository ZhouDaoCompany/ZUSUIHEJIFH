//
//  Provice.m
//  ZhouDao
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "Provice.h"

@implementation Provice
- (id)initWithaDic:(NSDictionary *)aDic{
    if (self == [super init]) {
        self.idString = [NSString stringWithFormat:@"%@",aDic[@"id"]];
        self.pid = [NSString stringWithFormat:@"%@",aDic[@"pid"]];
        self.name = [NSString stringWithFormat:@"%@",aDic[@"name"]];
        self.type = [NSString stringWithFormat:@"%@",aDic[@"type"]];
        self.py = [NSString stringWithFormat:@"%@",aDic[@"py"]];
       
    }
    return self;
}

@end
