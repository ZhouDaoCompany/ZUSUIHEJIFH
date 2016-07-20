//
//  FindKeyViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "FindKeyViewController.h"
#import "CCPRestSDK.h"
#import "NSString+MHCommon.h"

@interface FindKeyViewController ()<UITextFieldDelegate>
{
    BOOL _isLook;
    NSString *_codeStr;//验证码
}
@end
@implementation FindKeyViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}
- (void)initUI{
    
    _codeStr = @"";
    [self setupNaviBarWithTitle:@"找回密码"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"" img:@"backVC"];
    
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 5.f;
    self.bottomView.layer.borderColor = LRRGBAColor(215, 215, 215, 1).CGColor;
    self.bottomView.layer.borderWidth = .5f;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.codeText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.resetBtn.layer.masksToBounds = YES;
    self.resetBtn.layer.cornerRadius = 5.f;
    _keyText.secureTextEntry = YES;
    _eyeImg.userInteractionEnabled = YES;
    WEAKSELF;
    [_eyeImg whenTapped:^{
        
        [self dismissKeyBoard];
        if (_isLook == YES) {
            weakSelf.eyeImg.image = [UIImage imageNamed:@"find_eye"];
            weakSelf.keyText.secureTextEntry = YES;
        }else {
            weakSelf.eyeImg.image = [UIImage imageNamed:@"find_eyeSelect"];
            weakSelf.keyText.secureTextEntry = NO;
        }
        _isLook = !_isLook;

    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.phoneText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.codeText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.keyText];
    
    self.phoneText.tag = 3008;
    self.codeText.tag = 3009;
    self.keyText.tag = 3010;
    self.phoneText.delegate = self;
    self.codeText.delegate = self;
    self.keyText.delegate = self;
    self.keyText.returnKeyType = UIReturnKeyDone;
    self.codeText.returnKeyType = UIReturnKeyDone;
    self.phoneText.returnKeyType = UIReturnKeyDone;

}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        //SHOW_ALERT(@"不能输入表情!");
        textField.text = [NSString disable_emoji:textField.text];
    }
    
    if (textField.tag == 3000) {
        if (textField.text.length >11) {
            textField.text = [textField.text substringToIndex:11 ];
        }
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
#pragma mark -UIButtonEvent
- (IBAction)getCodeOrResetEvent:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    
    switch (index) {
        case 1003:
        {//获取验证码
            
            if (_phoneText.text.length >0) {
                if (_phoneText.text.length == 11  && [QZManager isPureInt:_phoneText.text] == YES)
                {
                    [NetWorkMangerTools validationPhoneNumber:_phoneText.text RequestSuccess:^{
                        
                        [JKPromptView showWithImageName:@"" message:@"该号码还没有注册，请您注册"];
                    } fail:^(NSString *msg) {
                        
                        [self timerInit:sender];
                        CCPRestSDK* ccpRestSdk = [[CCPRestSDK alloc] initWithServerIP:YTXSEVERIP andserverPort:YTXPORT];
                        [ccpRestSdk setApp_ID:YTXAPPID];
                        [ccpRestSdk enableLog:YES];
                        [ccpRestSdk setAccountWithAccountSid: YTXACCOUNSID andAccountToken:YTXAUTHTOKEN];
                        _codeStr = [QZManager getSixEvent];
                        NSArray*  arr = [NSArray arrayWithObjects:_codeStr,@"验证码" ,nil];
                        [ccpRestSdk sendTemplateSMSWithTo:_phoneText.text andTemplateId:YTXTEMPLATE andDatas:arr];
                    }];
                }else{
                    [JKPromptView showWithImageName:nil message:@"请您检查手机号码!"];
                }
            }else{
                [JKPromptView showWithImageName:nil message:@"请您填写手机号嘛!"];

            }
        }
            break;
        case 1004:
        {//重置密码
            if (_phoneText.text.length<=0) {
                [JKPromptView showWithImageName:nil message:@"请您检查手机号码是否填写!"];
                return;
            }else if(_phoneText.text.length != 11  || [QZManager isPureInt:_phoneText.text] == NO){
                [JKPromptView showWithImageName:nil message:@"请您检查手机号码是否正确!"];
                return;
            }else if (_keyText.text.length <=0){
                [JKPromptView showWithImageName:nil message:@"请您检查密码是否填写!"];
                return;
            }else if(_codeText.text.length <=0){
                [JKPromptView showWithImageName:nil message:@"请您检查验证码是否填写!"];
                return;
            }else if(![_codeText.text isEqualToString:_codeStr]){
                [JKPromptView showWithImageName:nil message:@"验证码不正确!"];
                return;
            }else if ([QZManager isValidatePassword:_keyText.text] == NO)
            {
                [JKPromptView showWithImageName:nil message:@"密码为6-14位数字和字母组合，请您仔细检查"];
                return;
            }

            [SVProgressHUD showWithStatus:@"提交中..."];

            NSString *forgetUrl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,ForgetKey,_phoneText.text,[_keyText.text md5]];
            [ZhouDao_NetWorkManger GetJSONWithUrl:forgetUrl success:^(NSDictionary *jsonDic) {
                [SVProgressHUD dismiss];
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                if (errorcode !=1) {
                    [SVProgressHUD showErrorWithStatus:msg];
                    return ;
                }
                [JKPromptView showWithImageName:nil message:msg];
                
                [USER_D setObject:_phoneText.text forKey:StoragePhone];
                [USER_D setObject:[_keyText.text md5] forKey:StoragePassword];
                [USER_D synchronize];
                
                self.findBlock(_phoneText.text);
                [self.navigationController popViewControllerAnimated:YES];
            } fail:^{
                [SVProgressHUD showErrorWithStatus:AlrertMsg];
            }];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - timer相关
- (void)timerInit:(id)sender
{
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
