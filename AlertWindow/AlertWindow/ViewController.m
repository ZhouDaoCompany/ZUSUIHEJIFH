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

@interface ViewController ()<Disability_AlertViewPro>

@property (nonatomic, strong) UIButton *sureBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.sureBtn];
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    //定义成分
    NSCalendarUnit unitFlags=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *tempDate = [NSDate dateFromString:@"2016-09-18" format:@"yyyy-MM-dd"];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:1];
    [dateComponent setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    
//    NSString *str1 = [NSDate datestrFromDate:newdate withDateFormat:@"yyyy-MM-dd"];//[NSDate datestrFromDate:newdate format:@"yyyy-MM-dd"];
//    DLog(@"输出时间是－－－%@",str1);
    
    [self calculateAgeFromDate:[NSDate dateFromString:@"2016-09-04" format:@"yyyy-MM-dd"] toDate:[NSDate dateFromString:@"2016-10-01" format:@"yyyy-MM-dd"]];
    
    ///P:贷款本金  R:月利率    N:还款期数    还款期数=贷款年限×12

    
    double x = [self loanPrincipal:200000.f withAnInterest:0.00465 withRepaymentPeriods:180];
    DLog(@"--------%.2f",x);
    
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:mydate];
//    
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    
//    [adcomps setYear:0];
//    
//    [adcomps setMonth:-1];
//    
//    [adcomps setDay:0];
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
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
