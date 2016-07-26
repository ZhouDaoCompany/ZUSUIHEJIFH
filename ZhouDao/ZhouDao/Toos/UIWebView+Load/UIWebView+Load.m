//
//  UIWebView+Load.m
//  ULife
//
//  Created by tcnj on 15/10/16.
//  Copyright © 2015年 UHouse. All rights reserved.
//

#import "UIWebView+Load.h"

@implementation UIWebView (Load)
- (void)loadURL:(NSString*)URLString{
    
    NSStringEncoding * usedEncoding = nil;

    NSString *encodedUrl = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes (NULL, (__bridge CFStringRef) URLString, NULL, NULL,kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    //带编码头的如 utf-8等 这里会识别
    NSString *body = [NSString stringWithContentsOfURL:url usedEncoding:usedEncoding error:nil];
    if (!body)
    {
        //如果之前不能解码，现在使用GBK解码
        DLog(@"GBK");
        body = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!body) {
        //再使用GB18030解码
        DLog(@"GBK18030");
        body = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (body) {
        [self loadHTMLString:body baseURL:nil];
    }else {
        DLog(@"没有合适的编码");
        [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}
- (void)loadHtml:(NSString*)htmlName{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:htmlName ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath?:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadRequest:request];
}
- (void)clearCookies
{
    NSHTTPCookieStorage *storage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    
    for (NSHTTPCookie *cookie in storage.cookies)
        [storage deleteCookie:cookie];
    
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
