//
//  BindingViewController.m
//  ZhouDao
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "BindingViewController.h"
#import "JKCountDownButton.h"
#import "ZHPickView.h"
#import "CCPRestSDK.h"
#import "NSString+MHCommon.h"

@interface BindingViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    BOOL _isLook;
    NSString *_typeString;//职业类型
    NSString *_codeStr;//验证码

}
@property (strong, nonatomic)  UIScrollView *bigScrollView;
@property (strong, nonatomic)  UIImageView  *iconImgView;

//注册绑定
@property (strong, nonatomic)  UIView       *bottomView;
@property (strong, nonatomic)  UITextField  *phoneText;
@property (strong, nonatomic)  UITextField  *codeText;
@property (strong, nonatomic)  UITextField  *keyText;
@property (strong, nonatomic)  UILabel      *professionalLab;
@property (strong, nonatomic)  UILabel      *placeLab;
@property (strong, nonatomic)  JKCountDownButton *getCodeBtn;
@property (strong, nonatomic)  UIImageView *eyeImgView;
@property (strong, nonatomic)  UIButton    *registerBtn;
@property (strong, nonatomic)  UILabel     *alertLab1;//已有注册帐号？点击这里
//登录绑定
@property (strong, nonatomic)  UIView       *bottomView2;
@property (strong, nonatomic)  UILabel      *alertLab2;//木有帐号？现在注册绑定
@property (strong, nonatomic)  UITextField  *loginNameText;
@property (strong, nonatomic)  UITextField  *loginKeyText;
@property (strong, nonatomic)  UIButton     *loginBtn;

@end

