//
//  ViewController.m
//  AlertWindow
//
//  Created by cqz on 16/9/4.
//  Copyright © 2016年 cqz. All rights reserved.
//

#import "ViewController.h"
#import "DefineHeader.h"
#import "Disability_AlertView.h"
#import "NSDate+fish_Extension.h"
#import "NSBundle+HTML.h"
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<Disability_AlertViewPro, UIWebViewDelegate>
{
    UIWebView *_webView;

}
@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   /* NSString *pathSource1 = [[NSBundle mainBundle] pathForResource:@"InjuryInductrial" ofType:@"plist"];
    NSDictionary *bigDictionary = [NSDictionary dictionaryWithContentsOfFile:pathSource1];
    NSString *content = bigDictionary[@"黑龙江省"];
    _webView.backgroundColor = [UIColor blackColor];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    _webView.delegate = self;
    _webView.scalesPageToFit = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    //设置webview的背景色
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setOpaque:NO];
    [self.view addSubview:_webView];
    
    NSDictionary *dictt = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content", nil];
    [self aWebViewCss:@"DetailContent.xml" :dictt];*/
    
    

    
    NSArray *areaArrays = @[@"安徽省",@"北京市",@"重庆市",@"福建省",@"甘肃省",@"广东省",@"广西壮族自治区",@"贵州省",@"海南省",@"河北省",@"河南省",@"黑龙江省",@"湖北省",@"湖南省",@"吉林省",@"江苏省",@"江西省",@"辽宁省",@"内蒙古自治区",@"宁夏回族自治区",@"青海省",@"山东省",@"山西省",@"陕西省",@"上海市",@"四川省",@"天津市",@"西藏自治区",@"新疆维吾尔自治区",@"云南省",@"浙江省"];
    
    NSMutableDictionary *areaDictionary = [NSMutableDictionary dictionary];
//    for (NSUInteger i = 0; i < [areaArrays count]; i++) {
//        
//        NSString *nameString = areaArrays[i];
//        NSString *pathsss = [[NSBundle mainBundle] pathForResource:nameString ofType:@"txt"];
//        NSData *data = [NSData dataWithContentsOfFile:pathsss];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *dictionary = dict[nameString];
//        NSLog(@"第几个－－－－:   %ld",i);
//        [areaDictionary setObject:dictionary forKey:nameString];
//    }
    
    NSString *pathsss = [[NSBundle mainBundle] pathForResource:@"city(2)" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:pathsss];
    NSArray *cityArrays = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    //获取本地沙盒路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"ProvincesCity.plist"];
    //写入文件
    [cityArrays writeToFile:plistPath atomically:YES];
    
//        NSString *pathsss = [[NSBundle mainBundle] pathForResource:@"地级市平均工资" ofType:@"txt"];
//        NSData *data = [NSData dataWithContentsOfFile:pathsss];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    
////    NSArray *keysArrays = [dict allKeys];
////    
////    NSMutableDictionary *dict001 = [NSMutableDictionary dictionary];
////    for (NSString *hs in keysArrays) {
////        
////        NSMutableDictionary *dict002 = [NSMutableDictionary dictionary];
////
////        NSDictionary *dictionary = dict[hs];
////        NSString *str1 = dictionary[@"hisamt"];
////        NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
////        NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
////
////        
////        NSString *str2 = dictionary[@"workamt"];
////        NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
////        NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:nil];
////        
////        NSString *str3 = dictionary[@"injuryamt"];
////
////        [dict002 setValue:str3 forKey:@"injuryamt"];
////        [dict002 setValue:dict1 forKey:@"hisamt"];
////        [dict002 setValue:dict2 forKey:@"workamt"];
////
////        [dict001 setValue:dict002 forKey:hs];
////    }
//    //获取本地沙盒路径
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //获取完整路径
//    NSString *documentsPath = [path objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"TheAverageSalary.plist"];
////    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] init];
////    //设置属性值
////    [usersDic setObject:@"chan" forKey:@"name"];
////    [usersDic setObject:@"123456" forKey:@"password"];
//    //写入文件
//    [dict writeToFile:plistPath atomically:YES];
// 
//    [self calculateYearsWithMonthsFromDate:[NSDate dateFromString:@"2016-09-30" format:@"yyyy-MM-dd"] toDate:[NSDate dateFromString:@"2016-10-31" format:@"yyyy-MM-dd"] withYear:YES Success:^(NSString *dateString) {
//        
//        
//        
//    }];
//
    
//    [self.view addSubview:self.sureBtn];
//    
//    //创建日历
//    NSCalendar *calendar=[NSCalendar currentCalendar];
//    //定义成分
//    NSCalendarUnit unitFlags=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDate *tempDate = [NSDate dateFromString:@"2016-09-18" format:@"yyyy-MM-dd"];
//    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
//    [dateComponent  setYear:0];
//    [dateComponent setMonth:1];
//    [dateComponent setDay:0];
//    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
//    
////    NSString *str1 = [NSDate datestrFromDate:newdate withDateFormat:@"yyyy-MM-dd"];//[NSDate datestrFromDate:newdate format:@"yyyy-MM-dd"];
////    DLog(@"输出时间是－－－%@",str1);
//    
////    [self calculateAgeFromDate:[NSDate dateFromString:@"2016-09-04" format:@"yyyy-MM-dd"] toDate:[NSDate dateFromString:@"2016-10-01" format:@"yyyy-MM-dd"]];
////    
////    ///P:贷款本金  R:月利率    N:还款期数    还款期数=贷款年限×12
////
////    
////    double x = [self loanPrincipal:200000.f withAnInterest:0.00465 withRepaymentPeriods:180];
////    DLog(@"--------%.2f",x);
//    
//    
//    
////    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
////    
////    NSDateComponents *comps = nil;
////    
////    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:mydate];
////    
////    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
////    
////    [adcomps setYear:0];
////    
////    [adcomps setMonth:-1];
////    
////    [adcomps setDay:0];
////    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
}
- (void)aWebViewCss:(NSString *)aXML :(NSDictionary *)dicttionary
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    NSDate * data = [NSDate dateWithTimeIntervalSince1970:[[dicttionary objectForKey:@"createtime"] floatValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" MM-dd HH:mm"];
    NSString *regStr = [formatter stringFromDate:data];
    [dict setObject:regStr forKey:@"dates"];
    [dict setValuesForKeysWithDictionary:dicttionary];
    
    NSString * html = [NSBundle htmlFromFileName:aXML params:dict];
    [_webView loadHTMLString:html baseURL:nil];
}

