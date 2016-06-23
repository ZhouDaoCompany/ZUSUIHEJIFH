//
//  ExampleListVC.h
//  ZhouDao
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger, ExampleType){
    FromSearchtype = 0,
    FromComType = 1,
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ExampleListVC : BaseViewController

@property (nonatomic, copy) NSString *titString;
@property (nonatomic, copy) NSString *idString;
@property (nonatomic, copy) NSString *searText;
@property (nonatomic, assign) ExampleType exampleType;
@property (nonatomic, strong) NSArray *searArr;
@end
