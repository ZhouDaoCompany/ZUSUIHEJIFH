//
//  UIWebView+Load.h
//  ULife
//
//  Created by tcnj on 15/10/16.
//  Copyright © 2015年 UHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Load)
- (void)loadURL:(NSString*)URLString;
- (void)loadTxtFileUrl:(NSString *)URLString;
- (void)loadHtml:(NSString*)htmlName;
- (void)clearCookies;
@end
