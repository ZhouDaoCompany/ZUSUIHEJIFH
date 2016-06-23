//
//  FMUString.m
//  FMLibrary
//
//  Created by leks on 13-3-22.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMUString.h"
#import <QuartzCore/QuartzCore.h>

//暴雪MPQ HASH算法
#define HASH_MAX_LENGTH 2*1024	//最大字符串长度(字节)
typedef unsigned int DWORD;		//类型定义
static DWORD cryptTable[0x500];		//哈希表
static bool HASH_TABLE_INITED = false;
static void prepareCryptTable();
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex);

@implementation FMUString

#pragma mark - Base
+ (BOOL)isEmptyString:(NSString *)_str
{
    if ([_str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([_str isEqualToString:@""]) {
        return YES;
    }
    if (_str == nil) {
        return YES;
    }
    if (_str == NULL) {
        return YES;
    }
    if ((NSNull*)_str == [NSNull null]) {
        return YES;
    }
    return NO;
}
+ (BOOL)isEmpty:(NSDictionary *)_dic
{
    if ([_dic isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (_dic == nil) {
        return YES;
    }
    if (_dic == NULL) {
        return YES;
    }
    if ((NSNull*)_dic == [NSNull null]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyStringFilterBlank:(NSString *)_str
{
    if ([self isEmptyString:_str]) {
        return YES;
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    if (string.length == 0) {
        return YES;
    }
    return NO;
}

+(NSString*)bytesSizeText:(double)bytes
{
    NSString *ret = nil;
    double size = bytes;
    if (size > 1024*1024)
    {
        ret = [NSString stringWithFormat:@"%.1fMB", size / 1024.0 / 1024.0];
    }
    else if (size > 1024)
    {
        ret = [NSString stringWithFormat:@"%.0fKB", size / 1024.0];
    }
    else
    {
        ret = [NSString stringWithFormat:@"%.0f字节", size];
    }
    
    return ret;
}

+ (NSInteger)textLength:(NSString *)text
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

+ (NSUInteger)theLenthOfStringFilterBlank:(NSString *)_str
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@",_str];
    [string replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, string.length)];
    return string.length;
}

//+ (CGFloat)heightForText:(NSString*)text withTextWidth:(NSInteger)textWidth withFont:(UIFont*)aFont {
//    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
//    return size.height;
//}

//+ (CGFloat)widthForText:(NSString*)text withTextHeigh:(NSInteger)textHeigh withFont:(UIFont*)aFont
//{
////boundingRectWithSize:options:attributes:context
//    CGSize size = [text sizeWithFont:aFont constrainedToSize:CGSizeMake(MAXFLOAT, textHeigh) lineBreakMode:UILineBreakModeWordWrap];
//    return size.width;
//}
//


+ (BOOL)inputView:(id)inputView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text maxLength:(NSInteger)maxlength
{
    if (![inputView isKindOfClass:[UITextView class]] &&
        ![inputView isKindOfClass:[UITextField class]] &&
        ![inputView isKindOfClass:[UISearchBar class]]) {
        return NO;
    }
    
    if (range.length == 1 && text.length == 0) { //退格键
        return YES;
    }
    else {
        if (range.location < maxlength) {
            NSInteger re_length = maxlength - range.location;
            if (text.length > re_length) {
                NSRange liRange = NSMakeRange(0, re_length);
                NSString *liString = [text substringWithRange:liRange];
                
                if ([inputView isKindOfClass:[UITextView class]]) {
                    UITextView *textView = (UITextView *)inputView;
                    textView.text = [textView.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UITextField class]])
                {
                    UITextField *textField = (UITextField *)inputView;
                    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:liString];
                }
                else if ([inputView isKindOfClass:[UISearchBar class]])
                {
                    UISearchBar *searchBar = (UISearchBar *)inputView;
                    searchBar.text = [searchBar.text stringByReplacingCharactersInRange:range withString:liString];
                }
                
                return NO;
            }
            return YES;
        }
        return NO;
    }
}

+(void)sizeToFitWebView:(UIWebView*)webview
{
    //    webview.scalesPageToFit = NO;
    CGRect rect = webview.frame;
    rect.size.height = 1;
    webview.frame = rect;
    
    int content_height = [[webview stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    
    rect.size.height = content_height;
    webview.frame = rect;
    //    webview.scalesPageToFit = YES;
}

//判断是否为数字
+ (BOOL)isNumberVaild:(NSString *)aString
{
    NSString *Regex = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [phoneTest evaluateWithObject:aString];
}

+(BOOL)digitACharacterAuth:(NSString*)password min:(NSInteger)min max:(NSInteger)max
{
    //6-16位数字或者英文字母
    if (password.length < min || password.length >max) {
        return NO;
    }
    NSString *Regex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [pwdTest evaluateWithObject:password];
}

#pragma mark - Time
//1233444s => "YYYY/MM/dd(formatestr)"
+ (NSString *)timeIntervalSince1970:(NSTimeInterval)secs Format:(NSString*)formatestr
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatestr];
    NSString *ret = [formatter stringFromDate:date];
    [formatter release];
    
    return ret;
}

//"YYYY/MM/dd(formatestr)" => 1233444s
+ (NSTimeInterval)secTimeInterValSice1970:(NSString *)string Format:(NSString *)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatestr];
    NSDate *date = [formatter dateFromString:string];
    
    NSTimeInterval sec = [date timeIntervalSince1970];
    [formatter release];
    
    return sec;
}

//NSDate 2013-5-8 19:09 45 => ***前 或 yyyy-MM-dd
+ (NSString*)timeSinceDate:(NSDate*)date format:(NSString*)formatestr
{
    NSDate *now_dt = [NSDate date];
    
    NSTimeInterval real_seconds = [now_dt timeIntervalSinceDate:date];
    
	NSUInteger ttext = 0;
	NSString *ret = nil;
    
	if (real_seconds > 60*60*24)
	{
		ttext = real_seconds/60/60/24;
        if (ttext <= 2) {
            ret = [NSString stringWithFormat:@"%lu天前", (unsigned long)ttext];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatestr];
            ret = [formatter stringFromDate:date];
            [formatter release];
        }
        
	}
	else if (real_seconds > 60*60)
	{
		ttext = real_seconds/60/60;
        ret = [NSString stringWithFormat:@"%lu小时前", (unsigned long)ttext];
	}
	else
	{
		ttext = real_seconds/60;
        ret = [NSString stringWithFormat:@"%lu分钟前", (unsigned long)ttext];
	}
    return ret;
}

