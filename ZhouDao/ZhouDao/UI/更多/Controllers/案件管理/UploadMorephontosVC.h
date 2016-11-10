//
//  UploadMorephontosVC.h
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UploadMorephontosVC : BaseViewController

@property (nonatomic, strong) NSArray *assetArrays;//照片数组
@property (nonatomic, copy) NSString *caseId;//案件唯一id  cid
@property (nonatomic, copy) ZDBlock reloadBlock;
@property (nonatomic, copy) NSString *pid;
@end
