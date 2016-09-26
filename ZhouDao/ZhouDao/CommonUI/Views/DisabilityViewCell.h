//
//  DisabilityViewCell.h
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

//@protocol DisabilityViewDelegate;

@interface DisabilityViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;
//@property (nonatomic, weak) id<DisabilityViewDelegate>delegate;
@property (nonatomic, strong) PPNumberButton *numberButtons;
@property (nonatomic, strong) UILabel *titlelabel;

- (void)setCaseTypeUIwithArrays:(NSMutableArray *)sourceArrays withSection:(NSInteger)section withRow:(NSInteger)row;
- (void)settingUIWithLevel:(NSInteger)row withSourceArrays:(NSMutableArray *)sourceArrays;
- (void)selectOnlyUI:(NSInteger)row;
- (void)settingUIWithLevelNoEdit:(NSInteger)row withSourceArrays:(NSMutableArray *)sourceArrays;

@end

//@protocol DisabilityViewDelegate <NSObject>
//
//- (void)toObtainSeveralDisabilityLevel:(NSString *)text withRow:(NSInteger)row;
//
//@end
