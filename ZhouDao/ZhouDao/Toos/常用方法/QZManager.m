//
//  QZManager.m
//  ZhouDao
//
//  Created by cqz on 16/3/31.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "QZManager.h"
/**
 * 获取设备 IP 地址 需要先引入下头文件:
 */
#import <ifaddrs.h>
#import <arpa/inet.h>
#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view

@implementation QZManager
singleton_for_class(QZManager)
#pragma mark - 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // 去掉前后空格，判断length是否为0
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"]) {
        return YES;
    }
    
    // 不为空
    return NO;
}

#pragma mark-判断是否为纯数字
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为真实手机号码
+ (Boolean)isMobileNum:(NSString *)text
{
    if ([text length] != 11) {
        return NO;
    }
    NSString *patternStr = [NSString stringWithFormat:@"^(0?1[3578]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))?[1-9]\\d{6,7})$"];
    NSRegularExpression *regularexpression=[[NSRegularExpression alloc]initWithPattern:patternStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
    NSUInteger numberOfMatch = [regularexpression numberOfMatchesInString:text
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, text.length)];
    if (numberOfMatch > 0) {
        return YES;
    }
    return NO;
}
#pragma mark - 数字分割显示
+ (NSString *)getNewAmountSegmentationWithNumber:(float)amount withDecimal:(BOOL)isDecial {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (isDecial) {
        [formatter setPositiveFormat:@"###,##0.00;"];
    } else {
        [formatter setPositiveFormat:@"###,##0;"];
    }
//    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *newAmount = [formatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return newAmount;
}

#pragma mark - 判断email格式是否正确
+ (BOOL)isAvailableEmail:(NSString *)emailString {
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    //先把NSString转换为小写
    NSString *lowerString       = emailString.lowercaseString;
    
    return [regExPredicate evaluateWithObject:lowerString] ;
}

#pragma mark -隐藏号码中间四位
+(NSString *)getTheHiddenMobile:(NSString *)mobile
{
    if (mobile.length>7)
    {
        NSString *tel = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return tel;
    }
    else
    {
        return @"";
    }
}
#pragma mark - 找到 UIViewController

+ (UIViewController *)getViewControllerByView:(UIView *)view
{
    for (UIView* next = [view superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
#pragma mark - 姓名验证
+ (BOOL)isValidateName:(NSString *)name
{
    // 只含有汉字、数字、字母、下划线不能以下划线开头和结尾
    NSString *userNameRegex = @"^(?!_)(?!.*?_$)[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}

#pragma mark - 时间戳转时间格式
+ (NSString *)changeTimestampToCommonTime:(long)time format:(NSString *)format;
{
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    return [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]];
}


#pragma mark - 时间格式转时间戳
+ (long)changeCommonTimeToTimestamp:(NSString *)time format:(NSString *)format
{
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    return (long)[[formatter dateFromString:time] timeIntervalSince1970];
}

#pragma mark - 转json
+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ( error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
#pragma mark - 获取当前使用语言
+ (NSString *)currentLanguage
{
    NSString *opinion   = [NSLocale preferredLanguages][0];
    NSDictionary *dict  = @{
                            @"chs"      : @"chs",
                            @"cht"      : @"cht",
                            @"jp"       : @"jp",
                            @"kr"       : @"kr",
                            @"zh-Hans"  : @"chs",
                            @"zh-Hant"  : @"cht",
                            @"ja"       : @"jp",
                            @"ko"       : @"kr",
                            };
    
    // 不满足以上整合的语种，则全部默认为 en 英文
    return dict[opinion] ? dict[opinion] : @"en";
}

#pragma mark - 打印出项目工程里自定义字体名
+ (void)printCustomFontName
{
    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        printf( "Family: %s \n", [familyName UTF8String]);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}
#pragma mark -- 密码规则(6到14位包含数字或字母)
+ (BOOL)isValidatePassword:(NSString *)password
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,14}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password]) {
        DLog(@"通过");
        return YES;
    }else{
        DLog(@"不是.不通过");
        return NO;
    }
}

#pragma mark -  根据字符串的长度来计算label的宽
+ (CGSize)calculationWidthWithStr:(NSString *)string withFont:(CGFloat)font
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize ziTiSize = [string boundingRectWithSize:CGSizeMake(300, 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ziTiSize;
}
#pragma mark - 获取UILabel宽度
+ (CGFloat)getLabelWidth:(UILabel *)label {
    label.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attribute = @{NSFontAttributeName:label.font};
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.frame.size.height)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}

