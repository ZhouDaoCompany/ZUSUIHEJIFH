//
//  PersonalHeadView.h
//  ZhouDao
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  PersonalHeadViewDelegate;

@interface PersonalHeadView : UIView
+ (PersonalHeadView *)instancePersonalHeadViewWithTotalMoney:(NSString *)totalMoney withDictionary:(NSDictionary *)dict withDelegate:(id<PersonalHeadViewDelegate>)delegate;

@property (weak, nonatomic)   id<PersonalHeadViewDelegate>delegate;

@end
@protocol  PersonalHeadViewDelegate <NSObject>
@optional
- (void)clickGradeEvent;
@end
