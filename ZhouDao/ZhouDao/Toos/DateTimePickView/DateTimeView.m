//
//  DateTimeView.m
//  TestDemo
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 zhongGe. All rights reserved.
//

#import "DateTimeView.h"

@interface DateTimeView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic)  UIPickerView *datePickerView;

@property (strong,nonatomic) NSDateFormatter *myFomatter;
@property (strong,nonatomic) NSCalendar *calendar;
@property (strong,nonatomic) NSDate *selectedDate;
@property (strong,nonatomic) NSDate *pickerStartDate;
@property (strong,nonatomic) NSDate *pickEndDate;
@property (strong,nonatomic) NSDateComponents *selectedComponents;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *botomView;

@property NSInteger unitFlags;

@end
@implementation DateTimeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
        
    }
    return self;
}
- (void)initUI
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    UIView *bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3f;
    _bgView = bgView;
    [self addSubview:_bgView];
    
    UIView *botomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, 256)];
    _botomView = botomView;
    [self addSubview:_botomView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , width, 39)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, width - 80, 39)];
    titleLbl.text = @"选择时间";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:15.f];
    [header addSubview:titleLbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(header), kMainScreenWidth, .5f)];
    lineView.backgroundColor = LINECOLOR;
    [_botomView addSubview:lineView];
    
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(width - 50, 0, 50 ,39)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = Font_14;
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 ,39)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = Font_14;
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [_botomView addSubview:header];

    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Orgin_y(lineView), width, _botomView.frame.size.height - Orgin_y(lineView))];
    pick.delegate = self;
    pick.dataSource = self;
    pick.backgroundColor = [UIColor whiteColor];
    _datePickerView = pick;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.timeString = [formatter stringFromDate:[NSDate date]];

    [self reloadWithDate:self.timeString];
    [_botomView addSubview:_datePickerView];
    
    [self pickerViewSetDate:[NSDate date]];
    
    
    [UIView animateWithDuration:.35f animations:^{
        _botomView.frame = CGRectMake(0, height -256.f, width, 216);
    }];

}
#pragma mark SubView Methods
-(void)reloadWithDate:(NSString *)dateString{
    [self setFomatter];

    self.selectedDate = [self.myFomatter dateFromString:dateString];
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:self.selectedDate];
}

#pragma mark Private Methods
-(void)setFomatter{
    self.myFomatter = [[NSDateFormatter alloc]init];
    [self.myFomatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.calendar = [NSCalendar currentCalendar];
    self.selectedDate = [NSDate date];
    self.pickerStartDate = [self.myFomatter dateFromString:@"1900年2月1日 13:59"];
    self.pickEndDate = [self.myFomatter dateFromString:@"2100年12月31日 13:59"];
    self.unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
}
// 模拟datepicker setdate 方法
-(void)pickerViewSetDate:(NSDate *)date{
    NSDateComponents *temComponents = [[NSDateComponents alloc]init];
    temComponents = [self.calendar components:NSCalendarUnitYear fromDate:date];
    NSInteger yearRow = [temComponents year] - 1900;
    NSInteger monthRow = [[self.calendar components:NSCalendarUnitMonth fromDate:date] month] - 1;
    NSInteger dayRow = [[self.calendar components:NSCalendarUnitDay fromDate:date] day] - 1;
    NSInteger hourRow = [[self.calendar components:NSCalendarUnitHour fromDate:date] hour];
    NSInteger minRow = [[self.calendar components:NSCalendarUnitMinute fromDate:date] minute];
    [self.datePickerView selectRow:yearRow inComponent:0 animated:YES];
    [self.datePickerView selectRow:monthRow inComponent:1 animated:YES];
    [self.datePickerView selectRow:dayRow inComponent:2 animated:YES];
    [self.datePickerView selectRow:hourRow inComponent:3 animated:YES];
    [self.datePickerView selectRow:minRow inComponent:4 animated:YES];
}
#pragma mark - UIPickerViewDataSource Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear
                                                            fromDate:self.pickerStartDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld年", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 1: {
            NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)row+1];
            [dateLabel setText:currentMonth];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:self.selectedDate];
            
            NSString *currentDay = [NSString stringWithFormat:@"%lu日", (row + 1) % (dateRange.length + 1)];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 3:{
            NSString *currentHour = [NSString stringWithFormat:@"%ld时",(long)row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 4:{
            NSString *currentMin = [NSString stringWithFormat:@"%02ld分",(long)row];
            [dateLabel setText:currentMin];
            dateLabel.textAlignment = NSTextAlignmentCenter;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSDateComponents *startCpts = [self.calendar components:NSCalendarUnitYear
                                                           fromDate:self.pickerStartDate];
            NSDateComponents *endCpts = [self.calendar components:NSCalendarUnitYear
                                                         fromDate:self.pickEndDate];
            return [endCpts year] - [startCpts year] + 1;
        }
            
        case 1:
            return 12;
        case 2:{
            NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:self.selectedDate];
            return dayRange.length;
        }
        case 3:
            return 24;
        case 4:
            return 60;
        default:
            break;
    }
    return 0;
}

//每次修改都要执行的方法
-(void)changeDateLabel
{
    
}

#pragma mark - UIPickerViewDelegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            NSInteger year = 1900 + row ;
            [self.selectedComponents setYear:year];
            self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
        }
            break;
        case 1:
        {
            [self.selectedComponents setMonth:row+1];
            self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
        }
            break;
        case 2:
        {
            [self.selectedComponents setDay:row +1];
            self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
        }
            break;
        case 3:
        {
            [self.selectedComponents setHour:row];
            self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
        }
            break;
        case 4:
        {
            [self.selectedComponents setMinute:row];
            self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
        }
    }
    [self.datePickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 35.0;
}
#pragma mark -UIButton
- (void)cancel:(UIButton *)btn
{
    [self hide];
    
}

- (void)submit:(UIButton *)btn
{
//    self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
    NSString *selectedDateString = [self.myFomatter stringFromDate:self.selectedDate];
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[self.selectedDate timeIntervalSince1970]];
    self.timeBlock(selectedDateString,timeSJC);
    
    [self hide];
}
- (void)hide
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    [UIView animateWithDuration:.35f animations:^{
        
        _botomView.frame = CGRectMake(0, height, width, 256);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        _datePickerView = nil;
        [self removeFromSuperview];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
