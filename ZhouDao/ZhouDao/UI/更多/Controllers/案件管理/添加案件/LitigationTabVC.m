//
//  LitigationTabVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LitigationTabVC.h"
#import "LitigationCell.h"
#import "ZHPickView.h"
#import "DateTimeView.h"

static NSString *const litigationIDENTIFER = @"litigationIDENTIFER";
@interface LitigationTabVC ()<UITextFieldDelegate>
{
    UITapGestureRecognizer * _tapGesture;
    NSString *_apply_execute_time;//申请执行时间
    NSString *_thytake_time;//收案时间
    NSString *_thyend_time;//结案时间
    NSString *_court_time;//开庭时间
}
@property (strong, nonatomic) NSMutableArray *titleArrays;//标题
@property (strong, nonatomic) NSMutableArray *textArr;//内容
@property (strong, nonatomic) NSMutableArray *placeHoldArr;
@end

@implementation LitigationTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];

}
- (void)initUI{
    _placeHoldArr = [NSMutableArray arrayWithObjects:@"请输入案件名称",@"请输入收案理由",@"",@"请输入结案理由",@"",@"",@"请输入内容",@"请输入内容",@"请输入内容",@"请输入内容",@"请输入主审法官",@"请输入联系电话",@"请输入联系地址",@"请输入结果",@"请输入二审法院",@"请输入主审法官",@"请输入联系电话",@"请输入联系地址",@"请输入二审结果",@"",@"请输入执行法院",@"请输入执行法官",@"请输入联系方式", nil];

    _titleArrays = [NSMutableArray arrayWithObjects:@"案件名称",@"收案理由",@"收案日期",@"结案理由",@"结案日期",@"开庭时间",@"公诉机关或原告人",@"被告或上诉人",@"其他诉讼参与人",@"一审法院/仲裁委员会",@"主审法官",@"联系电话",@"联系地址",@"一审/仲裁结果",@"二审法院",@"主审法官",@"联系电话",@"联系地址",@"二审结果",@"申请执行时间",@"执行法院",@"执行法官",@"联系方式", nil];
    if (_litEditType == FromManager) {
        _textArr = [NSMutableArray array];
        [_msgArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_textArr addObject:obj];
        }];
        
    }else{
        _textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    }

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[LitigationCell class] forCellReuseIdentifier:litigationIDENTIFER];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    LitigationCell *cell = (LitigationCell *)[tableView dequeueReusableCellWithIdentifier:litigationIDENTIFER];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LitigationCell class]])
    {
        LitigationCell *lCell = (LitigationCell *)cell;
        NSUInteger row = indexPath.row;
        lCell.rowIndex = row;
        lCell.textField.tag = 7000+row;

        if (_titleArrays.count >0) {
            lCell.titleLab.text = _titleArrays[row];
        }
        
        if (row ==2 || row == 4 || row == 5 || row == 19)
        {
            if (_textArr.count >0) {
                lCell.deviceLabel.text = _textArr[row];
            }
            
        }else{
            lCell.textField.delegate = self;
            lCell.textField.placeholder = _placeHoldArr[row];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:lCell.textField];
            if (_textArr.count >0) {
                lCell.textField.text = _textArr[row];
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    WEAKSELF;
    switch (row) {
        case 2:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thytake_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:2 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
            break;
        case 4:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thyend_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:4 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };

        }
            break;
        case 5:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _court_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:5 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:5 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
        }
            break;
        case 19:
        {
            UIWindow *windows = [QZManager getWindow];
            DateTimeView *timeView = [[DateTimeView alloc] initWithFrame:kMainScreenFrameRect];
            timeView.timeBlock = ^(NSString *timeS,NSString *sjcStr){
                _apply_execute_time = sjcStr;
                [weakSelf.textArr replaceObjectAtIndex:19 withObject:timeS];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:19 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            [windows addSubview:timeView];
        }
            break;
        default:
            break;
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
    
    [_textArr replaceObjectAtIndex:tag-7000 withObject:textField.text];
}


#pragma mark -UIButtonEvent
- (void)commitEvent:(id)sender
{WEAKSELF;
    DLog(@"提交");
   __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
   __block NSArray *paraArr = [NSArray arrayWithObjects:@"name",@"thytake",@"thytake_time",@"thyend",@"thyend_time",@"court_time",@"plaintiff",@"defendant",@"someoneelse",@"firs_court",@"firs_judge",@"firs_phone",@"firs_address",@"firs_result",@"two_court",@"two_judge",@"two_phone",@"two_address",@"two_result",@"apply_execute_time",@"execute_court",@"execute_judge",@"execute_phone", nil];

    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"1") forKey:@"type"];

    [_textArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyStr = paraArr[idx];
        
        if (idx == 0) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写案件名称"];
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];
        }else if (idx == 2) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您选择收案日期"];
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(_thytake_time) forKey:@"start_time"];
            [msgDic setObjectWithNullValidate:GET(_thytake_time) forKey:@"thytake_time"];
        }else if (idx == 4){
            [msgDic setObjectWithNullValidate:GET(_thyend_time) forKey:@"end_time"];
            [msgDic setObjectWithNullValidate:GET(_thyend_time) forKey:@"thyend_time"];
            (_thyend_time.length == 0)?[msgDic setObjectWithNullValidate:@"1" forKey:@"state"]:(([QZManager compareOneDay:[NSDate date] withAnotherDay:[QZManager timeStampChangeNSDate:[_thyend_time doubleValue]] withDateFormat:@"yyyy-MM-dd"] ==1)?[msgDic setObjectWithNullValidate:@"2" forKey:@"state"]:[msgDic setObjectWithNullValidate:@"1" forKey:@"state"]);
        }else if (idx == 5){
            [msgDic setObjectWithNullValidate:GET(_court_time) forKey:@"court_time"];
        }else if (idx == 19){
            [msgDic setObjectWithNullValidate:GET(_apply_execute_time) forKey:@"apply_execute_time"];
        }else{
            [msgDic setObjectWithNullValidate:GET(obj) forKey:keyStr];
        }
    }];
    
    if (_litEditType == FromManager) {
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{
            
            
            NSMutableArray *tempArr = [NSMutableArray array];
            [tempArr addObject:weakSelf.textArr[0]];
            [tempArr addObject:weakSelf.textArr[5]];
            [tempArr addObject:weakSelf.textArr[1]];
            [tempArr addObject:weakSelf.textArr[2]];
            [tempArr addObject:weakSelf.textArr[4]];
            [tempArr addObject:weakSelf.textArr[3]];
            
            for (NSUInteger i=6; i<weakSelf.textArr.count; i++) {
                NSString *obj = weakSelf.textArr[i];
                [tempArr addObject:obj];
            }
            weakSelf.editSuccess(tempArr);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeAdd] RequestSuccess:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
