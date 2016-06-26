//
//  ConsultantTabVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "ConsultantTabVC.h"
#import "ConsultantCell.h"
#import "ZHPickView.h"
#import "ZD_DeleteWindow.h"
#import "ConsultantHeadView.h"

static NSString *const ConsultantIDENTIFER = @"ConsultantIDENTIFER";


@interface ConsultantTabVC ()<UITextFieldDelegate>
{
    UITapGestureRecognizer * _tapGesture;
    NSString *_sign_time;
}
@property (strong, nonatomic) NSMutableArray *titleArrays;//标题
@property (strong, nonatomic) NSMutableArray *textArr;//内容
@property (strong, nonatomic) NSMutableArray *placeHoldArr;
@property (strong, nonatomic) UISwitch *switchButton;

@end

@implementation ConsultantTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}
- (void)initUI{
    NSArray *placeOneArr = [NSArray arrayWithObjects:@"请输入委托人",@"",@"",@"", nil];
    NSArray *placeTwoArr = [NSArray arrayWithObjects:@"请输入法定代表人",@"请输入公司地址",@"请输入主营业务",@"请输入股东情况",@"请输入联系人",@"请输入联系电话",@"请输入联系邮箱", nil];

    _placeHoldArr = [NSMutableArray arrayWithObjects:placeOneArr,placeTwoArr, nil];

    NSArray *oneArr = [NSArray arrayWithObjects:@"委托人或公司",@"合同签约时间",@"合同签约年限",@"是否开启到期提醒", nil];
    NSArray *twoArr = [NSArray arrayWithObjects:@"法定代表人",@"公司地址",@"主营业务",@"股东情况",@"联系人",@"联系电话",@"联系邮箱", nil];
    _titleArrays = [NSMutableArray arrayWithObjects:oneArr,twoArr, nil];
    
    if (_ConType == ConFromManager) {
        NSMutableArray *oneTextArr = [NSMutableArray array];
        NSMutableArray *twoTextArr = [NSMutableArray array];
        [_msgArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx >0) {
                (idx <5)?[oneTextArr addObject:obj]:[twoTextArr addObject:obj];
            }
        }];
        _textArr = [NSMutableArray arrayWithObjects:oneTextArr,twoTextArr, nil];

    }else{
        NSMutableArray *oneTextArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        NSMutableArray *twoTextArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
        _textArr = [NSMutableArray arrayWithObjects:oneTextArr,twoTextArr, nil];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[ConsultantCell class] forCellReuseIdentifier:ConsultantIDENTIFER];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 108)];
    footView.backgroundColor = ViewBackColor;
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = KNavigationBarColor;
    commitBtn.titleLabel.font = Font_15;
    commitBtn.frame = CGRectMake(15.f, 34.f, kMainScreenWidth -30.f , 40);
    [commitBtn setTitle:@"提交" forState:0];
    commitBtn.layer.masksToBounds = YES;
    commitBtn.layer.cornerRadius = 3.f;
    [commitBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBtn];
    
    self.tableView.tableFooterView = footView;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_titleArrays[section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f)];
    if (section ==0) {
        [headView setLabelText:@"基本信息"];
    }else{
        [headView setLabelText:@"委托人信息"];
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ConsultantCell *cell = (ConsultantCell *)[tableView dequeueReusableCellWithIdentifier:ConsultantIDENTIFER];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[ConsultantCell class]])
    {
        ConsultantCell *cCell = (ConsultantCell *)cell;
        NSUInteger row = indexPath.row;
        NSUInteger section = indexPath.section;
        cCell.rowIndex = row;
        cCell.sectionIndex = section;
        
        
        if (_titleArrays.count >0) {
            cCell.titleLab.text = _titleArrays[section][row];
        }
        
        if ((section ==0 && row == 1) || (section ==0 && row == 2))
        {
            cCell.deviceLabel.text = _textArr[section][row];
            
        }else if (section == 0 && row == 3){
            if (_switchButton == nil) {
                _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(kMainScreenWidth-65.f, 10, 0, 30)];
                [_switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                _switchButton.onTintColor = KNavigationBarColor;
                _switchButton.tag = 999;
                [cCell.contentView addSubview:_switchButton];
            }

        }else{
            if (section == 0) {
                cCell.textField.tag = 7999;
            }else{
                cCell.textField.tag = 8000+row;
            }

            cCell.textField.delegate = self;
            cCell.textField.placeholder = _placeHoldArr[section][row];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cCell.textField];
            cCell.textField.text = _textArr[section][row];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    WEAKSELF;
    UIWindow *windows = [QZManager getWindow];

    if (section ==0 && row == 1){
    
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDateViewWithTitle:@"选择时间"];
        [pickView showWindowPickView:windows];
        pickView.alertBlock = ^(NSString *selectedStr)
        {
            _sign_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
            [weakSelf.textArr[0] replaceObjectAtIndex:1 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };

    }else if(section ==0 && row == 2){
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"1年",@"2年",@"3年",@"4年",@"5年"] title:@"选择年限"];
        [pickView showWindowPickView:windows];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            [weakSelf.textArr[0] replaceObjectAtIndex:2 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        };

    }
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
    NSUInteger tag = textField.tag;
    
    if (tag == 7999) {
        [_textArr[0] replaceObjectAtIndex:0 withObject:textField.text];
    }else{
        [_textArr[1] replaceObjectAtIndex:tag-8000 withObject:textField.text];
    }
}

