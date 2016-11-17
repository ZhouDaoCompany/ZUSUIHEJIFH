//
//  UploadMorephontosVC.h
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SourceType) {
    
    CameraType = 0, //相机
    PhotoLibraryType =1, //相册
};

@interface UploadMorephontosVC : BaseViewController

@property (nonatomic, strong) NSArray *assetArrays;//照片数组
@property (nonatomic, copy) NSString *caseId;//案件唯一id  cid
@property (nonatomic, copy) ZDBlock reloadBlock;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, assign) SourceType sourceType;//图片来源

- (instancetype)initWithSourceType:(SourceType)type
                           withPid:(NSString *)pid
                        withCaseId:(NSString *)caseId
                   withAssetArrays:(NSArray *)assetArrays;
@end
