//
//  SelectTemplateVC.h
//  ZhouDao
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TheContractData.h"

typedef NS_ENUM(NSInteger, TemplateType) {
    
    GeneralSelectType = 0, //正常选择
    TemplateSearchType = 1, //合同搜索
};

@interface SelectTemplateVC : BaseViewController
@property (nonatomic, strong) NSMutableArray *firstArrays;//合同大分类
@property (nonatomic, strong) NSMutableArray *cidArrays;//一级分类id
@property (nonatomic, copy)   NSString *cidString;//一级id
@property (nonatomic, strong) TheContractData *model;
@property (nonatomic, assign) TemplateType temType;//显示模版类型
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//列表数据源

- (instancetype)initWithFirstArrays:(NSMutableArray *)firstArrays
                      withCidArrays:(NSMutableArray *)idArrays
                withTheContractData:(TheContractData *)model
                   withTemplateType:(TemplateType)temType;
@end