#pragma mark -UIButtonEvent
- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButton = [switchButton isOn];
    
    if (isButton) {
        DLog(@"open");
        ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"合同快到期时,将以短信的方式提醒您" withType:DelType];
        delWindow.DelBlock = ^(){
            
        };
        [self.view.superview.superview addSubview:delWindow];

        [_textArr[0] replaceObjectAtIndex:3 withObject:@"1"];

    }else{
        DLog(@"close");
        [_textArr[0] replaceObjectAtIndex:3 withObject:@"0"];
    }
    
}

- (void)commitEvent:(id)sender
{WEAKSELF;
    DLog(@"提交");
   __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"3") forKey:@"type"];

    NSArray *oneArr = [NSMutableArray arrayWithObjects:@"client",@"sign_time",@"sign_year",@"is_remind", nil];
    NSMutableArray *twoArr = [NSMutableArray arrayWithObjects:@"deputy",@"address",@"business",@"partner",@"contacts",@"phone",@"mail", nil];
    __block NSMutableArray *paraArr = [NSMutableArray arrayWithObjects:oneArr,twoArr, nil];
    
    [_textArr enumerateObjectsUsingBlock:^(NSArray *objArr, NSUInteger count, BOOL * _Nonnull stop) {
        if (count == 0) {
            [objArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    if (obj.length == 0) {
                        [JKPromptView showWithImageName:nil message:@"请您填写案件名称"];
                        return ;
                    }
                    [msgDic setObjectWithNullValidate:GET(obj) forKey:@"client"];
                    [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];
                }else if (idx == 1){
                    if (obj.length == 0) {
                        [JKPromptView showWithImageName:nil message:@"请您选择收案日期"];
                        return ;
                    }
                    [msgDic setObjectWithNullValidate:GET(_sign_time) forKey:@"start_time"];
                    [msgDic setObjectWithNullValidate:GET(_sign_time) forKey:@"sign_time"];
                }else if (idx == 2){
                    if (obj.length == 0) {
                        [JKPromptView showWithImageName:nil message:@"请您选择合同年限"];
                        return ;
                    }
                    NSString *endString = [weakSelf ConvertTheDate:obj];
                    [msgDic setObjectWithNullValidate:obj forKey:@"sign_year"];
                    [msgDic setObjectWithNullValidate:GET(endString) forKey:@"end_time"];
                    ([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[endString doubleValue]] withDateFormat:@"yyyy-MM-dd"] ==1)?[msgDic setObjectWithNullValidate:@"2" forKey:@"state"]:[msgDic setObjectWithNullValidate:@"1" forKey:@"state"];

                }else {
                    [msgDic setObjectWithNullValidate:GET(obj) forKey:@"is_remind"];
                }
            }];
        }else{
            NSArray *keyArrays = paraArr[count];
            [objArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *keyS = keyArrays[idx];
                [msgDic setObjectWithNullValidate:GET(obj) forKey:keyS];
            }];
        }
    }];
    
    if (_ConType == ConFromManager) {
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{
           __block NSMutableArray *tempArr = [NSMutableArray array];
            [weakSelf.textArr enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj enumerateObjectsUsingBlock:^(NSString *str, NSUInteger tidx, BOOL * _Nonnull stop) {
                    if (idx == 0 && tidx ==0) {
                        [tempArr addObject:str];
                        [tempArr addObject:str];
                    }else{
                        [tempArr addObject:str];
                    }
                }];
            }];
            weakSelf.editSuccess(tempArr);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }else{
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeAdd] RequestSuccess:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }

}

- (NSString *)ConvertTheDate:(NSString *)year
{
    NSTimeInterval time;
    if ([year isEqualToString:@"1年"]) {
         time = 365 * 24 * 60 * 60;//一年的秒数
    }else if ([year isEqualToString:@"2年"]){
         time = 2 * 365 * 24 * 60 * 60;//2年的秒数
    }else if ([year isEqualToString:@"3年"]){
        time = 3 * 365 * 24 * 60 * 60;//3年的秒数
    }else if ([year isEqualToString:@"4年"]){
        time = 4 * 365 * 24 * 60 * 60;//4年的秒数
    }else{
        time = 5 * 365 * 24 * 60 * 60;//5年的秒数
    }
    
    NSDate * endDate = [[QZManager timeStampChangeNSDate:[_sign_time doubleValue]] dateByAddingTimeInterval:time];
    
    NSString *endString = [NSString stringWithFormat:@"%ld",(long)[endDate timeIntervalSince1970]];
    
    return endString;
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
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