@implementation BindingViewController
#pragma mark - Life cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{WEAKSELF;
    [self setupNaviBarWithTitle:@"绑定手机号码"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.iconImgView];
    [self.view addSubview:self.bigScrollView];
    
    
    /*************************有注册 注册**************************************/
    _codeStr = @"";
    _typeString = @"9";
    [self.bigScrollView addSubview:self.bottomView ];
    
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
    [_professionalLab whenTapped:^{
        [weakSelf dismissKeyBoard];
        ZHPickView *pickView = [[ZHPickView alloc] init];
        [pickView setDataViewWithItem:@[@"执业律师",@"实习律师",@"公司法务",@"法律专业学生",@"公务员",@"其他"] title:@"选择职业"];
        [pickView showPickView:self];
        pickView.block = ^(NSString *selectedStr,NSString *type)
        {
            weakSelf.placeLab.text = @"";
            weakSelf.professionalLab.text = selectedStr;
            _typeString = type;
        };
    }];

    UIImageView *jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(_professionalLab.frame.size.width - 24, 10, 9, 15)];
    jiantouimg.userInteractionEnabled = YES;
    jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
    [_professionalLab addSubview:jiantouimg];
    
    [self.bigScrollView addSubview:self.registerBtn];
    [self.bigScrollView addSubview:self.alertLab1];
    [self.alertLab1 whenTapped:^{
        [UIView animateWithDuration:.25f animations:^{
            weakSelf.bigScrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
        }];
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
    
    /*************************有手机号直接登录**************************************/
    
    [self.bigScrollView addSubview:self.bottomView2];
    [_bottomView2 addSubview:self.loginNameText];
    [_bottomView2 addSubview:self.loginKeyText];
    [self.bigScrollView addSubview:self.loginBtn];
    [self.bigScrollView addSubview:self.alertLab2];
    [self.alertLab2 whenTapped:^{
        [UIView animateWithDuration:.25f animations:^{
            weakSelf.bigScrollView.contentOffset = CGPointMake(0, 0);
        }];
    }];

    UIImageView *loginNameImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 18, 21)];
    loginNameImg.image = [UIImage imageNamed:@"login_name"];
    [_bottomView2    addSubview:loginNameImg];
    UIView *loglineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bottomWith, .5f)];
    loglineView.backgroundColor = LRRGBAColor(215, 215, 215, 1);
    [_bottomView2    addSubview:loglineView];
    UIImageView *logCodeImg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 18, 21)];
    logCodeImg.image = kGetImage(@"login_key");
    [_bottomView2    addSubview:logCodeImg];

}
#pragma mark - private methods
#pragma mark -getters add setters
- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 74)/2.f, 114, 74, 74)];
        _iconImgView.image  = kGetImage(@"login_logo");
    }
    return _iconImgView;
}
- (UIScrollView *)bigScrollView{
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,Orgin_y(_iconImgView) + 20, kMainScreenWidth, kMainScreenHeight - 208)];
        CGFloat contentX = 2 * [UIScreen mainScreen].bounds.size.width;
        _bigScrollView.showsVerticalScrollIndicator = NO;
        _bigScrollView.contentSize = CGSizeMake(contentX, 0);
        _bigScrollView.pagingEnabled = YES;
        _bigScrollView.scrollEnabled = NO;
        _bigScrollView.delegate = self;
    }
    return _bigScrollView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(25, 0, kMainScreenWidth -50, 160)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderColor = LRRGBAColor(215, 215, 215, 1).CGColor;
        _bottomView.layer.borderWidth = .5f;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 5.f;
    }
    return _bottomView;
}
- (UITextField *)phoneText
{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, _bottomView.frame.size.width -40, 30)];
        _phoneText.borderStyle = UITextBorderStyleNone;
        _phoneText.delegate = self;
        _phoneText.tag = 3020;
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
        _codeText.tag = 3021;
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
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}
- (UITextField *)keyText
{
    if (!_keyText) {
        _keyText = [[UITextField alloc] initWithFrame:CGRectMake(40, 85, _bottomView.frame.size.width -140, 30)];
        _keyText.delegate = self;
        _keyText.tag = 3022;
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
    }
    return _professionalLab;
}
- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(26, Orgin_y(_bottomView) +15, kMainScreenWidth - 52, 40);
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5.f;
        _registerBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_registerBtn setTitle:@"注册并绑定" forState:0];
        _registerBtn.titleLabel.font = Font_14;
        _registerBtn.tag = 3023;
        [_registerBtn addTarget:self action:@selector(bindingBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
- (UILabel *)alertLab1
{
    if (!_alertLab1) {
        _alertLab1 = [[UILabel alloc] initWithFrame:CGRectMake(26, Orgin_y(_registerBtn) + 15, kMainScreenWidth - 52, 30)];
        _alertLab1.text = @"已有注册帐号？点击这里";
        _alertLab1.textColor =  LRRGBAColor(103, 215, 195, 1);
        _alertLab1.backgroundColor = [UIColor clearColor];
        _alertLab1.textAlignment = NSTextAlignmentCenter;
        _alertLab1.font = Font_14;
    }
    return _alertLab1;
}
- (UIView *)bottomView2{
    if (!_bottomView2) {
        _bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(25 + kMainScreenWidth, 0, kMainScreenWidth -50, 89)];
        _bottomView2.backgroundColor = [UIColor whiteColor];
        _bottomView2.layer.borderColor = LRRGBAColor(215, 215, 215, 1).CGColor;
        _bottomView2.layer.borderWidth = .5f;
        _bottomView2.layer.masksToBounds = YES;
        _bottomView2.layer.cornerRadius = 5.f;
    }
    return _bottomView2;
}
- (UITextField *)loginNameText
{
    if (!_loginNameText) {
        _loginNameText = [[UITextField alloc] initWithFrame:CGRectMake(40, 6, _bottomView2.frame.size.width -40, 30)];
        _loginNameText.borderStyle = UITextBorderStyleNone;
        _loginNameText.delegate = self;
        _loginNameText.tag = 3024;
        _loginNameText.font = Font_14;
        _loginNameText.placeholder = @"手机号";
        _loginNameText.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _loginNameText;
}
- (UITextField *)loginKeyText
{
    if (!_loginKeyText) {
        _loginKeyText = [[UITextField alloc] initWithFrame:CGRectMake(40, 50, _bottomView2.frame.size.width -40, 30)];
        _loginKeyText.borderStyle = UITextBorderStyleNone;
        _loginKeyText.delegate = self;
        _loginKeyText.tag = 3025;
        _loginKeyText.font = Font_14;
        _loginKeyText.placeholder = @"密码";
    }
    return _loginKeyText;
}
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(26 + kMainScreenWidth, Orgin_y(_bottomView2) +15, kMainScreenWidth - 52, 40);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 5.f;
        _loginBtn.backgroundColor  = LRRGBAColor(0, 201, 173, 1);
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_loginBtn setTitle:@"登录并绑定" forState:0];
        _loginBtn.titleLabel.font = Font_14;
        _loginBtn.tag = 3026;
        [_loginBtn addTarget:self action:@selector(bindingBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
- (UILabel *)alertLab2
{
    if (!_alertLab2) {
        _alertLab2 = [[UILabel alloc] initWithFrame:CGRectMake(26 + kMainScreenWidth, Orgin_y(_loginBtn) + 15, kMainScreenWidth - 52, 30)];
        _alertLab2.text = @"木有帐号？现在注册绑定";
        _alertLab2.textColor =  LRRGBAColor(103, 215, 195, 1);
        _alertLab2.backgroundColor = [UIColor clearColor];
        _alertLab2.textAlignment = NSTextAlignmentCenter;
        _alertLab2.font = Font_14;
    }
    return _alertLab2;
}

- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
    if (textField.tag == 3020) {
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
#pragma mark - event response
- (void)bindingBtnEvent:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    if (tag == 3023) {
        
    }else {//3026
        
    }
}
- (void)getCodeBtnEvent:(id)sender
{
    DLog(@"获取验证码");
    
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
