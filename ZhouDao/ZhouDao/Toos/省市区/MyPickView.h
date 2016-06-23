//
//  MyPickView.h
//  ZhouDao
//
//  Created by cqz on 16/3/5.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickViewBlock)(NSString *proviceStr,NSString *cityStr,NSString *districtlistStr);
@interface MyPickView : UIView

@property (nonatomic,copy) PickViewBlock pickBlock;
@property (nonatomic,copy) ZDBlock blurBlock;
- (id)initWithFrame:(CGRect)frame;
@end
