//
//  commonReusableView.h
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commonReusableView : UICollectionReusableView

@property (strong, nonatomic) UILabel *label;

-(void)setLabelText:(NSString *)text;

@end
