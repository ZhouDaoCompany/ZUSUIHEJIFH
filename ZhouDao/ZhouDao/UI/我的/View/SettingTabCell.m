//
//  SettingTabCell.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SettingTabCell.h"
#import "SDPhotoBrowser.h"
#import "UMSocial.h"

@interface SettingTabCell()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) UIView *lineView;

@end
@implementation SettingTabCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    
    return self;
}
- (void)initUI
{
    
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.headImg];
    [self.contentView addSubview:self.addresslab];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.switchButton];
    
    if ([PublicFunction ShareInstance].m_user.data.photo.length >0)
    {
        //放大头像
        WEAKSELF;
        [_headImg whenTapped:^{
            
            SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
            browser.imageCount = 1; // 图片总数
            browser.currentImageIndex = 0;
            browser.delegate = self;
            browser.sourceImagesContainerView = weakSelf.headImg; // 原图的父控件
            [browser show];
        }];
    }

}
#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return kGetImage(@"home_Shuff");
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imgUrl = GET([PublicFunction ShareInstance].m_user.data.photo);
    NSString *urlStr = [imgUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

#pragma mark - private methods
#pragma mark - setters and getters
- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = Font_15;
        _nameLab.textColor = THIRDCOLOR;
    }
    return _nameLab;
}
- (UILabel *)addresslab{
    if (!_addresslab) {
        _addresslab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -200, 12, 170, 20)];
        _addresslab.textColor = [UIColor colorWithHexString:@"#666666"];
        _addresslab.font = Font_12;
        _addresslab.textAlignment = NSTextAlignmentRight;
    }
    return _addresslab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINECOLOR;
    }
    return _lineView;
}
- (UIImageView *)headImg{
    if (!_headImg) {
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 90, 10, 60, 60)];
        _headImg.layer.masksToBounds = YES;
        _headImg.userInteractionEnabled = YES;
        _headImg.layer.cornerRadius = 30.f;
    }
    return _headImg;
}
- (UISwitch *)switchButton{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-65.f, 7.f, 0, 30)];
        [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        _switchButton.onTintColor = KNavigationBarColor;
    }
    return _switchButton;
}
- (void)setSection:(NSInteger)section
{
    _section = section;
}
- (void)setRow:(NSInteger)row
{
    _row = row;
}
- (void)settingUI{
    
    if (_section == 0) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        _switchButton.hidden = YES;
        if (_row == 0) {
            _nameLab.frame = CGRectMake(15, 30, 120, 20);
            _lineView.frame = CGRectMake(15, 79.5, kMainScreenWidth-15, .5f);
            _headImg.hidden = NO;
            _addresslab.hidden = YES;
        }else{
            _nameLab.frame = CGRectMake(15, 12, 120, 20);
            _lineView.frame = CGRectMake(15, 43.5, kMainScreenWidth-15, .5f);
            _headImg.hidden = YES;
            _addresslab.hidden = NO;
            if (_row == 1) {
                _addresslab.text = [QZManager getTheHiddenMobile:_addresslab.text];

            }
            _row ==5?[_lineView setHidden:YES]:[_lineView setHidden:NO];
        }
    }else {
        self.accessoryType = UITableViewCellAccessoryNone;
        _lineView.frame = CGRectMake(15, 43.5, kMainScreenWidth-15, .5f);
        _nameLab.frame = CGRectMake(15, 12, 120, 20);

        _switchButton.hidden = NO;
        _headImg.hidden = YES;
        _addresslab .hidden = YES;
        
        
        if (_row == 0) {
            
            if ([PublicFunction ShareInstance].m_user.data.wx_au.length >0) {
                [_switchButton setOn:YES];
            }
            _nameLab.text = @"微信";
            _lineView.hidden = NO;

        }else if (_row == 1){
            if ([PublicFunction ShareInstance].m_user.data.qq_au.length >0) {
                [_switchButton setOn:YES];
            }
            _nameLab.text = @"腾讯QQ";
            _lineView.hidden = NO;


        }else {
            if ([PublicFunction ShareInstance].m_user.data.wb_au.length >0) {
                [_switchButton setOn:YES];
            }
            _nameLab.text = @"新浪微博";
            _lineView.hidden = YES;
        }
        
    }

}
#pragma mark -UIButtonEvent
- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButton = [switchButton isOn];
    
    if (isButton) {
        DLog(@"open");
        [self OpenTheBindingWith:switchButton];

    }else{
        DLog(@"close");
        [self removeTheBinding:switchButton];
    }
}
- (void)OpenTheBindingWith:(UISwitch *)switchBtn{
    
    NSString *nameString = [PublicFunction ShareInstance].m_user.data.mobile;
    NSString *typeString = [PublicFunction ShareInstance].m_user.data.type;
    
    if (_row == 0) {
        //微信
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        snsPlatform.loginClickHandler(_ParentView,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                NSString *url = [NSString stringWithFormat:@"%@%@%@&s=3",kProjectBaseUrl,ThirdPartyLogin,snsAccount.usid];
                [NetWorkMangerTools whetherAccountBindingOnImmediatelyWithURLString:url RequestSuccess:^{
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@au=%@&s=%@&mobile=%@&type=%@&udid=%@&sy=%@&ly=%@",kProjectBaseUrl,AuBindingURLString,snsAccount.usid,@"3",nameString,typeString,@"",@"2",@"2"];
                    [NetWorkMangerTools pureAuBindingURLString:urlString RequestSuccess:^{
                        
                        [PublicFunction ShareInstance].m_user.data.wx_au = snsAccount.usid;
                        
                    } fail:^{
                        [switchBtn setOn:NO];//失败关闭
                    }];
                }];
                
            } else {
                
                [switchBtn setOn:NO];//失败关闭
            }
        });
        
    } else if (_row == 1) {
        
        //qq
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        
        snsPlatform.loginClickHandler(_ParentView,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                NSString *url = [NSString stringWithFormat:@"%@%@%@&s=1",kProjectBaseUrl,ThirdPartyLogin,snsAccount.usid];
                [NetWorkMangerTools whetherAccountBindingOnImmediatelyWithURLString:url RequestSuccess:^{
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@au=%@&s=%@&mobile=%@&type=%@&udid=%@&sy=%@&ly=%@",kProjectBaseUrl,AuBindingURLString,snsAccount.usid,@"1",nameString,typeString,@"",@"2",@"2"];
                    [NetWorkMangerTools pureAuBindingURLString:urlString RequestSuccess:^{
                        
                        [PublicFunction ShareInstance].m_user.data.qq_au = snsAccount.usid;
                        
                    } fail:^{
                        [switchBtn setOn:NO];//失败关闭
                    }];
                }];
                
            } else {
                [switchBtn setOn:NO];//失败关闭
            }
        });
        
    } else {
        //新浪
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(_ParentView,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                
                NSString *url = [NSString stringWithFormat:@"%@%@%@&s=2",kProjectBaseUrl,ThirdPartyLogin,snsAccount.usid];
                [NetWorkMangerTools whetherAccountBindingOnImmediatelyWithURLString:url RequestSuccess:^{
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@au=%@&s=%@&mobile=%@&type=%@&udid=%@&sy=%@&ly=%@",kProjectBaseUrl,AuBindingURLString,snsAccount.usid,@"2",nameString,typeString,@"",@"2",@"2"];
                    [NetWorkMangerTools pureAuBindingURLString:urlString RequestSuccess:^{
                        
                        [PublicFunction ShareInstance].m_user.data.wb_au = snsAccount.usid;

                    } fail:^{
                        [switchBtn setOn:NO];//失败关闭
                    }];
                }];
                
            } else {
                [switchBtn setOn:NO];//失败关闭
            }
        });
    }

}
- (void)removeTheBinding:(UISwitch *)switchBtn
{WEAKSELF;
    
    if (_row == 0) {
        //微信
        NSString *URL = [NSString stringWithFormat:@"%@%@au=%@&s=%@&uid=%@",kProjectBaseUrl,AuBindingOCURL,[PublicFunction ShareInstance].m_user.data.wx_au,@"3",UID];
        [NetWorkMangerTools UnboundAccountwithURLString:URL
                                         RequestSuccess:^{
                                             
                                             [PublicFunction ShareInstance].m_user.data.wx_au = @"";
                                             [weakSelf chooseAWayToLogin];

                                         } fail:^{
                                             
                                             [switchBtn setOn:YES];
                                         }];
        
    } else if (_row == 1) {
        //QQ
        NSString *URL = [NSString stringWithFormat:@"%@%@au=%@&s=%@&uid=%@",kProjectBaseUrl,AuBindingOCURL,[PublicFunction ShareInstance].m_user.data.qq_au,@"1",UID];
        [NetWorkMangerTools UnboundAccountwithURLString:URL
                                         RequestSuccess:^{
                                             
                                             [PublicFunction ShareInstance].m_user.data.qq_au = @"";
                                             [weakSelf chooseAWayToLogin];
                                             
                                         } fail:^{
                                             
                                             [switchBtn setOn:YES];
                                         }];
        
    } else {
        //新浪
        NSString *URL = [NSString stringWithFormat:@"%@%@au=%@&s=%@&uid=%@",kProjectBaseUrl,AuBindingOCURL,[PublicFunction ShareInstance].m_user.data.wb_au,@"2",UID];
        [NetWorkMangerTools UnboundAccountwithURLString:URL
                                         RequestSuccess:^{
                                             
                                             [PublicFunction ShareInstance].m_user.data.wb_au = @"";
                                             [weakSelf chooseAWayToLogin];
                                             [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                                                 DLog(@"response is %@",response);
                                                 
                                             }];

                                         } fail:^{
                                             
                                             [switchBtn setOn:YES];
                                         }];

    }
}

