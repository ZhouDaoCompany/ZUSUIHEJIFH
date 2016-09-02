//
//  Disability_AlertView.h
//  ZhouDao
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 CQZ. All rights reserved.
//
typedef NS_ENUM(NSUInteger,DisabilityType) {
    
    ElseType = 0,        //伤残等级 选择
    ScheduleType = 1,    //案件选择
};

#import <UIKit/UIKit.h>
@protocol Disability_AlertViewPro;

@interface Disability_AlertView : UIView

@property (nonatomic, assign) DisabilityType type;
@property (nonatomic, weak)   id<Disability_AlertViewPro>delegate;
//@property (nonatomic, copy)   ZDMutableArrayBlock arraysBlock;
//@property (nonatomic, copy)   ZDStringBlock stringBlock;

- (id)initWithFrame:(CGRect)frame
           withType:(NSUInteger)type;
-(void)zd_Windowclose;

@end

@protocol Disability_AlertViewPro <NSObject>

@optional
- (void)selectDisableGrade:(NSArray *)gradeArrays;
- (void)selectCaseType:(NSString *)caseString;
@end