#pragma mark - 自适应计算字体长度
+ (CGSize)calculateLengthOfFont:(NSString *)tempString WithFont:(float)font WithlabWidth:(CGFloat)width {
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [tempString boundingRectWithSize:CGSizeMake(width,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size;
}

#pragma mark - 登录界面pop动画效果
- (void)popViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    // 带有颤动  动画效果
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        // 设置旋转中心点
        [[self class] setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- push动画
- (void)pushViewControllerAnimatedWithViewController:(UIViewController *)viewController
{
    viewController.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    [[self class] setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
    //旋转角度
    viewController.view.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
    
    // 带有颤动  动画效果
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        // 设置旋转中心点
        [[self class] setAnchorPoint:CGPointMake(1, 0) forView:viewController.view];
        //旋转角度
        viewController.view.transform = CGAffineTransformMakeRotation((360.0f * M_PI) / 180.0f);
    } completion:^(BOOL finished) {
        
    }];
    
}
//设置旋转中心
+ (void)setAnchorPoint:(CGPoint)anchorPoint
               forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

//判断系统版本
+ (BOOL)isSystemVersioniOS8
{
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f)
    {
        return YES;
    }
    return NO;
}
//截屏
+ (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
//判断时间
+ (NSString *)stringForAgoFromDate:(NSDate *)fdate toDate:(NSDate *)tdate
{
    NSCalendar *calendar =
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags =
    NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components =
    [calendar components:unitFlags fromDate:fdate toDate:tdate options:0];
    
    //TWLog(@"Year:%d Month:%d Day:%d Hour:%d Minute:%d Second:%d", components.year, components.month, components.day, components.hour, components.minute, components.second);
    
    NSString *agoStr = nil;
    if (components.year >= 0 && components.month >= 0) {
        if (components.day == 0) {
            if (components.hour == 0) {
                if (components.minute < 1.0) {
                    agoStr = @"刚刚";
                } else {
                    agoStr = [NSString stringWithFormat:@"%ld %@", (long)components.minute, @"分钟前"];
                }
            } else {
                agoStr = [NSString stringWithFormat:@"%ld %@", (long)components.hour, @"小时前"];
            }
        } else if (components.month == 0 && components.day > 0 && components.day < 7) {
            agoStr = [NSString stringWithFormat:@"%ld %@", (long)components.day, @"天前"];
        } else {
            agoStr = [[[self class] agoFormatter] stringFromDate:fdate];
        }
    } else {
        DLog(@"Time advance !");
    }
    
    return agoStr;
}
+ (NSDateFormatter*)agoFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter =[[NSDateFormatter alloc] init];
        // @"yyyy-MM-dd HH:mm:ss"
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [formatter setLocale:locale];
        formatter.dateFormat =@"MM月dd日";
    });
    return formatter;
}

+ (NSDate *)getDateFrom:(NSString *)strDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:DATE_FORMAT_YMDHMS];
    NSDate *date =[dateFormatter dateFromString:strDate];
    return date;
}

#pragma mark - 获取方向
+ (NSString *)getHeadingDes:(CGFloat )heading {
    
    NSString *aStr = @"";
    if (heading >22.5 ) {
        aStr = @"正北方向";
    } else if(heading > 67.5) {
        aStr = @"正北方向";
    } else if(heading > 112.5) {
        aStr = @"东南方向";
    } else if(heading > 157.5) {
        aStr = @"正南方向";
    } else if(heading > 202.5) {
        aStr = @"西南方向";
    } else if(heading > 247.5) {
        aStr = @"正西方向";
    } else if(heading > 292.5) {
        aStr = @"西北方向";
    } else if(heading > 337.5 || heading <= 22.5) {
        aStr = @"正北方向";
    }
    
    return aStr;
}
/**
 *得到window
 */
+ (UIWindow*)getWindow{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    DLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //DLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //DLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay withDateFormat:(NSString *)formatString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    DLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}
#pragma mark -输入的日期字符串形如：@"1992-05-21"
+ (NSDate *)caseDateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];

    return destDate;
}

#pragma mark -输入的日期字符串形如：@"19920521"
+ (NSUInteger)timeToTimeStamp:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    NSUInteger seconds = [destDate timeIntervalSince1970];
    return seconds;
}

