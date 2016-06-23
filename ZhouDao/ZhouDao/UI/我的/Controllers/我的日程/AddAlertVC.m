//
//  AddAlertVC.m
//  ZhouDao
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddAlertVC.h"
#import "ZHPickView.h"
#import "RemindSoundVCr.h"

static NSString *const cellIdentifer = @"cellIdentifer";

@interface AddAlertVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSString *_labStr;
    NSString *_dateStr;
    NSString *_repeatStr;
    NSString *_soundStr;
    NSString *_tureSound;
}

@property (nonatomic, copy)NSString  *timeStr;
@property (nonatomic, copy)NSString  *yearStr;
@property (nonatomic, strong) NSArray *titleArrays;
@property (nonatomic,strong) NSMutableArray *msgArrays;


@end

@implementation AddAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    self.view.backgroundColor = ViewBackColor;
    [self addUIDatepicker];
    [self setupNaviBarWithTitle:@"添加提醒"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"取消" img:nil];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"完成" img:nil];
    self.leftBtn.titleLabel.font = Font_15;
    self.rightBtn.titleLabel.font = Font_15;
    
    _titleArrays = [NSArray arrayWithObjects:@"提醒标签",@"提醒日期",@"重  复",@"铃声选择",@"提醒方式", nil];
    
    if (_alertType == FromAddBtn) {
        NSDate *tomDay = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *tomDayString = [formatter stringFromDate:tomDay];
        _yearStr = tomDayString;
        _repeatStr = @"永不";
        _labStr = @"自定义";
        _soundStr = @"系统音效";
        _msgArrays = [NSMutableArray arrayWithObjects:tomDayString,_repeatStr,_soundStr, nil];

    }else{
        _labStr = _dataModel.title;
        _yearStr = [self changeTime:[_dataModel.time doubleValue]];
        switch ([_dataModel.repeat_time integerValue]) {
            case 1:
            {
                _repeatStr = @"永不";
            }
                break;
            case 2:
            {
                _repeatStr = @"每日";
            }
                break;
            case 3:
            {
                _repeatStr = @"每月";
            }
                break;
            case 4:
            {
                _repeatStr = @"每月";
            }
                break;
            default:
                break;
        }
        
        if ([_dataModel.bell isEqualToString:@"1"]) {
            _soundStr = @"系统音效";
        }else if ([_dataModel.bell isEqualToString:@"2"]){
            _soundStr = @"合同到期(女声)";
        }else if ([_dataModel.bell isEqualToString:@"3"]){
            _soundStr = @"开会提醒(女声)";
        }else if ([_dataModel.bell isEqualToString:@"4"]){
            _soundStr = @"开庭提醒(女声)";
        }else if ([_dataModel.bell isEqualToString:@"5"]){
            _soundStr = @"合同到期(男声)";
        }else if ([_dataModel.bell isEqualToString:@"6"]){
            _soundStr = @"开会提醒(男声)";
        }else {
            _soundStr = @"开庭提醒(男声)";
        }
        _msgArrays = [NSMutableArray arrayWithObjects:_yearStr,_repeatStr,_soundStr, nil];
    }
    
    //表
    CGRect frame ;
    if (kMainScreenHeight >480) {
       frame = CGRectMake(0, 320, kMainScreenWidth, 225);
    }else{
        frame = CGRectMake(0, 320, kMainScreenWidth, 160);
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifer];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = Font_15;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = thirdColor;
    cell.textLabel.text = _titleArrays[indexPath.row];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kMainScreenWidth, .5f)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    [cell.contentView addSubview:line];
    
    NSUInteger row = indexPath.row;
    
    if (row == 0) {
        UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(kMainScreenWidth -230, 12, 200, 20)];
        textF.tag = 5000;
        textF.backgroundColor = [UIColor clearColor];
        textF.borderStyle = UITextBorderStyleNone;
        textF.textAlignment = NSTextAlignmentRight;
        textF.font = Font_14;
        textF.placeholder = @"自定义";
        //[textF setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:Font_14 forKeyPath:@"_placeholderLabel.font"];
        [textF setTextColor:sixColor];
        
        if (_alertType == FromEditBtn ) {
            textF.text = _labStr;
        }
        
        textF.delegate = self;
        [cell.contentView addSubview:textF];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:textF];
    }else if (row == 4){
        
//        NSDictionary *attribute = @{NSFontAttributeName:Font_14};
//        CGSize size = [@"当日无日程，" boundingRectWithSize:CGSizeMake(300,MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        DLog(@"大小－－－－－－%f",size.width);
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -196, 7, 76, 15)];
        lab.textColor = sixColor;
        [lab setText:@"默认两种方式:"];
        lab.font = Font_12;
        lab.numberOfLines = 1;
        [cell.contentView addSubview:lab];
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -120, 7, 90, 15)];
        lab1.textColor = sixColor;
        [lab1 setText:@"1、消息推送提醒"];
        lab1.font = Font_12;
        lab1.numberOfLines = 1;
        [cell.contentView addSubview:lab1];

        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -120, 22, 68, 15)];
        lab2.textColor = sixColor;
        [lab2 setText:@"2、短信提醒"];
        lab2.font = Font_12;
        lab2.numberOfLines = 1;
        [cell.contentView addSubview:lab2];
        
    }else{
        UILabel *removeLab = (UILabel *)[tableView viewWithTag:indexPath.row + 8000];
        [removeLab removeFromSuperview];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -230, 12, 200, 20)];
        lab.tag = indexPath.row + 8000;
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
        [lab setText:_msgArrays[row - 1]];
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = Font_12;
        lab.numberOfLines = 0;
        [cell.contentView addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;

    WEAKSELF;
    if (row == 1)
    {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showPickView:self];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            [weakSelf.msgArrays replaceObjectAtIndex:0 withObject:selectedStr];
            _yearStr = selectedStr;
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            DLog(@"时间是－－－－%@",selectedStr);
        };
    }else if (row == 2)
    {
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"永不",@"每日",@"每周",@"每月"] title:@"重复"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            [weakSelf.msgArrays replaceObjectAtIndex:1 withObject:selectedStr];
            _repeatStr = selectedStr;
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        
    }else if (row == 3)
    {
        RemindSoundVCr *remindVC = [RemindSoundVCr new];
        remindVC.stringBlock = ^(NSString *bellName){
            [weakSelf.msgArrays replaceObjectAtIndex:2 withObject:bellName];
            _soundStr = bellName;
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:remindVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        //SHOW_ALERT(@"不能输入表情!");
        textField.text = [NSString disable_emoji:textField.text];
    }
    _labStr = textField.text;
}
- (void)addUIDatepicker
{
    // 1.日期Picker
    UIDatePicker *datePickr = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 216)];
    datePickr.backgroundColor = [UIColor whiteColor];
    [datePickr setDatePickerMode:UIDatePickerModeTime];
    if (_alertType == FromEditBtn) {
        datePickr.date =  [QZManager timeStampChangeNSDate:[_dataModel.time doubleValue]];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateFormat:@"HH:mm"];
        _timeStr = [formatter stringFromDate:datePickr.date];
    }
    
    [self.view addSubview:datePickr];
    [datePickr setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [self.view addSubview:datePickr];
    [datePickr addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}
#pragma mark DatePicker监听方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    [self dismissKeyBoard];
    // 1.要转换日期格式, 必须得用到NSDateFormatter, 专门用来转换日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 1.1 先设置日期的格式字符串
    [formatter setDateFormat:@"HH:mm"];
    _timeStr = [formatter stringFromDate:datePicker.date];
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    if (_timeStr.length == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateFormat:@"HH:mm"];
        _timeStr = [formatter stringFromDate:[NSDate date]];
    }
    _dateStr = [NSString stringWithFormat:@"%@ %@",_yearStr,_timeStr];
    NSDate *fireDate = [self dateFromString:_dateStr];
    
    if (_alertType == FromAddBtn) {
        //比较时间
        if ([QZManager compareOneDay:[NSDate date] withAnotherDay:fireDate] == 1)
        {
            [JKPromptView showWithImageName:nil message:@"请您检查设置时间!"];
            return;
        }
    }
    //判断重复时间
    NSCalendarUnit repeatInterval = 0;
    NSString *repeatCount = @"1";
    if ([_repeatStr isEqualToString:@"每日"]) {
        repeatInterval = 3;
        repeatCount = @"2";
    }else if ([_repeatStr isEqualToString:@"每周"]){
        repeatInterval = 7;
        repeatCount = @"3";
    }else if ([_repeatStr isEqualToString:@"每月"]){
        repeatInterval = 2;
        repeatCount = @"4";
    }else{
        repeatInterval = 0;
        repeatCount = @"1";
    }
    //    NSUInteger notificationCount = [[[JRNLocalNotificationCenter defaultCenter] localNotifications] count];
    // 设置通知的id，可用于通知移除，也可以传递其他值，当通知触发时可以获取
    // 需要在App icon上显示的未读通知数（设置为1时，多个通知未读，系统会自动加1，如果不需要显示未读数，这里可以设置0）
