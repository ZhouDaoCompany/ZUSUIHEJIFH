//
//  AboutReadView.h
//  ZhouDao
//
//  Created by cqz on 16/4/4.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AboutReadViewPro <NSObject>

- (void)lookAboutLawsWith:(NSString *)idStr;
@end
@interface AboutReadView : UIView

@property (nonatomic,strong) NSMutableArray *aboutArrays;
@property (nonatomic, weak) id<AboutReadViewPro>delegate;
@end
