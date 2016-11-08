//
//  RegisterViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "RegisterViewController.h"
#import "ZHPickView.h"
#import "LoginViewController.h"
#import "CCPRestSDK.h"
#import "NSString+MHCommon.h"
/**
 * 认证
 *  #import "ImmediatelyVC.h"
 */

@interface RegisterViewController ()<UITextFieldDelegate>
{
    BOOL _isLook;
    NSString *_typeString;//职业类型
    NSString *_codeStr;//验证码
    NSString *_phoneString;//验证手机号是否是同一个
}

@end

@implementation RegisterViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self initUI];
}
#pragma mark - life cycle
- (void)initUI
{
    _codeStr = @"";
    _typeString = @"9";
    _phoneString = @"";
    [self setupNaviBarWithTitle:@"注册"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Count_close_normal_"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.logoImgView];
    [self.view addSubview:self.bottomView ];
    
    float bottomWith = _bottomView.frame.size.width;

    //1
    UIImageView *nameImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 18, 21)];
    nameImg.image = [UIImage imageNamed:@"login_name"];
    [_bottomView    addSubview:nameImg];
    
    [_bottomView addSubview:self.phoneText];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bottomWith, .5f)];
    lineView1.backgroundColor = LRRGBAColor(215, 215, 215, 1);
    [_bottomView    addSubview:lineView1];
    
    //2
    UIImageView *codeImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 19, 15)];
    codeImg.image = [UIImage imageNamed:@"find_code"];
    [_bottomView    addSubview:codeImg];
    
    [_bottomView addSubview:self.codeText];
    [_bottomView addSubview:self.getCodeBtn];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, bottomWith, .5f)];
    lineView2.backgroundColor = LRRGBAColor(215, 215, 215, 1);
    [_bottomView    addSubview:lineView2];

    //3
    UIImageView *keyImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 89, 18, 21)];
    keyImg.image = [UIImage imageNamed:@"login_key"];
    [_bottomView    addSubview:keyImg];
    
    [_bottomView addSubview:self.keyText];
    
    //CGFloat eyeX = bottomWith  - (100  - [ConFunc getBtnTitleWidth:_getCodeBtn])/2.f - 20;
    [_bottomView addSubview:self.eyeImgView];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, bottomWith, .5f)];
    lineView3.backgroundColor = LRRGBAColor(215, 215, 215, 1);
    [_bottomView    addSubview:lineView3];
    
    //4
    UIImageView *proImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10,129, 18, 21)];
    proImg.image = [UIImage imageNamed:@"login_name"];
    [_bottomView    addSubview:proImg];
    
    [_bottomView   addSubview:self.placeLab];
    
    [_bottomView addSubview:self.professionalLab];
    
    UIImageView *jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(_professionalLab.frame.size.width - 24, 10, 9, 15)];
    jiantouimg.userInteractionEnabled = YES;
    jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
    [_professionalLab addSubview:jiantouimg];

    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.goLoginBtn];
    
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

}
#pragma mark - private methods
#pragma mark - getters and setters
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(25, 194, kMainScreenWidth -50, 160)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderColor = LRRGBAColor(215, 215, 215, 1).CGColor;
        _bottomView.layer.borderWidth = .5f;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 5.f;
    }
    return _bottomView;
}
- (UIImageView *)logoImgView
{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth -74)/2.f, 84, 74, 74)];
        _logoImgView.image = kGetImage(@"login_logo");
    }
    return _logoImgView;
}
- (UITextField *)phoneText
{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, _bottomView.frame.size.width -40, 30)];
        _phoneText.borderStyle = UITextBorderStyleNone;
        _phoneText.delegate = self;
        _phoneText.tag = 3012;
        _phoneText.font = Font_14;
        _phoneText.placeholder = @"手机号";
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneText;
}
- (UITextField *)codeText
{
    if (!_codeText) {
        _codeText = [[UITextField alloc] initWithFrame:CGRectMake(40, 45, _bottomView.frame.size.width -140, 30)];
        _codeText.delegate = self;
        _codeText.tag = 3013;
        _codeText.borderStyle = UITextBorderStyleNone;
        _codeText.placeholder = @"验证码";
        _codeText.font = Font_14;
    }
    return _codeText;
}
- (JKCountDownButton *)getCodeBtn
{
    if (!_getCodeBtn) {
        _getCodeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
        _getCodeBtn.frame = CGRectMake(_bottomView.frame.size.width-100, 40, 100, 40);
        _getCodeBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_getCodeBtn setTitle:@"获取验证码" forState:0];
        _getCodeBtn.titleLabel.font = Font_14;
        _getCodeBtn.tag = 3009;
        [_getCodeBtn addTarget:self action:@selector(allBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}
- (UITextField *)keyText
{
    if (!_keyText) {
        _keyText = [[UITextField alloc] initWithFrame:CGRectMake(40, 85, _bottomView.frame.size.width -140, 30)];
        _keyText.delegate = self;
        _keyText.tag = 3014;
        _keyText.secureTextEntry = YES;
        _keyText.borderStyle = UITextBorderStyleNone;
        _keyText.placeholder = @"密码为6-14位数字和字母组合";
        _keyText.font = Font_14;

    }
    return _keyText;
}
- (UIImageView *)eyeImgView
{
    if (!_eyeImgView) {
        _eyeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_bottomView.frame.size.width- 40, 93, 20, 14)];
        _eyeImgView.image = [UIImage imageNamed:@"find_eye"];
        _eyeImgView.userInteractionEnabled = YES;
        [_eyeImgView whenTapped:^{
            [self dismissKeyBoard];
            if (_isLook == YES) {
                _eyeImgView.image = [UIImage imageNamed:@"find_eye"];
                _keyText.secureTextEntry = YES;
            }else {
                _eyeImgView.image = [UIImage imageNamed:@"find_eyeSelect"];
                _keyText.secureTextEntry = NO;
            }
            _isLook = !_isLook;
        }];
    }
    return _eyeImgView;
}
- (UILabel *)placeLab
{
    if (!_placeLab) {
        _placeLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 125, _bottomView.frame.size.width -40, 30)];
        _placeLab.text = @"职业";
        _placeLab.font = Font_14;
        _placeLab.textColor  = [UIColor lightGrayColor];
    }
    return _placeLab;
}
- (UILabel *)professionalLab
{
    if (!_professionalLab) {
        _professionalLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 125, _bottomView.frame.size.width -40, 30)];
        _professionalLab.font = Font_14;
        [_professionalLab whenTapped:^{
            [self dismissKeyBoard];
            ZHPickView *pickView = [[ZHPickView alloc] initWithSelectString:_professionalLab.text];
            [pickView setDataViewWithItem:@[@"执业律师",@"实习律师",@"公司法务",@"法律专业学生",@"公务员",@"其他"] title:@"选择职业"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr,NSString *type)
            {
                _placeLab.text = @"";
                _professionalLab.text = selectedStr;
                _typeString = type;
            };
        }];
    }
    return _professionalLab;
}
- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(26, 375, kMainScreenWidth - 52, 40);
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5.f;
        _registerBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_registerBtn setTitle:@"注册" forState:0];
        _registerBtn.titleLabel.font = Font_14;
        _registerBtn.tag = 3010;
        [_registerBtn addTarget:self action:@selector(allBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
- (UIButton *)goLoginBtn
{
    if (!_goLoginBtn) {
        _goLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goLoginBtn.frame = CGRectMake(26, 430, kMainScreenWidth - 52, 40);
        _goLoginBtn.backgroundColor  = [UIColor whiteColor];
        _goLoginBtn.layer.masksToBounds = YES;
        _goLoginBtn.layer.cornerRadius = 5.f;
        _goLoginBtn.layer.borderWidth = 1.f;
        _goLoginBtn.layer.borderColor = LRRGBAColor(0, 201, 173, 1).CGColor;
        [_goLoginBtn setTitleColor:LRRGBAColor(0, 201, 173, 1) forState:0];
        [_goLoginBtn setTitle:@"已有账号，直接登录>" forState:0];
        _goLoginBtn.titleLabel.font = Font_14;
        _goLoginBtn.tag = 3011;
        [_goLoginBtn addTarget:self action:@selector(allBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _goLoginBtn;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    if (textField.tag == 3012) {
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
- (void)allBtnEvent:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger index = btn.tag;
    switch (index) {
        case 3009:
        {//发送验证码
            
            if (_phoneText.text.length == 11  && [QZManager isPureInt:_phoneText.text] == YES)
            {

                [NetWorkMangerTools validationPhoneNumber:_phoneText.text RequestSuccess:^{
                    
                    [self timerInit:sender];
                    CCPRestSDK* ccpRestSdk = [[CCPRestSDK alloc] initWithServerIP:YTXSEVERIP andserverPort:YTXPORT];
                    [ccpRestSdk setApp_ID:YTXAPPID];
                    [ccpRestSdk enableLog:YES];
                    [ccpRestSdk setAccountWithAccountSid: YTXACCOUNSID andAccountToken:YTXAUTHTOKEN];
                    _codeStr = [QZManager getSixEvent];
                    NSArray*  arr = [NSArray arrayWithObjects:_codeStr,@"验证码" ,nil];
                    [ccpRestSdk sendTemplateSMSWithTo:_phoneText.text andTemplateId:YTXTEMPLATE andDatas:arr];

                } fail:^(NSString *msg) {
                    [JKPromptView showWithImageName:nil message:msg];
                }];
            }
        }
            break;
        case 3010:
        {
            [self loadRegisterData];
        }
            break;
        case 3011:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
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

#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    LoginViewController *loginVC = self.navigationController.viewControllers[0];
    if (loginVC.closeBlock) {
        loginVC.closeBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
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
#pragma mark -注册请求
- (void)loadRegisterData
{
    WEAKSELF;
    if (_phoneText.text.length<=0) {
        [JKPromptView showWithImageName:nil message:LOCPHONE];
        return;
    }else if (_keyText.text.length <=0){
        [JKPromptView showWithImageName:nil message:LOCPASSWORD];
        return;
    }else if(_codeText.text.length <=0){
        [JKPromptView showWithImageName:nil message:LOCVERIFICATION];
        return;
    }else if(![_codeText.text isEqualToString:_codeStr] || ![_phoneText.text isEqualToString:_phoneString]){
        [JKPromptView showWithImageName:nil message:LOCNOTVERIFICATION];
        return;
    }else if (_professionalLab.text.length <=0){
        [JKPromptView showWithImageName:nil message:@"请您检查职业是否选择"];
        return;
    }else if ([QZManager isValidatePassword:_keyText.text] == NO)
    {
        [JKPromptView showWithImageName:nil message:LOCPASSWORDLIMIT];
        return;
    }else if ([QZManager isIncludeSpecialCharact:_keyText.text]){
        [JKPromptView showWithImageName:nil message:LOCPASSWORDILLEGAL];
        return;
    }
    
    [MBProgressHUD showMBLoadingWithText:nil];
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceUDID = [[device identifierForVendor] UUIDString];
    DLog(@"输出设备的id---%@",deviceUDID);

    NSString *regiserUrl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@&type=%@&udid=%@",kProjectBaseUrl,RegisterUrlString,_phoneText.text,[_keyText.text md5],_typeString,deviceUDID];
    [ZhouDao_NetWorkManger getWithUrl:regiserUrl sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        [JKPromptView showWithImageName:nil message:msg];
        if (errorcode !=1) {
            return ;
        }
        //        self.successRegisterBlock(_phoneText.text,_keyText.text);
        [weakSelf loginMethod];
        
        /*****************立即认证*******************************/
        //        if ([_professionalLab.text isEqualToString:@"执业律师"]) {
        //            ImmediatelyVC *vc = [ImmediatelyVC new];
        //            vc.cerType = FromRegister;
        //            [weakSelf.navigationController pushViewController:vc animated:YES];
        //        }else{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        //        }

    } fail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [JKPromptView showWithImageName:nil message:LOCERROEMESSAGE];
    }];
}
- (void)loginMethod
{
    NSString *loginurl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,LoginUrlString,_phoneText.text,[_keyText.text md5]];
    [ZhouDao_NetWorkManger getWithUrl:loginurl sg_cache:NO success:^(id response) {
        
        [MBProgressHUD hideHUD];
        NSDictionary *jsonDic = (NSDictionary *)response;
        NSUInteger errorcode = [jsonDic[@"state"] integerValue];
        NSString *msg = jsonDic[@"info"];
        if (errorcode !=1) {
            [JKPromptView showWithImageName:nil message:msg];
            return ;
        }
        [USER_D setObject:_phoneText.text forKey:StoragePhone];
        [USER_D setObject:[_keyText.text md5] forKey:StoragePassword];
        [USER_D synchronize];
        UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
        [PublicFunction ShareInstance].m_user = model;
        [PublicFunction ShareInstance].m_bLogin = YES;

    } fail:^(NSError *error) {
    }];
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
