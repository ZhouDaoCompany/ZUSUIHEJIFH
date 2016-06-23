//
//  DownLoadView.h
//  ZhouDao
//
//  Created by cqz on 16/3/25.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"

@protocol DownLoadViewPro <NSObject>

- (void)getDownloadState:(NSString *)downStr readPath:(NSString *)path;

@end

@interface DownLoadView : UIView

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) TaskModel *model;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, weak) id<DownLoadViewPro>delegate;
@end
