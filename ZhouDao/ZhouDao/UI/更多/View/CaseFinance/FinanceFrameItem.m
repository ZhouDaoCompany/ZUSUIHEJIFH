//
//  FinanceFrameItem.m
//  ZhouDao
//
//  Created by cqz on 16/7/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FinanceFrameItem.h"

@implementation FinanceFrameItem


- (void)setFinanceModel:(FinanceModel *)financeModel
{
    _financeModel = financeModel;
    
    // 0. 定义间距
    CGFloat padding = 15;

    // 1. 标题
    CGFloat titX = padding;
    CGFloat titY = padding;
    CGFloat titW = 140;
    CGFloat titH = 20;

    self.titleLabelF = CGRectMake(titX, titY, titW, titH);
    
    //标签由数量来决定
    
    NSData *titData = [financeModel.title dataUsingEncoding:NSUTF8StringEncoding];
    __block NSMutableArray *jsonTitArr = [NSJSONSerialization JSONObjectWithData:titData options:NSJSONReadingAllowFragments error:nil];
    
    NSData *contentData = [financeModel.content dataUsingEncoding:NSUTF8StringEncoding];
    __block NSMutableArray *jsonConArr = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
    CGFloat labelMaxWidth = kMainScreenWidth-30;
    
    __block NSMutableArray *arr = [NSMutableArray array];
    
    
    [jsonConArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx < jsonConArr.count -1) {
            if (obj.length >0) {
                NSString *str = [NSString stringWithFormat:@"%@:%@",jsonTitArr[idx],jsonConArr[idx]];
                
                [arr addObject:str];
            }
        }
    }];

    NSString *desString = [NSString stringWithFormat:@"%@",[jsonConArr lastObject]];
    self.desString = desString;
    self.labArrays  = arr;
    
    
    CGFloat tagX = 0;
    CGFloat tagY = 42;
    CGFloat tagW = kMainScreenWidth;
    CGFloat tagH = 26.f;
    
    if (arr.count == 2) {
        NSString *str1 = arr[0];
        NSString *str2 = arr[1];
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:10.f]};
        CGSize Size_str1=[str1 sizeWithAttributes:attrs];
        CGSize Size_str2=[str2 sizeWithAttributes:attrs];
        if ((Size_str1.width + Size_str2.width +55) > kMainScreenWidth) {
            tagH = 51.f;
        }
    }
    
    if (arr.count == 3) {
        NSString *str1 = arr[0];
        NSString *str2 = arr[1];
        NSString *str3 = arr[2];
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:10.f]};
        CGSize Size_str1=[str1 sizeWithAttributes:attrs];
        CGSize Size_str2=[str2 sizeWithAttributes:attrs];
        CGSize Size_str3=[str3 sizeWithAttributes:attrs];
        
        if ((Size_str1.width + Size_str2.width + Size_str3.width +80) > kMainScreenWidth) {
            tagH = 51.f;
        }
    }
    _tagViewF = CGRectMake(tagX, tagY, tagW, tagH);
    
    //内容高度计算
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size = [desString boundingRectWithSize:CGSizeMake(labelMaxWidth, 9999)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

    if (desString.length == 0) {
        
        self.cellHeight1 = tagY +tagH +5.f;
        self.cellHeight2 = tagY +tagH +5.f;
    }else {

        if (size.height < 34.f) {
            
            self.ContentF1 = CGRectMake(15, tagY + tagH +5.f, kMainScreenWidth - 30, size.height);
            self.ContentF2 = CGRectMake(15, tagY + tagH +5.f, kMainScreenWidth - 30, size.height);

            self.cellHeight1 = tagY +tagH +10.f +size.height;
            self.cellHeight2 = tagY +tagH +10.f + size.height;
            
        }else {
            self.ContentF1 = CGRectMake(15, tagY + tagH +1.f, kMainScreenWidth - 30, 34.f);
            self.ContentF2 = CGRectMake(15, tagY + tagH +1.f, kMainScreenWidth - 30, size.height);

            self.cellHeight1 = tagY +tagH +10.f + 34.f +20.f;
            self.cellHeight2 = tagY +tagH +10.f + size.height +20.f;

        }
    }
    
}
+ (NSMutableArray *)financeFramesWithDataArr:(NSArray *)dataArr
{
    NSMutableArray *arrayM = [NSMutableArray array];

    for (FinanceModel *model in dataArr)
    {
        FinanceFrameItem *fianceFrame = [[FinanceFrameItem alloc] init];
        fianceFrame.financeModel = model;
        [arrayM addObject:fianceFrame];
    }
    
    return arrayM;
}
@end
