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
#import <UMSocialCore/UMSocialCore.h>

#define kMenuButtonBaseTag 7900
@interface ThirdPartyLoginView()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIViewController *superVC;
@end
@implementation ThirdPartyLoginView

- (id)initWithFrame:(CGRect)frame
      withPresentVC:(UIViewController *)superVC
{
    self = [super initWithFrame:frame];
    if (self) {
        _superVC = superVC;
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 12.f, (kMainScreenWidth - 135)/2.f, line_w)];
    lineView.backgroundColor = LINECOLOR;
    [self addSubview:lineView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineView), 0, 105, 25)];
    lab.text = @"社交账号登录";
    lab.font = Font_14;
    lab.textColor = NINEColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lab), 12.f, (kMainScreenWidth - 135)/2.f, line_w)];
    lineView1.backgroundColor = LINECOLOR;
    [self addSubview:lineView1];
    
    _items= @[[MenuLabel CreatelabelIconName:@"share_platform_wechat" Title:@"微信"],[MenuLabel CreatelabelIconName:@"share_platform_qqfriends" Title:@"QQ"],[MenuLabel CreatelabelIconName:@"share_platform_sina" Title:@"新浪"]];

    for (NSUInteger index = 0; index <_items.count; index ++) {
        
        CustomButton *button = [self AllockButtonIndex:index];
        MenuLabel *objs = _items[index];
        button.MenuData = objs;
        button.tag = kMenuButtonBaseTag +index;
        CGRect toRect = CGRectMake((kMainScreenWidth - 280)/2.f + 100*index, 45, 80, 80);
        [button setFrame:toRect];
    }
    
    WEAKSELF;
    [self whenCancelTapped:^{
        
    }];
    [lab whenTapped:^{
        
        weakSelf.isLook = !weakSelf.isLook;
        if (weakSelf.isLook == YES) {
            if (weakSelf.frameBlock) {
                weakSelf.frameBlock(1);
            }
        }else {
            if (weakSelf.frameBlock) {
                weakSelf.frameBlock(0);
            }
        }
    }];
}
-(CustomButton *)AllockButtonIndex:(NSInteger)index
{
    CustomButton *button = [CustomButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

    return button;
}
#pragma mark - 第三方登录
-(void)selectd:(CustomButton *)button
{
    DLog(@"tag-----%ld",button.tag);
    NSInteger tag = button.tag - kMenuButtonBaseTag;
//    [button SelectdAnimation];
    if (tag == 0) {
        //微信
        [self thirdLoginActionWithPlatformType:UMSocialPlatformType_WechatSession withSString:@"1"];
        
    }else if (tag == 1) {
        //qq
        [self thirdLoginActionWithPlatformType:UMSocialPlatformType_QQ withSString:@"1"];


    } else {
        [self thirdLoginActionWithPlatformType:UMSocialPlatformType_Sina withSString:@"1"];

        
    }
    
}

- (void)thirdLoginActionWithPlatformType:(UMSocialPlatformType)platformType
                             withSString:(NSString *)sString { WEAKSELF;
    
    [[UMSocialManager defaultManager] authWithPlatform:platformType currentViewController:_superVC completion:^(id result, NSError *error) {
        if (error) {
            DLog(@"Auth fail with error %@", error);
        }else{
            if ([result isKindOfClass:[UMSocialAuthResponse class]]) {
                UMSocialAuthResponse *resp = result;
                // 授权信息
                DLog(@"AuthResponse : %@", [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n     AuthOriginalResponse :%@",(int)error.code,resp.uid,resp.accessToken,resp.originalResponse]);
                NSString *url = [NSString stringWithFormat:@"%@%@%@&s=%@",kProjectBaseUrl,ThirdPartyLogin,resp.uid,sString];
                [NetWorkMangerTools LoginWithThirdPlatformwithPlatform:sString withUsid:resp.uid withURLString:url RequestSuccess:^(NSString *state, id obj) {
                    
                    if ([state isEqualToString:@"1"]) {
                        if ([weakSelf.delegate respondsToSelector:@selector(isBoundToLoginSuccessfully)]) {
                            [weakSelf.delegate isBoundToLoginSuccessfully];
                        }
                        
                    }else {
                        if ([weakSelf.delegate respondsToSelector:@selector(unboundedAccountToBindwithUsid:withs:)]) {
                            [weakSelf.delegate unboundedAccountToBindwithUsid:resp.uid withs:sString];
                        }
                    }
                    
                }];

            }else{
                DLog(@"Auth fail with unknow error");
            }
        }

    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