- (void)calculateYearsWithMonthsFromDate:(NSDate *)date1 toDate:(NSDate *)date2 withYear:(BOOL)isYear Success:(void(^)(NSString *dateString))success
{
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = (isYear == YES)?(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay):(NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSUInteger years = [components year];
    NSUInteger months = [components month];
    NSUInteger days = [components day];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    if (isYear == YES) {
        
        if (years > 0) {
            
            [str appendFormat:@"%ld年",years];
        }
    }
    if (months > 0) {
        
        [str appendFormat:@"%ld月",months];
    }
    if (days > 0) {
        
        [str appendFormat:@"%ld天",days];
    }
    
    success(str);
}

#pragma mark - 房贷等额本息计算公式
///P:贷款本金  R:月利率    N:还款期数    还款期数=贷款年限×12

/**
 房贷等额本息计算公式

 @param P 贷款本金
 @param R 月利率
 @param N 还款期数

 @return 月供本息
 */
- (double)loanPrincipal:(double)P withAnInterest:(double)R withRepaymentPeriods:(NSUInteger)N
{
    double money = 0.0f;
    money = P*(R*pow(1 + R, N))/(pow(1 + R, N) - 1);
    return money;
}
//得到时间戳
- (NSString *)getTheTimeStamp:(NSString *)timeStamp
{
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *tempDate = [self timeStampChangeNSDate:[timeStamp doubleValue]];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:1];
    [dateComponent setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    NSString *sjcString = [self dateChangeTimeStampMethods:newdate];
    return sjcString;
}

#pragma mark - NSDate转换为时间戳
- (NSString *)dateChangeTimeStampMethods:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    return timeSp;
}

- (NSDate *)timeStampChangeNSDate:(NSTimeInterval)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

- (void)bindingBtnEvent:(UIButton *)btn
{
    DLog(@"点击");
    Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:DisabilityGradeType withDelegate:self];

//    Disability_AlertView *alertView = [[Disability_AlertView alloc] initWithType:CaseType withDelegate:self];
    [alertView show];
}
- (void )calculateAgeFromDate:(NSDate *)date1 toDate:(NSDate *)date2{
    
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags =  NSCalendarUnitWeekday | NSCalendarUnitDay;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
     //两个日期相距的天数
    NSUInteger days = [components day];
    //计算开始星期几
    NSDateComponents *beginComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date1];
    NSUInteger beginWeekDay = [beginComponets weekday];
    
    //计算结束星期几
    NSDateComponents *endComponets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date2];
    NSUInteger endWeekDay = [endComponets weekday];

    //计算多少个星期
    NSUInteger allWeek = days/7;
    
    //每周算2天周末，计算一共多少个周末
    NSUInteger weekend = allWeek * 2;

    //处理临界点，比如起始日是周日
    if(beginWeekDay == 1){
        weekend -= 1;
    }
    if(endWeekDay == 1){
        weekend += 1;
    }else if(endWeekDay > 6){
        weekend += 2;
    }

    //weekend 的值就是周末的天数
    //weekday 的值就是工作日的天数
    NSUInteger weekday =days - weekend;
    DLog(@"总天数:%lu     工作日:%lu",(unsigned long)days,(unsigned long)weekday);

}
/*
 //一天的毫秒数
 var oneDay = 1000 * 60 * 60 * 24;
 
 //from:起始
 //to:截止
 function calcWeekend(from, to){
 //两个日期相距的天数
 var interval = Math.floor(to.getTime() / oneDay) - Math.floor(from.getTime() / oneDay);
 
 //计算星期几
 var x = from.getDay(); //0-6
 
 //计算多少个星期
 var weeks = Math.floor(interval / 7);
 
 //计算零头
 var rest = interval - weeks*7;
 
 //根据当天是星期几，加上零头，计算截止日是星期几
 var y = x + rest;
 
 //每周算2天周末，计算一共多少个周末
 var weekend = weeks * 2;
 //处理临界点，比如起始日是周日
 if(x == 6){
 weekend -= 1;
 }
 if(y == 6){
 weekend += 1;
 }
 else if(y > 5){
 weekend += 2;
 }
 
 //weekend 的值就是周末的天数
 
 //weekday 的值就是工作日的天数
 weekday =interval - weekend;
 }
 */

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(26, 100, kMainScreenWidth - 52, 40);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5.f;
        _sureBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_sureBtn setTitle:@"点击" forState:0];
        _sureBtn.titleLabel.font = Font_14;
        _sureBtn.tag = 3026;
        [_sureBtn addTarget:self action:@selector(bindingBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
