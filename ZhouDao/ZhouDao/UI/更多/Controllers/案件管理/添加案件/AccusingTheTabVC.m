//
//  AccusingTheTabVC.m
//  ZhouDao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "AccusingTheTabVC.h"
#import "AccusingTheCell.h"
#import "ZHPickView.h"
#import "RemarkTabCell.h"

static NSString *const AccusingTheIDENTIFER = @"AccusingTheIDENTIFER";
static NSString *const ACCNOTEIDENTIFER = @"accnoteidentifer";

@interface AccusingTheTabVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITapGestureRecognizer * _tapGesture;
    NSString *_thytake_time;//收案时间
    NSString *_thyend_time;//结案时间
}
@property (strong, nonatomic) NSMutableArray *titleArrays;//标题
@property (strong, nonatomic) NSMutableArray *textArr;//内容
@property (nonatomic, strong) UIWebView *callPhoneWebView;

@end

@implementation AccusingTheTabVC
#pragma mark -打电话
- (UIWebView *)callPhoneWebView {
    if (!_callPhoneWebView) {
        _callPhoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _callPhoneWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)initUI{
    
    _titleArrays = [NSMutableArray arrayWithObjects:@"案件号",@"案件名称",@"委托人",@"委托人联系电话",@"委托人联系邮箱",@"委托人联系地址",@"收案日期",@"结案日期",@"备注", nil];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

    if (_accType == AccFromManager) {
    
        NSString *sign_time = @"";
        if ([_basicModel.thytake_time intValue] != 0) {
            sign_time = [QZManager changeTimeMethods:[_basicModel.thytake_time doubleValue] withType:@"yyyy-MM-dd"];
        }
        NSString *sign_endtime = @"";
        if ([_basicModel.thyend_time intValue] != 0) {
            sign_endtime = [QZManager changeTimeMethods:[_basicModel.thyend_time doubleValue] withType:@"yyyy-MM-dd"];
        }

        _textArr = [NSMutableArray arrayWithObjects:_basicModel.number,_basicModel.name,_basicModel.client,_basicModel.client_phone,_basicModel.client_mail,_basicModel.client_address,sign_time,sign_endtime,_basicModel.remarks,nil];
        
    }else{
        _textArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
        self.tableView.tableFooterView = [self creatTabFootView];
    }

    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    _tapGesture.cancelsTouchesInView = NO;//关键代码
    [self.tableView addGestureRecognizer:_tapGesture];
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
    [commitBtn addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:commitBtn];
    return footView;
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

    if (indexPath.row == _titleArrays.count - 1) {
        [self.tableView registerClass:[RemarkTabCell class] forCellReuseIdentifier:ACCNOTEIDENTIFER];
        RemarkTabCell *cell = (RemarkTabCell *)[tableView dequeueReusableCellWithIdentifier:ACCNOTEIDENTIFER forIndexPath:indexPath];
        return cell;

    }
    
    [self.tableView registerClass:[AccusingTheCell class] forCellReuseIdentifier:AccusingTheIDENTIFER];
    AccusingTheCell *cell = (AccusingTheCell *)[tableView dequeueReusableCellWithIdentifier:AccusingTheIDENTIFER];
    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _titleArrays.count - 1) {
        return 115.f;
    }
    return 50.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;

    if ([cell isKindOfClass:[AccusingTheCell class]])
    {
        AccusingTheCell *aCell = (AccusingTheCell *)cell;
        aCell.rowIndex = row;
        aCell.textField.tag = 7000+row;
        aCell.titleLab.text = _titleArrays[row];
        
        if (row == 6 || row == 7)
        {
            if (_textArr.count >0) {
                aCell.deviceLabel.text = _textArr[row];
            }
            
        }else{
            aCell.textField.delegate = self;
            
            if (_isEdit == NO && _accType == AccFromManager) {
                aCell.textField.enabled = NO;
            }else{
                aCell.textField.enabled = YES;
                aCell.textField.placeholder = [NSString stringWithFormat:@"请输入%@",_titleArrays[row]];
            }

            [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:aCell.textField];
            aCell.textField.text = _textArr[row];
        }
        
    }else if ([cell isKindOfClass:[RemarkTabCell class]]){
        
        RemarkTabCell *rCell = (RemarkTabCell *)cell;
        rCell.textView.delegate = self;
        rCell.textView.text = _textArr[row];
        rCell.textView.tag = row +7000;
        rCell.placeHoldlab.tag = 8887;

        if (_isEdit == NO && _accType == AccFromManager) {
            rCell.textView.editable = NO;
            rCell.placeHoldlab.text = @"";

        }else{
            rCell.textView.editable = YES;
            if (rCell.textView.text.length >0) {
                rCell.placeHoldlab.text = @"";
            }else {
                rCell.placeHoldlab.text = @" 写备注...";
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    WEAKSELF;
    NSUInteger row = indexPath.row;

    if (_isEdit == NO && _accType == AccFromManager) {
        //编辑状态不能修改
        if ([QZManager isString:_titleArrays[row] withContainsStr:@"电话"])
        {
            NSString *phoneStr = _textArr[row];
            if (phoneStr.length >0) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                [self.callPhoneWebView loadRequest:request];
            }
        }
        return;
    }
    
    switch (row) {
        case 6:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thytake_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:6 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:6 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            
        }
            break;
        case 7:
        {
            UIWindow *windows = [QZManager getWindow];
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择时间"];
            [pickView showWindowPickView:windows];
            pickView.alertBlock = ^(NSString *selectedStr)
            {
                _thyend_time = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:selectedStr] timeIntervalSince1970]];
                [weakSelf.textArr replaceObjectAtIndex:7 withObject:selectedStr];
                [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:7 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            
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
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeHoldlab = (UILabel *)[self.view viewWithTag:8887];
    if (textView.text.length >0) {
        placeHoldlab.text = @"";
    }else {
        placeHoldlab.text = @" 写备注...";
    }
    
    BOOL flag=[NSString isContainsTwoEmoji:textView.text];
    if (flag){
        textView.text = [NSString disable_emoji:textView.text];
    }
    
    NSInteger row = textView.tag - 7000;
    [_textArr replaceObjectAtIndex:row withObject:textView.text];
}


#pragma mark -UIButtonEvent
- (void)commitEvent:(id)sender
{WEAKSELF;
    DLog(@"提交");
    
    __block NSArray *paraArrays = [NSArray arrayWithObjects:@"number",@"name",@"client",@"client_phone",@"client_mail",@"client_address",@"thytake_time",@"thyend_time",@"remarks", nil];
   __block NSMutableDictionary *msgDic = [[NSMutableDictionary alloc] init];
    [msgDic setObjectWithNullValidate:GET(UID) forKey:@"uid"];
    [msgDic setObjectWithNullValidate:GET(@"2") forKey:@"type"];

    __block BOOL _isReturn;

    [_textArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            if (obj.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写案件名称"];
                _isReturn = YES;
                *stop = YES;
                return ;
            }
            [msgDic setObjectWithNullValidate:GET(obj) forKey:@"name"];
        }else if (idx == 6){
            if (obj.length >0) {
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:obj] timeIntervalSince1970]];
                NSString *keyStr = paraArrays[idx];
                [msgDic setObjectWithNullValidate:GET(timeStr) forKey:keyStr];
            }

        }else if (idx == 7){
            if (obj.length >0) {
                NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[QZManager caseDateFromString:obj] timeIntervalSince1970]];
                NSString *keyStr = paraArrays[idx];
                [msgDic setObjectWithNullValidate:GET(timeStr) forKey:keyStr];
            }
            
        }else {
            NSString *keyStr = paraArrays[idx];
            [msgDic setObjectWithNullValidate:GET(obj) forKey:keyStr];

        }
        
    }];
    if (_isReturn == YES) {
        return;
    }

    if (_accType == AccFromManager) {
        
        [msgDic setObjectWithNullValidate:_caseId forKey:@"id"];
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeEdit] RequestSuccess:^{
            
            weakSelf.editSuccess(msgDic[@"name"]);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];

    }else{
        [NetWorkMangerTools arrangeAddManagement:msgDic withUrl:[NSString stringWithFormat:@"%@%@",kProjectBaseUrl,arrangeAdd] RequestSuccess:^{
            
            weakSelf.addSuccess();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    if (_isEdit == YES) {
        self.tableView.tableFooterView = [self creatTabFootView];
        [self.tableView reloadData];
    }else {
        [self commitEvent:nil];
    }
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
