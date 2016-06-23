//
//  SelectReusableView.h
//  MyChannelEdit
//
//  Created by cqz on 16/3/18.
//  Copyright © 2016年 奥特曼. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectReusableViewPro <NSObject>

- (void)editStateShake;

@end

@interface SelectReusableView : UICollectionReusableView
{
    UIButton *_editBtn;
}

@property (strong, nonatomic) UILabel *titLab;
@property (nonatomic ,copy) NSString *stateStr;//编辑状态

@property (nonatomic,weak)id<SelectReusableViewPro>delegete;

@end
