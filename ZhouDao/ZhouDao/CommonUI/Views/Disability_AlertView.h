//
//  Disability_AlertView.h
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Disability_AlertViewPro;

typedef NS_ENUM(NSUInteger,DisabilityType) {
    
    DisabilityGradeType = 0,        //伤残等级 选择
    CaseType = 1,                   //案件选择
    SelectOnly = 3,                 //伤残选择单处
    CheckNoEdit = 4,                //查看不能编辑

};

@interface Disability_AlertView : UIView


@property (nonatomic, assign) DisabilityType type;
@property (nonatomic, weak)   id<Disability_AlertViewPro>delegate;


- (id)initWithType:(DisabilityType)type withSource:(NSArray *)sourceArrays withDelegate:(id<Disability_AlertViewPro>)delegate;

-(void)zd_Windowclose;
- (void)show;

@end

@protocol Disability_AlertViewPro <NSObject>

@optional
- (void)selectDisableGrade:(NSArray *)gradeArrays;
- (void)selectCaseType:(NSString *)caseString;

@end