//"YYYY/MM/dd(formatestr)" => ***前 或 yyyy-MM-dd(formatestr)
+ (NSString*)timeSinceDateString:(NSString*)datestr Format:(NSString*)formatestr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formatestr];
	NSDate *pub_dt = [formatter dateFromString:datestr];
	[formatter release];
    
    return [self timeSinceDate:pub_dt format:formatestr];
}

#pragma mark - URL
//是否为url
+ (BOOL)isURL:(NSString*)url
{
    NSString *regex = @"(http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [urlPredicate evaluateWithObject:url];
    return result;
}

//拼接url
+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                      NULL, /* allocator */
                                                                                      (CFStringRef)[params objectForKey:key],
                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                      (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        [escaped_value release];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

//解析url参数
+ (NSDictionary *)getParamsFromUrl:(NSString*)urlQuery
{
    NSArray *pairs = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:10];
    for (int i=0; i<pairs.count; i++)
    {
        NSString *pair = [pairs objectAtIndex:i];
        NSArray *tmp = [pair componentsSeparatedByString:@"="];
        if (tmp.count > 1)
        {
            [md setObject:[tmp objectAtIndex:1] forKey:[tmp objectAtIndex:0]];
        }
    }
    return md;
}

//解析url参数
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

#pragma mark - HTML
+ (NSString*)filterHtml:(NSString*)str
{
    if (!str) {
        return nil;
    }
    NSMutableString *ms = [NSMutableString stringWithCapacity:10];
    [ms setString:str];
    [ms replaceOccurrencesOfString:@"<p>" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"</p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br />" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"<br/>" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    //    [ms replaceOccurrencesOfString:@"\r\n" withString:@"\n" options:NSOrderedSame range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"\t" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    [ms replaceOccurrencesOfString:@"&#" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, ms.length)];
    
    while ([ms hasPrefix:@"\r\n"])
    {
        [ms replaceOccurrencesOfString:@"\r\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, ms.length>5?5:ms.length)];
    }
    
    while ([ms replaceOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    while ([ms replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, ms.length)] > 0)
    {
        
    }
    
    return ms;
}

//过滤HTML标签
+ (NSString *)flattenHTML:(NSString *)html
{
	if (!html)
	{
		return nil;
	}
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    NSString *ret = [NSString stringWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        ret = [ret stringByReplacingOccurrencesOfString:
               [ NSString stringWithFormat:@"%@>", text]
                                             withString:@" "];
        
    } // while //
    
    return ret;
}

#pragma mark - Encode
+ (NSString*)encodedString:(NSString*)str
{
    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL, /* allocator */
                                                                                  (CFStringRef)str,
                                                                                  NULL, /* charactersToLeaveUnescaped */
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    return [escaped_value autorelease];
}

#pragma mark - Phone
+ (BOOL)telePhoneCall:(NSString*)telno
{
    if(![[[UIDevice currentDevice] model] isEqual:@"iPhone"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不能拨打电话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    
    NSString *phoneNum = telno;
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"\u8f6c" withString:@","];
    
    NSArray *nums = [phoneNum componentsSeparatedByString:@"/"];
    phoneNum = [nums objectAtIndex:0];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:telURL];
    return YES;
}


//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//QQ验证
+ (BOOL)validateQQ:(NSString *)QQNumber{
    
    NSString *QQRegex = @"^[1-9][0-9]{4,9}$";
    NSPredicate *QQPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", QQRegex];
    BOOL isValidate = [QQPredicate evaluateWithObject:QQNumber];
    
    return isValidate;
}
+ (BOOL)isFirstLaunching {
    BOOL firstLaunching = false;
    /// asd
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastAppVersion = [userDefaults objectForKey:@"LastAppVersion"];
    NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if ([lastAppVersion floatValue] < [currentAppVersion floatValue]) {
        [userDefaults setValue:currentAppVersion forKey:@"LastAppVersion"];
        [userDefaults synchronize];
        
        firstLaunching = true;
    }
    
    return firstLaunching;
}

@end

#pragma mark - //暴雪MPQ HASH算法
//生成哈希表
static void prepareCryptTable()
{
	DWORD dwHih, dwLow,seed = 0x00100001,index1 = 0,index2 = 0, i;
	for(index1 = 0; index1 < 0x100; index1++)
	{
		for(index2 = index1, i = 0; i < 5; i++, index2 += 0x100)
		{
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwHih= (seed & 0xFFFF) << 0x10;
			seed = (seed * 125 + 3) % 0x2AAAAB;
			dwLow= (seed & 0xFFFF);
			cryptTable[index2] = (dwHih| dwLow);
		}
	}
}

//生成HASH值
DWORD HashString(const char *lpszFileName,DWORD dwCryptIndex)
{
	if (!HASH_TABLE_INITED)
	{
		prepareCryptTable();
		HASH_TABLE_INITED = true;
	}
	unsigned char *key = (unsigned char *)lpszFileName;
	DWORD seed1 = 0x7FED7FED, seed2 = 0xEEEEEEEE;
	int ch;
	while(*key != 0)
	{
		ch = *key++;
		seed1 = cryptTable[(dwCryptIndex<< 8) + ch] ^ (seed1 + seed2);
		seed2 = ch + seed1 + seed2 + (seed2 << 5) + 3;
	}
	return seed1;
}










