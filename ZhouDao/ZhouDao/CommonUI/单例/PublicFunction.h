//
//  PublicFunction.h
//  ZhouDao
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface PublicFunction : NSObject

//是否登录
@property (nonatomic) BOOL m_bLogin;
//新版本第一次启动
@property (nonatomic) BOOL versionFirstTime;

@property (nonatomic, strong)UserModel *m_user;
@property (nonatomic, copy) NSString *picToken;
@property (nonatomic, copy) NSString *qiniuKey;
@property (nonatomic, assign) BOOL openApp;

//定位
@property (nonatomic, strong) NSString *locProv;
@property (nonatomic, strong) NSString *locCity;
@property (nonatomic, strong) NSString *locDistrict;
@property (nonatomic, strong) NSString *formatAddress;



+(PublicFunction *)ShareInstance;

/**
 *  应用是否第一次启动
 *
 *  @return YES:是第一次启动  NO:否
 */
- (BOOL)isFirstLaunch;

@end