#pragma mark ------  时间戳转换NSDate
+ (NSString *)changeTime:(NSTimeInterval)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString *)changeTimeMethods:(NSTimeInterval)time withType:(NSString *)type {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateFormat:type];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    //解决相差8小时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString* dateString = [formatter stringFromDate:localeDate];
    return dateString;
}

#pragma mark ------ 时间戳转换为NSDate
+ (NSDate *)timeStampChangeNSDate:(NSTimeInterval)time {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    //解决相差8小时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
#pragma mark - NSDate转换为时间戳
+ (NSString *)dateChangeTimeStampMethods:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    return timeSp;
}
#pragma mark - 得到该时间戳加一个月后的时间戳
+ (NSString *)getNextMonthTheTimeStamp:(NSString *)timeStamp
{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDate *tempDate = [self timeStampChangeNSDate:[timeStamp doubleValue]];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:1];
    [dateComponent setDay:0];
    [dateComponent setHour:-16];
    [dateComponent setMinute:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    NSString *sjcString = [self dateChangeTimeStampMethods:newdate];
    DLog(@"%@",sjcString);
    return sjcString;
}

#pragma mark -判断日期是今天，昨天还是明天
+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

#pragma mark -时间描述
+ (NSString *)timeToShow:(NSDate *)date02
{
    NSDate *date01 = [NSDate date];
    int size = [QZManager compareOneDay:date01 withAnotherDay:date02];
    if (size == 1){
        
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate:date02];
//        NSDate *localeDate = [date02  dateByAddingTimeInterval: interval];
        
        NSTimeInterval timeInterval = -[date02 timeIntervalSinceNow];
        if (timeInterval < 60) {
            return @"1分钟内";
        } else if (timeInterval < 3600) {
            return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
        } else if (timeInterval < 86400) {
            return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
        } else if (timeInterval  < 259200){
            
            //昨天 前天
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            
            if (timeInterval/(60*60*24) <=2) {
                return [NSString stringWithFormat:@"昨天 %@",tempStr];
            }
            return [NSString stringWithFormat:@"前天 %@",tempStr];
        }else if (timeInterval <  2592000) {
            //30天内
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }else if (timeInterval < 31536000){
            //一年内
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }else{
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }

    }else if(size == -1){
        NSTimeInterval timeInterval = [date02 timeIntervalSinceNow];
        if (timeInterval < 60) {
            return @"1分钟内";
        } else if (timeInterval < 3600) {
            return [NSString stringWithFormat:@"%.f分钟后", timeInterval / 60];
        } else if (timeInterval < 86400) {
            return [NSString stringWithFormat:@"%.f小时后", timeInterval / 3600];
        } else if (timeInterval  < 259200){
            //昨天 前天
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            if (timeInterval/(60*60*24) <=2) {
                return [NSString stringWithFormat:@"明天 %@",tempStr];
            }
            return [NSString stringWithFormat:@"后天 %@",tempStr];
        }else if (timeInterval <  2592000) {
            //30天内
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }else if (timeInterval < 31536000){
            //一年内
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSString *tempStr = [formatter stringFromDate:date02];
            return tempStr;
        }    }
    return @"现在";
}

+ (void)wrongInformationWithDic:(NSDictionary *)dic Success:(void (^)())success
{
    NSUInteger errorcode = [dic[@"state"] integerValue];
    NSString *msg = dic[@"info"];
    if (errorcode !=1) {
        [JKPromptView showWithImageName:nil message:msg];
    }else{
        success();
    }
}

#pragma mark -时间转字串
+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark -磁盘总空间
+ (CGFloat)diskOfAllSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        DLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}
#pragma mark - 磁盘可用空间
+ (CGFloat)diskOfFreeSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
#ifdef DEBUG
        DLog(@"error: %@", error.localizedDescription);
