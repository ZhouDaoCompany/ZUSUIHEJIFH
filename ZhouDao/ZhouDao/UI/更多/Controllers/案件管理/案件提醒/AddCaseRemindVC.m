//
//  AddCaseRemindVC.m
//  ZhouDao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AddCaseRemindVC.h"
#import "ZHPickView.h"
#import "RemindSoundVCr.h"
#import "AddRemindCell.h"
#import "RemarkTabCell.h"
#import "DateTimeView.h"

static NSString *const CELLIDONE = @"CELLIDONE";
static NSString *const CELLIDTWO = @"CELLIDTWO";

@interface AddCaseRemindVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITapGestureRecognizer * _tapGesture;

    BOOL _isEdit;
    NSString *_timeStrng;
}

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong)  NSArray *titArrays;//标题数组
@property (nonatomic, strong)  NSMutableArray *commitArr;//存放内容数组

@end

@implementation AddCaseRemindVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    _titArrays  = [NSArray arrayWithObjects:@"提醒标签",@"提醒类别",@"提醒时间",@"重复",@"提醒铃声", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [ self.view addSubview:_tableView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];


    if (_remindType == EditRemind) {
        [self setupNaviBarWithTitle:@"案件提醒编辑"];
        NSString *remind = [self getRemindType:_dataModel.bell];
        NSString *bell = [self getBellName:_dataModel.bell];
        NSString *repeatS = [self getRepeatType:_dataModel.repeat_time];
        _commitArr  = [NSMutableArray arrayWithObjects:_dataModel.title,remind,_dataModel.time,repeatS,bell,_dataModel.content, nil];

        _tableView.tableFooterView = [self creatTabFootView];

    }else if (_remindType == DetailRemind){
        
        [self setupNaviBarWithBtn:NaviRightBtn
                            title:@"编辑" img:nil];
        [self setupNaviBarWithTitle:@"案件提醒详情"];

        NSString *remind = [self getRemindType:_dataModel.bell];
        NSString *bell = [self getBellName:_dataModel.bell];
        NSString *repeatS = [self getRepeatType:_dataModel.repeat_time];
        _commitArr  = [NSMutableArray arrayWithObjects:_dataModel.title,remind,_dataModel.time,repeatS,bell,_dataModel.content, nil];

    }else {
        [self setupNaviBarWithTitle:@"案件提醒添加"];
        _commitArr  = [NSMutableArray arrayWithObjects:@"",@"开庭提醒",@"",@"永不",@"系统音效",@"", nil];
        _tableView.tableFooterView = [self creatTabFootView];

    }
    

}
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSInteger row = indexPath.row;
    
    if (row <5) {
        [tableView registerClass:[AddRemindCell class] forCellReuseIdentifier:CELLIDONE];
        AddRemindCell *cell = (AddRemindCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDONE];
        
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;

        }else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        return cell;
    }
    
    [tableView registerClass:[RemarkTabCell class] forCellReuseIdentifier:CELLIDTWO];
    RemarkTabCell *cell = (RemarkTabCell *)[tableView dequeueReusableCellWithIdentifier:CELLIDTWO forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if ([cell isKindOfClass:[AddRemindCell class]]) {
        AddRemindCell *aCell = (AddRemindCell *)cell;
        aCell.rowIndex = row;
        aCell.titleLab.text = _titArrays[row];
        if (row == 0) {
            
            if (_remindType == DetailRemind && _isEdit == NO) {
                aCell.textField.enabled = NO;
            }else {
                aCell.textField.enabled = YES;
            }
            aCell.textField.delegate = self;
            aCell.textField.text = _commitArr[row];
            [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:aCell.textField];

        }else if (row == 2){
            
            NSString *text = _commitArr[row];
            
            if (text.length == 0) {
                
            }else{
                text = [QZManager changeTimeMethods:[text doubleValue] withType:@"yyyy-MM-dd HH:mm"];
            }
            
            aCell.contentLab.text = text;

        }else{
            aCell.contentLab.text = _commitArr[row];
        }
        
        [aCell settingFrame];

    }else if ([cell isKindOfClass:[RemarkTabCell class]]){
        RemarkTabCell *rCell = (RemarkTabCell *)cell;

        if (row == 5) {
            rCell.textView.hidden = NO;
            rCell.titLab.hidden = NO;
            rCell.placeHoldlab.hidden = NO;

            rCell.titLab.text = @"提醒备注";
            rCell.titLab.font = Font_14;
            rCell.textView.delegate = self;
            rCell.textView.text = _commitArr[row];
            
            if (_remindType == DetailRemind && _isEdit == NO) {
                rCell.textView.editable = NO;
            }else {
                rCell.textView.editable = YES;
            }

            if (rCell.textView.text.length >0) {
                rCell.placeHoldlab.text = @"";
            }else {
                rCell.placeHoldlab.text = @" 写备注...";
            }
            
        }else {
            rCell.backgroundColor = [UIColor clearColor];
            rCell.textView.hidden = YES;
            rCell.titLab.hidden = YES;
            rCell.placeHoldlab.hidden = YES;

            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 15)];
            lab.textColor = SIXCOLOR;
            [lab setText:@"注:提醒方式,默认两种方式:"];
            lab.font = Font_14;
            lab.numberOfLines = 1;
            [cell.contentView addSubview:lab];
            
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -120, 10, 90, 15)];
            lab1.textColor = SIXCOLOR;
            [lab1 setText:@"1、消息推送提醒"];
            lab1.font = Font_12;
            lab1.numberOfLines = 1;
            [cell.contentView addSubview:lab1];
            
            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth -120, 25, 68, 15)];
            lab2.textColor = SIXCOLOR;
            [lab2 setText:@"2、短信提醒"];
            lab2.font = Font_12;
            lab2.numberOfLines = 1;
            [cell.contentView addSubview:lab2];

        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    
    if (_remindType == DetailRemind && _isEdit == NO) {
        
        return;
    }
    
    NSInteger row = indexPath.row;
    
    if (row == 2) {
        UIWindow *windows = [QZManager getWindow];
        DateTimeView *timeView = [[DateTimeView alloc] initWithFrame:kMainScreenFrameRect];
        timeView.timeBlock = ^(NSString *timeS,NSString *sjcStr){
            
            _timeStrng = sjcStr;
            [weakSelf.commitArr replaceObjectAtIndex:row withObject:sjcStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [windows addSubview:timeView];
    }else if (row == 1){
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"开庭提醒",@"拜访提醒",@"续约提醒",@"上诉期提醒",@"诉讼时效提醒",@"到期提醒",@"其他提醒"] title:@"提醒类别"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            [weakSelf.commitArr replaceObjectAtIndex:row withObject:selectedStr];
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if (row == 3){
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"永不",@"每日",@"每周",@"每月"] title:@"重复"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            [weakSelf.commitArr replaceObjectAtIndex:row withObject:selectedStr];
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
    }else if (row == 4){
        RemindSoundVCr *remindVC = [RemindSoundVCr new];
        remindVC.stringBlock = ^(NSString *bellName){
            [weakSelf.commitArr replaceObjectAtIndex:row withObject:bellName];
            [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:remindVC animated:YES];

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 115.f;
    }
    return 45.f;
}
- (UIView *)creatTabFootView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 108)];
    footView.backgroundColor = ViewBackColor;
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = KNavigationBarColor;
    commitBtn.titleLabel.font = Font_15;
    commitBtn.frame = CGRectMake(15.f, 34.f, kMainScreenWidth -30.f , 40);
    [commitBtn setTitle:@"提交" forState:0];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 3.f;
    [commitBtn addTarget:self action:@selector(commitRemindEvent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBtn];
    return footView;
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    [_commitArr replaceObjectAtIndex:0 withObject:textField.text];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [textView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *placeHoldlab = (UILabel *)obj;
            if (textView.text.length >0) {
                placeHoldlab.text = @"";
            }else {
                placeHoldlab.text = @" 写备注...";
            }
        }
    }];
    
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
    if (flag){
        textView.text = [NSString disable_emoji:textView.text];
    }
    
    [_commitArr replaceObjectAtIndex:5  withObject:textView.text];
}
#pragma mark - event respose
- (void)rightBtnAction
{
    
    if ([self.rightBtn.titleLabel.text isEqualToString:@"完成"])
    {
        [self commitRemindEvent];//提交
    }
    
    _isEdit = YES;
    _tableView.tableFooterView = [self creatTabFootView];
    [_tableView reloadData];
    [self.rightBtn setTitle:@"完成" forState:0];
    [self setupNaviBarWithTitle:@"案件提醒编辑"];

}
- (void)commitRemindEvent
{WEAKSELF;
    
    __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(_caseId) forKey:@"arrange_id"];
    
    NSArray *paraArr = [NSArray arrayWithObjects:@"title",@"type",@"time",@"repeat",@"bell",@"content", nil];
    __block BOOL isReturn = NO;
    __block NSInteger index = 0;
    [_commitArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.length == 0 && idx !=5) {
            *stop = YES;
            isReturn = YES;
            index = idx;
            return ;
        }
        
        if (idx == 1) {
            NSString *type = [weakSelf getRemindTypeWithTit:obj];
            [msgDic setObjectWithNullValidate:GET(type) forKey:paraArr[idx]];
        }else if (idx == 3) {
            NSString *repeatS = [weakSelf getRepeatTypeWithRepeat:obj];
            [msgDic setObjectWithNullValidate:GET(repeatS) forKey:paraArr[idx]];
            
        }else if (idx == 4) {
            NSString *bell = [weakSelf getBellNameWithBell:obj];
            [msgDic setObjectWithNullValidate:GET(bell) forKey:paraArr[idx]];

        }else{
            [msgDic setObjectWithNullValidate:GET(obj) forKey:paraArr[idx]];
        }
    }];
    
    
    if (isReturn == YES) {
        switch (index) {
            case 0:
            {
                [JKPromptView showWithImageName:nil message:LOCALERTLABEL];
            }
                break;
            case 1:
            {
                [JKPromptView showWithImageName:nil message:LOCALERTTYPE];
            }
                break;
            case 2:
            {
                [JKPromptView showWithImageName:nil message:LOCSELECTTIME];
            }
                break;
            case 5:
            {
//                [JKPromptView showWithImageName:nil message:@"请您填写备注"];
            }
                break;

            default:
                break;
        }
        
        return;
    }
    
    if (_remindType == AddRemind) {
        
        NSString *timeStr = [QZManager changeTimeMethods:[_commitArr[2] doubleValue] withType:@"yyyy-MM-dd HH:mm"];
        NSDate *fireDate = [self dateFromString:timeStr];
        //比较时间
        if ([QZManager compareOneDay:[NSDate date] withAnotherDay:fireDate] == 1)
        {
            [JKPromptView showWithImageName:nil message:LOCDATESET];
            return;
        }
        
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeRemindAdd] RequestSuccess:^{
            
            weakSelf.addSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }else {
        
        [msgDic setObjectWithNullValidate:GET(_dataModel.id) forKey:@"id"];
        
        [NetWorkMangerTools editRemindMySchedule:msgDic RequestSuccess:^{
            
            weakSelf.addSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }

}

- (NSString *)getRemindTypeWithTit:(NSString *)str
{
    NSString *type = @"";
    if ([type isEqualToString:@"开庭提醒"]){
        type = @"2";
    }else  if ([type isEqualToString:@"拜访提醒"]) {
        type = @"3";
    }else if ([type isEqualToString:@"续约提醒"]){
        type = @"4";
    }else if ([type isEqualToString:@"上诉期提醒"]){
        type = @"5";
    }else if ([type isEqualToString:@"诉讼时效提醒"]){
        type = @"6";
    }else if ([type isEqualToString:@"到期提醒"]){
        type = @"7";
    }else {
        type = @"9";
    }
    return type;
}

- (NSString *)getRemindType:(NSString *)str
{
    NSString *type = @"";
    
    if ([type isEqualToString:@"2"]){
        type = @"开庭提醒";
    }else  if ([type isEqualToString:@"3"]) {
        type = @"拜访提醒";
    }else if ([type isEqualToString:@"4"]){
        type = @"续约提醒";
    }else if ([type isEqualToString:@"5"]){
        type = @"上诉期提醒";
    }else if ([type isEqualToString:@"6"]){
        type = @"诉讼时效提醒";
    }else if ([type isEqualToString:@"7"]){
        type = @"到期提醒";
    }else {
        type = @"其他提醒";
    }
    
    return type;
}

- (NSString *)getBellNameWithBell:(NSString *)str
{
    NSString *bellName = nil;
    if ([str isEqualToString:@"系统音效"]) {
        bellName = @"1";
    }else if ([str isEqualToString:@"合同到期(女声)"]){
        bellName = @"2";
    }else if ([str isEqualToString:@"开会提醒(女声)"]){
        bellName = @"3";
    }else if ([str isEqualToString:@"开庭提醒(女声)"]){
        bellName = @"4";
    }else if ([str isEqualToString:@"合同到期(男声)"]){
        bellName = @"5";
    }else if ([str isEqualToString:@"开会提醒(男声)"]){
        bellName = @"6";
    }else{
        bellName = @"7";
    }
    return bellName;
}
- (NSString *)getBellName:(NSString *)str
{
    NSString *bellName = nil;
    if ([str isEqualToString:@"1"]) {
        bellName = @"系统音效";
    }else if ([str isEqualToString:@"2"]){
        bellName = @"合同到期(女声)";
    }else if ([str isEqualToString:@"3"]){
        bellName = @"开会提醒(女声)";
    }else if ([str isEqualToString:@"4"]){
        bellName = @"开庭提醒(女声)";
    }else if ([str isEqualToString:@"5"]){
        bellName = @"合同到期(男声)";
    }else if ([str isEqualToString:@"6"]){
        bellName = @"开会提醒(男声)";
    }else{
        bellName = @"开庭提醒(男声)";
    }
    
    return bellName;
}

- (NSString *)getRepeatTypeWithRepeat:(NSString *)str
{
    NSString *repeatCount = @"1";
    if ([str isEqualToString:@"每日"]) {
        repeatCount = @"2";
    }else if ([str isEqualToString:@"每周"]){
        repeatCount = @"3";
    }else if ([str isEqualToString:@"每月"]){
        repeatCount = @"4";
    }else{
        repeatCount = @"1";
    }
    return repeatCount;
}
- (NSString *)getRepeatType:(NSString *)str
{
    NSString *repeatCount = @"永不";
    if ([str isEqualToString:@"2"]) {
        repeatCount = @"每日";
    }else if ([str isEqualToString:@"3"]){
        repeatCount = @"每周";
    }else if ([str isEqualToString:@"4"]){
        repeatCount = @"每月";
    }else{
        repeatCount = @"永不";
    }
    return repeatCount;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
