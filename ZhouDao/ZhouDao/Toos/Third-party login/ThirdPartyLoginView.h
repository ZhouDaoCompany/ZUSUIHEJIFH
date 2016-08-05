//
//  ThirdPartyLoginView.h
//  ZhouDao
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThirdPartyLoginPro;

@interface ThirdPartyLoginView : UIView


@property (nonatomic, copy) ZDIndexBlock frameBlock;
@property (nonatomic, weak)  id<ThirdPartyLoginPro>delegate;

- (id)initWithFrame:(CGRect)frame
      withPresentVC:(UIViewController *)superVC;
@end

@protocol ThirdPartyLoginPro <NSObject>

- (void)isBoundToLoginSuccessfully;
- (void)unboundedAccountToBindwithUsid:(NSString *)usid withs:(NSString *)sString;
@end
