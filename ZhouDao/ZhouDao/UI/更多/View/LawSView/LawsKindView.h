//
//  LawsKindView.h
//  ZhouDao
//
//  Created by cqz on 16/3/30.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LawsKindType)
{
    HomeFrom  =0 ,//首页
    LawsFrom  =1 , // 法规
};

@interface LawsKindView : UIView
{
    UIImageView *imgView;
    UILabel *titleLab;
    
}

@property (nonatomic, assign) LawsKindType type;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic, copy) ZDIndexBlock indexBlock;

-(void)setImgViewImageName:(NSString *)imageName WithLabelText:(NSString *)text;

@end
