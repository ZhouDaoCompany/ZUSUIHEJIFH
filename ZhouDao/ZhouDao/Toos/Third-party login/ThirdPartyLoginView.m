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
#import "UMSocial.h"

#define kMenuButtonBaseTag 7900
@interface ThirdPartyLoginView()

@property (nonatomic, assign) BOOL isLook;
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
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineView), 0, 105, 25)];
    lab.text = @"社交账号登录";
    lab.font = Font_14;
    lab.textColor = NINEColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lab), 12.f, (kMainScreenWidth - 135)/2.f, line_w)];
    lineView1.backgroundColor = lineColor;
    [self addSubview:lineView1];
    
    _items= @[[MenuLabel CreatelabelIconName:@"share_platform_wechat" Title:@"微信"],[MenuLabel CreatelabelIconName:@"share_platform_qqfriends" Title:@"QQ"]];

    for (NSUInteger index = 0; index <_items.count; index ++) {
        
        CustomButton *button = [self AllockButtonIndex:index];
        MenuLabel *objs = _items[index];
        button.MenuData = objs;
        button.tag = kMenuButtonBaseTag +index;
        CGRect toRect = CGRectMake((kMainScreenWidth - 200)/2.f + 120*index, 40, 80, 80);
        [button setFrame:toRect];
    }
    
    WEAKSELF;
    [self whenCancelTapped:^{
        
    }];
    [lab whenTapped:^{
        
        weakSelf.isLook = !weakSelf.isLook;
        if (weakSelf.isLook == YES) {
            weakSelf.frameBlock(1);
        }else {
            weakSelf.frameBlock(0);
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
#pragma mark -分享事件
-(void)selectd:(CustomButton *)button
{WEAKSELF;
    DLog(@"tag-----%ld",button.tag);
    NSInteger tag = button.tag - kMenuButtonBaseTag;
//    [button SelectdAnimation];
    if (tag == 0) {
        //微信
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(_superVC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                DLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                
                if ([weakSelf.delegate respondsToSelector:@selector(ThirdPartyLoginSuccess)])
                {
                    [weakSelf.delegate ThirdPartyLoginSuccess];
                }
                
            }
            
        });

        
    }else {
        //qq
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(_superVC,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                DLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                
                if ([weakSelf.delegate respondsToSelector:@selector(ThirdPartyLoginSuccess)])
                {
                    [weakSelf.delegate ThirdPartyLoginSuccess];
                }

                
            }});

        
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
