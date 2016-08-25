//
//  NewPhoneVC.m
//  ZhouDao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NewPhoneVC.h"
#import "CCPRestSDK.h"
#import "JKCountDownButton.h"

@interface NewPhoneVC ()<UITextFieldDelegate>
{
    NSString *_codeStr;//验证码
    NSString *_phoneString;//验证手机号是否是同一个

}
@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) JKCountDownButton *sendBtn;
@property (nonatomic, strong) UIButton *commitBtn;

@end

@implementation NewPhoneVC
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
    [self setupNaviBarWithTitle:@"更换手机号"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _codeStr = @"";
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, kMainScreenWidth, 106)];
    headView.backgroundColor  = [UIColor whiteColor];
//    headView.layer.borderWidth = .6f;
//    headView.layer.borderColor = lineColor.CGColor;
    [self.view addSubview:headView];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(15, 10,kMainScreenWidth-30 , 45)];
    oneView.backgroundColor = ViewBackColor;
    oneView.layer.borderWidth = .6f;
    oneView.layer.borderColor = LINECOLOR.CGColor;
    oneView.layer.masksToBounds = YES;
    oneView.layer.cornerRadius = 2.f;
    [headView addSubview:oneView];
    
    _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(15, 2,oneView.frame.size.width-15 , 41)];
    _phoneText.placeholder = @"请您输入新手机号";
    _phoneText.borderStyle = UITextBorderStyleNone;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.returnKeyType = UIReturnKeyDone;
    _phoneText.backgroundColor = ViewBackColor;
    [self.phoneText setValue:Font_15 forKeyPath:@"_placeholderLabel.font"];
    [oneView addSubview:_phoneText];
    
    //按钮
    _sendBtn= [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.backgroundColor = KNavigationBarColor;
    _sendBtn.titleLabel.font = Font_14;
    _sendBtn.frame = CGRectMake(oneView.frame.size.width - 130, 6, 120 , 33);
    [_sendBtn setTitle:@"发送验证码" forState:0];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3.f;
    [_sendBtn addTarget:self action:@selector(replaceBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.tag = 9123;
    [oneView addSubview:_sendBtn];
    
    /******************************分割线**********************************/
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(15, 65, kMainScreenWidth-30 , 45)];
    twoView.backgroundColor = ViewBackColor;
    twoView.layer.borderWidth = .6f;
    twoView.layer.borderColor = LINECOLOR.CGColor;
    twoView.layer.masksToBounds = YES;
    twoView.layer.cornerRadius = 2.f;
    [headView addSubview:twoView];

    
    _codeText = [[UITextField alloc] initWithFrame:CGRectMake(15, 4, twoView.frame.size.width-15, 37)];
    _codeText.placeholder = @"验证码";
    _codeText.borderStyle = UITextBorderStyleNone;
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    _codeText.returnKeyType = UIReturnKeyDone;
    _codeText.backgroundColor = ViewBackColor;
    [self.codeText setValue:Font_15 forKeyPath:@"_placeholderLabel.font"];
    [twoView addSubview:_codeText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.codeText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneText];

    _commitBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _commitBtn.backgroundColor = KNavigationBarColor;
    _commitBtn.titleLabel.font = Font_14;
    _commitBtn.frame = CGRectMake(15, Orgin_y(headView) +20, kMainScreenWidth - 30 , 45);
    [_commitBtn setTitleColor:[UIColor colorWithHexString:@"#dadada"] forState:0];
    [_commitBtn setTitle:@"确认修改" forState:0];
    [_commitBtn addTarget:self action:@selector(replaceBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    _commitBtn.enabled = NO;
    _commitBtn.layer.masksToBounds = YES;
    _commitBtn.layer.cornerRadius = 3.f;
    _commitBtn.tag = 9222;
    [self.view addSubview:_commitBtn];

}
#pragma mark -UIButtonEvent
- (void)replaceBtnEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    WEAKSELF;
    switch (index) {
        case 9123:
        {
            if (_phoneText.text.length == 11  && [QZManager isPureInt:_phoneText.text] == YES)
            {
                [NetWorkMangerTools validationPhoneNumber:_phoneText.text RequestSuccess:^{
                    
                    [self timerInit:sender];
                    CCPRestSDK* ccpRestSdk = [[CCPRestSDK alloc] initWithServerIP:YTXSEVERIP andserverPort:YTXPORT];
                    [ccpRestSdk setApp_ID:YTXAPPID];
                    [ccpRestSdk enableLog:YES];
                    [ccpRestSdk setAccountWithAccountSid: YTXACCOUNSID andAccountToken:YTXAUTHTOKEN];
                    //                if (_codeStr.length == 0) {
                    _codeStr = [QZManager getSixEvent];
                    //                }
                    NSArray*  arr = [NSArray arrayWithObjects:_codeStr,@"验证码" ,nil];
                    [ccpRestSdk sendTemplateSMSWithTo:_phoneText.text andTemplateId:YTXTEMPLATE andDatas:arr];
                    //                    DLog(@"打印出来－－－%@",[NSString stringWithFormat:@"%@",dict]);

                } fail:^(NSString *msg) {
                    [JKPromptView showWithImageName:nil message:msg];
                }];
            }
            
        }
            break;
        case 9222:
        {
            if (_codeText.text.length == 0) {
                [JKPromptView showWithImageName:nil message:@"请您填写验证码!"];
                return;
            }
            
            if (![_codeText.text isEqualToString:_codeStr] || ![_phoneText.text isEqualToString:_phoneString]) {
                [JKPromptView showWithImageName:nil message:@"验证码错误!"];
                return;
            }
            
            [NetWorkMangerTools resetPhoneNumber:_phoneText.text RequestSuccess:^{
                
                NSString *loginType = [USER_D objectForKey:StorageTYPE];
                if (loginType.length == 0) {
                    [USER_D setObject:_phoneText.text forKey:StoragePhone];
                    [USER_D synchronize];
                }

                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
            break;

        default:
            break;
    }
    
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        //SHOW_ALERT(@"不能输入表情!");
        textField.text = [NSString disable_emoji:textField.text];
    }
    
    if (self.phoneText.text.length >0 && self.codeText.text.length >0)
    {
        _commitBtn.enabled = YES;
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    }else{
        _commitBtn.enabled = NO;
        [_commitBtn setTitleColor:[UIColor colorWithHexString:@"#dadada"] forState:0];
    }
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self dismissKeyBoard];
    return true;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    return YES;
}
#pragma mark - timer相关
- (void)timerInit:(id)sender
{
    _phoneString = _phoneText.text;
    JKCountDownButton *btn = (JKCountDownButton *)sender;
    btn.enabled = NO;
    [sender startCountDownWithSecond:60];
    [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zd秒",second];
        return title;
    }];
    [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
