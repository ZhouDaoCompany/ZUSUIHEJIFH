//
//  ReadViewController.h
//  ZhouDao
//
//  Created by cqz on 16/3/26.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger,ReadTYpe){
    
    FileExist = 0,
    FileNOExist = 1,
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskModel.h"

@interface ReadViewController : BaseViewController
@property (nonatomic, strong) TaskModel *model;
@property (nonatomic, copy) ZDStringBlock readBlock;
@property (nonatomic, assign) ReadTYpe rType;
@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *imageUrl;//图片链接
@end
