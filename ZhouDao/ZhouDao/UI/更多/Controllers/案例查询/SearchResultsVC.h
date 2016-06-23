//
//  SearchResultsVC.h
//  ZhouDao
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef  NS_ENUM(NSUInteger,SearResultType){
    EgType = 0,//案例
    lawResulttype = 1,//法规
};
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchResultsVC : BaseViewController

@property (nonatomic, assign) SearResultType resultType;
@property (nonatomic, strong) NSArray *arrays;
@property (nonatomic, copy) NSString *keyStr;

@end
