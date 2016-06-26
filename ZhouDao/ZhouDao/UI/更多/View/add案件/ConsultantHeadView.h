//
//  ConsultantHeadView.h
//  TabTest
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 QZ. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol ConsultantHeadViewPro;

@interface ConsultantHeadView : UIView


@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *delBtn;
@property (weak, nonatomic) id<ConsultantHeadViewPro> delegate;
-(void)setLabelText:(NSString *)text;
- (id)initWithFrame:(CGRect)frame withSection:(NSInteger)section;

@end

@protocol ConsultantHeadViewPro <NSObject>

- (void)deleteSectionEventRespose:(NSUInteger)section;

@end
