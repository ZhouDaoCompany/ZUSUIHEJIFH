//
//  ContentViewController.h
//  ZhouDao
//
//  Created by cqz on 16/3/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger,DetailType){
    lawsType = 0,//法规详情
    IndemnityType = 1,//赔偿标准详情
    CaseType = 2,//案例
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskModel.h"

@interface ContentViewController : BaseViewController

/*
 请求端口
 */
@property (nonatomic, copy) NSString  *url;
@property (nonatomic, strong) TaskModel *model;
//@property (nonatomic, copy) NSString *titleStr;
//@property (nonatomic, copy) NSString  *idString;//文章ID
@property (assign, nonatomic) DetailType dType;//类型
@end