//    [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1
    NSString *bellName = nil;
    if ([_soundStr isEqualToString:@"系统音效"]) {
        bellName = @"1";
        _tureSound = @"defaultSound";
    }else if ([_soundStr isEqualToString:@"合同到期(女声)"]){
        bellName = @"2";
        _tureSound = @"woman_contract";
    }else if ([_soundStr isEqualToString:@"开会提醒(女声)"]){
        bellName = @"3";
        _tureSound = @"woman_meeting";
    }else if ([_soundStr isEqualToString:@"开庭提醒(女声)"]){
        bellName = @"4";
        _tureSound = @"woman_court";
    }else if ([_soundStr isEqualToString:@"合同到期(男声)"]){
        bellName = @"5";
        _tureSound = @"man_contract";
    }else if ([_soundStr isEqualToString:@"开会提醒(男声)"]){
        bellName = @"6";
        _tureSound = @"man_meeting";
    }else{
        bellName = @"7";
        _tureSound = @"man_court";
    }
    
    NSString *timeSJC = [NSString stringWithFormat:@"%ld",(long)[fireDate timeIntervalSince1970]];
    WEAKSELF;
    if (_alertType == FromAddBtn ) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_labStr,@"title",_labStr,@"content",repeatCount,@"repeat",timeSJC,@"time",bellName,@"bell",UID,@"uid", nil];
        
        [NetWorkMangerTools addRemindMySchedule:dict RequestSuccess:^(NSString *idStr) {
            weakSelf.successBlock(fireDate, timeSJC);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }else{
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_labStr,@"title",_labStr,@"content",repeatCount,@"repeat",timeSJC,@"time",bellName,@"bell",UID,@"uid",_dataModel.id,@"id", nil];
        
        [NetWorkMangerTools editRemindMySchedule:dict RequestSuccess:^{

            weakSelf.successBlock(fireDate, timeSJC);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }

}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissKeyBoard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -输入的日期字符串形如：@"1992-05-21 13:08"
- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:destDate];
//    NSDate *localeDate = [destDate  dateByAddingTimeInterval: interval];
    return destDate;
}
- (NSString *)changeTime:(NSTimeInterval)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
