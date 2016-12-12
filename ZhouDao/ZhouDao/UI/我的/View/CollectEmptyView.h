//
//  CollectEmptyView.h
//  ZhouDao
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectEmptyViewPro;

@interface CollectEmptyView : UIView

@property (nonatomic, weak) id<CollectEmptyViewPro>delegate;

- (id)initWithFrame:(CGRect)frame WithText:(NSString *)textStr;

- (instancetype)initTingShiTheDefaultWithDelegate:(id<CollectEmptyViewPro>)delegate;
@end

@protocol CollectEmptyViewPro <NSObject>

@optional
- (void)clickAddText;

@end
