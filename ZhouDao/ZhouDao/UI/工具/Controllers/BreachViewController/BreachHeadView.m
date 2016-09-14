//
//  BreachHeadView.m
//  ZhouDao
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BreachHeadView.h"

@interface BreachHeadView()

@end

@implementation BreachHeadView

- (id)initWithFrame:(CGRect)frame WithMoney:(NSString *)moneyString withDate:(NSString *)dateString withRate:(NSString *)rateString
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = hexColor(FFFFFF);
        [self initUIWithMoney:moneyString withDate:dateString withRate:rateString];
    }
    return self;
}
#pragma mark -  methods
- (void)initUIWithMoney:(NSString *)moneyString withDate:(NSString *)dateString withRate:(NSString *)rateString
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f)];
    view1.backgroundColor = LRRGBColor(0, 182, 156);
    [self addSubview:view1];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5f, 93, 30)];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:11.f];
    lab1.textColor = hexColor(FFFFFF);
    lab1.numberOfLines = 0;
    lab1.text = [NSString stringWithFormat:@"金额\n%@",moneyString];
    [view1 addSubview:lab1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lab1), 10, .6f, 25)];
    lineView1.backgroundColor = hexColor(FFFFFF);
    [view1 addSubview:lineView1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineView1), 7.5f, kMainScreenWidth - 187.2f, 30)];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:11.f];
    lab2.textColor = hexColor(FFFFFF);
    lab2.numberOfLines = 0;
    lab2.text = [NSString stringWithFormat:@"日期\n%@",dateString];
    [view1 addSubview:lab2];

    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(Orgin_x(lab2), 10, .6f, 25)];
    lineView2.backgroundColor = hexColor(FFFFFF);
    [view1 addSubview:lineView2];

    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lineView2), 7.5f, 93.f, 30)];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont systemFontOfSize:11.f];
    lab3.textColor = hexColor(FFFFFF);
    lab3.numberOfLines = 0;
    lab3.text = [NSString stringWithFormat:@"利率\n%@",rateString];
    [view1 addSubview:lab3];
    
    UILabel * lab4 = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 105, 20)];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.font = [UIFont systemFontOfSize:12.f];
    lab4.textColor = hexColor(000000);
    lab4.text = @"起止时间(年/月/日)";
    [self addSubview:lab4];

    float width = (kMainScreenWidth - 145.f)/3.f;
    
    UILabel * lab5 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab4) + 10, 50, width, 20)];
    lab5.textAlignment = NSTextAlignmentCenter;
    lab5.font = [UIFont systemFontOfSize:12.f];
    lab5.textColor = hexColor(000000);
    lab5.text = @"天数";
    [self addSubview:lab5];

    UILabel * lab6 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab5) + 5, 50, width+10, 20)];
    lab6.textAlignment = NSTextAlignmentCenter;
    lab6.font = [UIFont systemFontOfSize:12.f];
    lab6.textColor = hexColor(000000);
    lab6.text = @"基准利率(%)";
    [self addSubview:lab6];

    UILabel * lab7 = [[UILabel alloc] initWithFrame:CGRectMake(Orgin_x(lab6) + 5, 50, width, 20)];
    lab7.textAlignment = NSTextAlignmentCenter;
    lab7.font = [UIFont systemFontOfSize:12.f];
    lab7.textColor = hexColor(000000);
    lab7.text = @"金额(元)";
    [self addSubview:lab7];

}
#pragma mark - setter and getter

@end
