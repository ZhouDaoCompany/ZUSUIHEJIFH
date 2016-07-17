//
//  ThirdPartyLoginView.m
//  ZhouDao
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ThirdPartyLoginView.h"
#import "CustomButton.h"
#import "MenuLabel.h"
#import <pop/POP.h>


#define kMenuButtonBaseTag 7900
@interface ThirdPartyLoginView()


@property (nonatomic, strong) NSArray *items;
@end
@implementation ThirdPartyLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 12.f, 120, line_w)];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineView), 0, kMainScreenWidth - 270, 25)];
    lab.text = @"社交账号登录";
    lab.font = Font_14;
    lab.textColor = NINEColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lab), 12.f, 120, line_w)];
    lineView1.backgroundColor = lineColor;
    [self addSubview:lineView1];
    
   
    _items= @[[MenuLabel CreatelabelIconName:@"share_platform_wechat" Title:@"微信好友"],[MenuLabel CreatelabelIconName:@"share_platform_qqfriends" Title:@"QQ好友"]];

    for (NSUInteger index = 0; index <_items.count; index ++) {
        
        CustomButton *button = [self AllockButtonIndex:index];
        MenuLabel *objs = _items[index];
        button.MenuData = objs;
    }
    
}
-(CustomButton *)AllockButtonIndex:(NSInteger)index
{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    button.tag = kMenuButtonBaseTag +index;
    [button addTarget:self action:@selector(selectd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}
#pragma mark -
- (void)setIsLook:(BOOL)isLook
{
    _isLook = isLook;
    
    if (_isLook == NO) {
        
        for (NSUInteger index = 0; index <_items.count; index ++) {

            NSUInteger tag = kMenuButtonBaseTag + index;
            CustomButton *button = (CustomButton *)[self viewWithTag:tag];
            CGRect toRect = CGRectMake((kMainScreenWidth - 200)/2.f + 120*index, 150, 80, 80);
            CGRect fromRect = CGRectMake((kMainScreenWidth - 200)/2.f + 120*index, 30, 80, 80);
            [button setFrame:toRect];
            double delayInSeconds = index * 0.1;
            [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:button beginTime:delayInSeconds];
        }
    }else {
        
        for (NSUInteger index = 0; index <_items.count; index ++) {
            
            NSUInteger tag = kMenuButtonBaseTag + index;
            CustomButton *button = (CustomButton *)[self viewWithTag:tag];
            CGRect toRect = CGRectMake((kMainScreenWidth - 200)/2.f + 120*index, 150, 80, 80);
            CGRect fromRect = CGRectMake((kMainScreenWidth - 200)/2.f + 120*index, 30, 80, 80);
            [button setFrame:fromRect];
            double delayInSeconds = index * 0.1;
            [self initailzerAnimationWithToPostion:fromRect formPostion:toRect atView:button beginTime:delayInSeconds];

        }
    }
}
#pragma mark -分享事件
-(void)selectd:(CustomButton *)button
{
    NSInteger tag = button.tag - kMenuButtonBaseTag;
    [button SelectdAnimation];
}

#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
