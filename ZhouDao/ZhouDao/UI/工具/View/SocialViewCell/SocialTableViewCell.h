//
//  SocialTableViewCell.h
//  ZhouDao
//
//  Created by apple on 16/11/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialTableViewCell : UITableViewCell


@property (nonatomic, strong) UITextField *textField;

- (void)setUIWithTitle:(NSString *)titleName
          withShowText:(NSString *)showText
             withIndex:(NSInteger)index;
@end
