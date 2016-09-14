//
//  FilterReusableView.h
//  UItext
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterReusableView : UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

-(void)setLabelText:(NSString *)text;

@end
