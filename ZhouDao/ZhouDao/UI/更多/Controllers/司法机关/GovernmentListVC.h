//
//  GovernmentListVC.h
//  ZhouDao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

typedef void(^LocalStringBlock)(NSString *prov, NSString *local);
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface GovernmentListVC : BaseViewController

@property (nonatomic, copy) NSString *nameString;
@property (nonatomic, copy) NSString *prov;//定位省
@property (nonatomic, copy) NSString *showLocal;
@property (nonatomic, copy) LocalStringBlock localBlock;
@end
