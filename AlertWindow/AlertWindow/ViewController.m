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
    NSDate *tempDate = [NSDate dateFromString:@"2015-05-23" format:@"yyyy-MM-dd"];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:tempDate];
    [dateComponent  setYear:0];
    [dateComponent setMonth:1];
    [dateComponent setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:dateComponent toDate:tempDate options:0];
    
    NSString *str1 = [NSDate datestrFromDate:newdate withDateFormat:@"yyyy-MM-dd"];//[NSDate datestrFromDate:newdate format:@"yyyy-MM-dd"];
//    DLog(@"输出时间是－－－%@",str1);
    
    [self calculateAgeFromDate:[NSDate dateFromString:@"2010-05-28" format:@"yyyy-MM-dd"] toDate:[NSDate dateFromString:@"2014-02-28" format:@"yyyy-MM-dd"]];
    

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
    
    unsigned int unitFlags =  NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    
//    NSUInteger years = [components year];
    NSUInteger month = [components month];
    NSUInteger days = [components day];
    
    DLog(@"时间间隔－－－－       %lu         %lu",(unsigned long)month,(unsigned long)days);
}


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