- (void)chooseAWayToLogin
{
    if ([PublicFunction ShareInstance].m_user.data.wx_au.length > 0) {
        
        [USER_D setObject:[PublicFunction ShareInstance].m_user.data.wx_au forKey:StorageUSID];
        [USER_D setObject:@"3" forKey:StorageTYPE];
        [USER_D synchronize];
    }else if ([PublicFunction ShareInstance].m_user.data.wb_au.length > 0){
        
        [USER_D setObject:[PublicFunction ShareInstance].m_user.data.wb_au forKey:StorageUSID];
        [USER_D setObject:@"2" forKey:StorageTYPE];
        [USER_D synchronize];
        
    }else if ([PublicFunction ShareInstance].m_user.data.qq_au.length > 0){
        
        [USER_D setObject:[PublicFunction ShareInstance].m_user.data.qq_au forKey:StorageUSID];
        [USER_D setObject:@"1" forKey:StorageTYPE];
        [USER_D synchronize];
    }
    
}
- (void)dealloc {
    
    TTVIEW_RELEASE_SAFELY(_nameLab);
    TTVIEW_RELEASE_SAFELY(_addresslab);
    TTVIEW_RELEASE_SAFELY(_headImg);
    TTVIEW_RELEASE_SAFELY(_switchButton);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
