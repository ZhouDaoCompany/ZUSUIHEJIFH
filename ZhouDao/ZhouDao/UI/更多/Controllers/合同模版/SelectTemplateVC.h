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

@interface SelectTemplateVC : BaseViewController
@property (nonatomic, strong) NSMutableArray *firstArrays;//合同大分类
@property (nonatomic, strong) NSMutableArray *cidArrays;//一级分类id
@property (nonatomic, copy) NSString *cidString;//一级id
@property (nonatomic, strong)  TheContractData *model;

@property (nonatomic, copy) NSString *imageUrl;//图片链接
@end