#endif
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}
//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) return 0;
    return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
}
//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}
+ (NSDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    for (id obj in array) {
        if (![obj isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组数组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [objects addObject:obj];
    }
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:objects.count];
    //按字母顺序进行分组
    NSInteger lastIndex = -1;
    for (int i = 0; i < array.count; i++) {
        NSInteger index = [indexedCollation sectionForObject:array[i] collationStringSelector:@selector(uppercaseString)];
        [[objects objectAtIndex:index] addObject:array[i]];
        lastIndex = index;
    }
    //去掉空数组
    for (int i = 0; i < objects.count; i++) {
        NSMutableArray *obj = objects[i];
        if (obj.count == 0) {
            [objects removeObject:obj];
        }
    }
    //获取索引字母
    for (NSMutableArray *obj in objects) {
        NSString *str = obj[0];
        NSString *key = [self firstCharacterWithString:str];
        [keys addObject:key];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:objects forKey:keys];
    return dic;
}
#pragma mark - 查询字符串中是否包含某个字符
+ (BOOL)isString:(NSString *)oriString withContainsStr:(NSString *)str;
{
    if ([oriString rangeOfString:str].location !=NSNotFound)
    {
        return YES;
    }
    
    return NO;
}
#pragma mark - 查找替换字符串
+ (NSString *)trimStringMethodsWithSearch:(NSString *)search
                              withReplace:(NSString *)replace
                                 withTrim:(NSMutableString *)aStr
{
    NSRange range = [aStr rangeOfString:search];
    while (range.location != NSNotFound)
    {
        [aStr replaceCharactersInRange:range withString:replace];
        range = [aStr rangeOfString:search];
    }
    return aStr;
}
//获取字符串(或汉字)首字母
- (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}
#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}
#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}
/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}
//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}
//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage *resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return resultImage;
}
//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}
#pragma mark - 返回颜色的图片
+ (UIImage*) createImageWithColor:(UIColor*)color
                             size:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

//获取设备 IP 地址
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
#pragma mark -判断字符串中是否含有空格
+ (BOOL)isHaveSpaceInString:(NSString *)string{
    NSRange _range = [string rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark -过滤特殊字符
+ (BOOL)isIncludeSpecialCharact: (NSString *)aStr {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [aStr rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

#pragma mark -判断字符串中是否含有某个字符串
+ (BOOL)isHaveString:(NSString *)string1 InString:(NSString *)string2{
    NSRange _range = [string2 rangeOfString:string1];
    if (_range.location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}
#pragma mark -判断字符串中是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -判断字符串是否全部为数字
+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}
/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                              lineCol:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}
#pragma mark -获取icon
+ (UIImage *)getAppIcon
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}
#pragma mark -画线
+(UIView *)createLineframe:(CGRect)frame
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor =LINECOLOR;
    return lineView;
}
#pragma mark - 获得版本号
+ (NSString *)getBuildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app build版本
    NSString *app_build = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    return app_build;
    //CFBundleVersion
}
#pragma mark -六位随机数
+ (NSString *)getSixEvent
{
    NSArray *arrays = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];//存放十个数，以备随机取
    NSMutableString * getStr = [[NSMutableString alloc] initWithCapacity:5];
    NSMutableString *changeString = [[NSMutableString alloc] initWithCapacity:6];//申请内存空间，一定要写，要不没有效果，我自己总是吃这个亏
    for (NSUInteger i = 0; i<6; i++) {
        NSInteger index = arc4random()%([arrays count]-1);//循环六次，得到一个随机数，作为下标值取数组里面的数放到一个可变字符串里，在存放到自身定义的可变字符串
        getStr = arrays[index];
        changeString = (NSMutableString *)[changeString stringByAppendingString:getStr];
    }
    return (NSString *)changeString;
}

#pragma mark - 使用CAShapeLayer和UIBezierPath来设置圆角
+ (void)setLayerAndBezierPathCutCircularWithView:(UIView *) view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *layers = [[CAShapeLayer alloc] init];
    layers.frame = view.bounds;
    layers.path = path.CGPath;
    view.layer.mask = layers;
}

#pragma mark - 使用Core Graphics框架 和 UIBezierPath 画出一个圆角
+ (void)setGraphicsCutCirculayWithView:(UIImageView *) view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:5] addClip];
    [view drawRect:view.bounds];
    view.image = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
}

@end

#pragma mark -类别
@implementation NSMutableDictionary(setObjectWithNullValidate)

-(BOOL)setObjectWithNullValidate:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!anObject || !aKey)
    {
        return NO;
    }
    [self setObject:anObject forKey:aKey];
    return YES;
}

@end

@implementation NSMutableArray (addObjectWithNullValidate)

-(BOOL)addObjectWithNullValidate:(id)object
{
    if (!object)
    {
        return NO;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *str = (NSString*)object;
        if (str.length == 0)
        {
            return NO;
        }
    }
    [self addObject:object];
    return YES;
}

@end

