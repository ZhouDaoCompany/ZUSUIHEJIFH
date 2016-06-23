//
//  HLPickView.m
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import "ZHPickView.h"
#define SCREENSIZE UIScreen.mainScreen.bounds.size
@implementation ZHPickView
{
    UIView *bgView;
    NSArray *proTitleList;
    NSString *selectedStr;
    BOOL isDate;
}
@synthesize block;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    isDate = NO;
    return self;
}
- (void)showWindowPickView:(UIWindow *)window
{
    bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3f;
    [window addSubview:bgView];
    
    [bgView whenTapped:^{
        
        
    }];
    
    CGRect frame = self.frame ;
    self.frame = CGRectMake(0,SCREENSIZE.height + frame.size.height, SCREENSIZE.width, frame.size.height);
    [window addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         self.frame = frame;
                     }
                     completion:nil];

}

- (void)showPickView:(UIViewController *)vc
{
    bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3f;
    [vc.view addSubview:bgView];
    
    [bgView whenCancelTapped:^{
            [self hide];
    }];
    
    CGRect frame = self.frame ;
    self.frame = CGRectMake(0,SCREENSIZE.height + frame.size.height, SCREENSIZE.width, frame.size.height);
    [vc.view addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         self.frame = frame;
                     }
                     completion:nil];
}
- (void)hide
{
    [UIView animateWithDuration:.35f animations:^{
        
        float height = 256;
        self.frame = CGRectMake(0, SCREENSIZE.height, SCREENSIZE.width, height);
    } completion:^(BOOL finished) {
        [bgView removeFromSuperview];
        [self removeFromSuperview];
    }];

}
- (void)setDateViewWithTitle:(NSString *)title
{
    isDate = YES;
    proTitleList = @[];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = Font_15;
    [header addSubview:titleLbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(header), kMainScreenWidth, .5f)];
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 0, 50 ,39)];
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
    
    [self addSubview:header];
    
    // 1.日期Picker
    UIDatePicker *datePickr = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, Orgin_y(lineView), SCREENSIZE.width, 216)];
    datePickr.backgroundColor = [UIColor whiteColor];
    // 1.1选择datePickr的显示风格
    [datePickr setDatePickerMode:UIDatePickerModeDate];
//    //定义最小日期
//    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
//    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
//    //最大日期是今天
//    NSDate *minDate = [NSDate date];
//    [datePickr setMinimumDate:minDate];
    
    // 1.2查询所有可用的地区
    //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    
    // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文
    [datePickr setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    // 1.4监听datePickr的数值变化
    [datePickr addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//    
//    NSDate *date = [NSDate date];
//    
//    // 2.3 将转换后的日期设置给日期选择控件
//    [datePickr setDate:date];
    
    [self addSubview:datePickr];
    
    float height = 256;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}
- (void)setDataViewWithItem:(NSArray *)items title:(NSString *)title
{
    isDate = NO;
    proTitleList = items;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 40)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = Font_16;
    [header addSubview:titleLbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5f, kMainScreenWidth, .5f)];
    lineView.backgroundColor = lineColor;
    [header addSubview:lineView];

    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 0, 50 ,39)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = Font_15;
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 ,39)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = Font_15;
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];

    [self addSubview:header];
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, Orgin_y(header), SCREENSIZE.width, 216)];
    
    pick.delegate = self;
    pick.backgroundColor = [UIColor whiteColor];
    [self addSubview:pick];
    
    float height = 256;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}
#pragma mark DatePicker监听方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    selectedStr = [formatter stringFromDate:datePicker.date];
}
- (void)cancel:(UIButton *)btn
{
    [self hide];
    
}

- (void)submit:(UIButton *)btn
{
    NSString *pickStr = selectedStr;
    if (!pickStr || pickStr.length == 0) {
        if(isDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            selectedStr = [formatter stringFromDate:[NSDate date]];
        } else {
            if([proTitleList count] > 0) {
                selectedStr = proTitleList[0];
            }
        }
       
    }
    
    if (isDate == NO) {
        NSString *type = @"";

        if ([selectedStr isEqualToString:@"执业律师"])
        {
            type = @"1";
        }else if ([selectedStr isEqualToString:@"实习律师"]){
            type = @"2";
        }else if ([selectedStr isEqualToString:@"公司法务"]){
            type = @"3";
        }else if ([selectedStr isEqualToString:@"法律专业学生"]){
            type = @"4";
        }else if ([selectedStr isEqualToString:@"公务员"]){
            type = @"5";
        }else if ([selectedStr isEqualToString:@"其他"]){
            type = @"9";
        }
        DLog(@"选中----%@",selectedStr);
        block(selectedStr,type);
    }else{
        self.alertBlock(selectedStr);
    }
    
    [self hide];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    
    return [proTitleList count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    selectedStr = [proTitleList objectAtIndex:row];
    
}
/************************重头戏来了************************/

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREENSIZE.width, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text =[proTitleList objectAtIndex:row];
    [myView setFont:Font_15];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [proTitleList objectAtIndex:row];
//
//}
- (UIColor *)getColor:(NSString*)hexColor

{
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}

- (CGSize)workOutSizeWithStr:(NSString *)str andFont:(NSInteger)fontSize value:(NSValue *)value{
    CGSize size;
    if (str) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    }
    return size;
}
@end

