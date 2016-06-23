//
//  CasesDirectoryVC.h
//  ZhouDao
//
//  Created by cqz on 16/5/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CasesDirectoryVC : BaseViewController
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *caseId;
@property (nonatomic, strong) NSString *pid;//父级ID
@property (nonatomic, copy)   NSString *filePath;//文件路径
@end
