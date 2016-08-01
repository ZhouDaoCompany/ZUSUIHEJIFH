//
//  LoginViewController.m
//  ZhouDao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "RegisterViewController.h"
#import "FindKeyViewController.h"
#import "NSString+MHCommon.h"
#import "UMessage.h"
//#import "ThirdPartyLoginView.h"
#import "BindingViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic , strong) UIButton *registerBtn;//注册按钮
//@property (nonatomic, strong) ThirdPartyLoginView * loginView;
- (IBAction)forgetAndLoginEvent:(id)sender;
@end

@implementation LoginViewController
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;
//    [AnimationTools pushViewControllerAnimatedWithViewController:self];
    [self initUI];
}
- (void)initUI{
    [self setupNaviBarWithTitle:@"登录"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Count_close_normal_"];
    
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 5.f;
    self.bottomView.layer.borderColor = LRRGBAColor(215, 215, 215, 1).CGColor;
    self.bottomView.layer.borderWidth = .5f;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 44, kMainScreenWidth-50.f, .5);
    lineView.backgroundColor = LRRGBAColor(215, 215, 215, 1);
    [_bottomView addSubview:lineView];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5.f;
    [self.forgetBtn setTitleColor:LRRGBAColor(103, 215, 195, 1) forState:0];
    self.forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.backgroundColor = [UIColor clearColor];
    [self.registerBtn setTitle:@"注册账号" forState:0];
    [self.registerBtn setTitleColor:LRRGBAColor(103, 215, 195, 1) forState:0];
    self.registerBtn.titleLabel.font = Font_14;
    CGRect registFrame = self.forgetBtn.frame;
    registFrame.origin.x = Orgin_x(_bottomView) - _bottomView.bounds.size.width;
    self.registerBtn.frame = registFrame;
//    self.registerBtn.frame = CGRectMake(26, kMainScreenHeight - 55, kMainScreenWidth - 52.f, 40);
    [self.registerBtn addTarget:self action:@selector(gotoRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.keyText];

    self.nameText.tag = 3000;
    self.nameText.keyboardType = UIKeyboardTypeNumberPad;
    self.nameText.delegate = self;
    _nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.keyText.delegate = self;
    self.keyText.tag = 3001;
    _keyText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.keyText.secureTextEntry = YES;
    
//    [self.view addSubview:self.loginView];
    
}
//#pragma mark -getters and seters
//- (ThirdPartyLoginView *)loginView
//{
//    if (!_loginView) {WEAKSELF;
//        _loginView = [[ThirdPartyLoginView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 40, kMainScreenWidth, 40) withPresentVC:self];
//        _loginView.delegate = self;
//        _loginView.frameBlock = ^(NSInteger index){
//            if (index == 1) {
//                [UIView animateWithDuration:0.25f animations:^{
//                    weakSelf.loginView.frame = CGRectMake(0, kMainScreenHeight - 130, kMainScreenWidth, 130);
//                }];
//            }else {
//                [UIView animateWithDuration:0.25f animations:^{
//                    weakSelf.loginView.frame = CGRectMake(0, kMainScreenHeight - 40, kMainScreenWidth, 40);
//                }];
//            }
//        };
//    }
//    return _loginView;
//}
#pragma mark -ThirdPartyLoginPro
- (void)ThirdPartyLoginSuccess
{
    BindingViewController *bindVC = [BindingViewController new];
    [self.navigationController pushViewController:bindVC animated:YES];
}
#pragma mark -手势
- (void)dismissKeyBoard{
    [self.view endEditing:YES];
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
- (void)rightBtnAction
{
    self.closeBlock();
    [self dismissViewControllerAnimated:YES completion:^{
  }];
}
- (void)gotoRegister:(id)sender
{
    RegisterViewController *registerVC  = [RegisterViewController new];
    registerVC.successRegisterBlock = ^(NSString *nameS,NSString *pawS){
        
        _nameText.text = nameS;
        _keyText.text = pawS;
    };
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)forgetAndLoginEvent:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSUInteger index = button.tag;
    
    switch (index) {
        case 1001:
        {//忘记密码
            FindKeyViewController *findVC = [FindKeyViewController new];
            findVC.findBlock = ^(NSString *phone){
                _nameText.text = phone;
            };
            [self.navigationController  pushViewController:findVC animated:YES];
        }
            break;
        case 1002:
        {//登录
            if (self.nameText.text.length <=0 && self.keyText.text.length<=0) {
                SHOW_ALERT(@"请您填写账号和密码");
                return;
            }else if ([QZManager isIncludeSpecialCharact:self.nameText.text] ==YES || [QZManager isIncludeSpecialCharact:self.keyText.text] == YES)
            {
                [JKPromptView showWithImageName:nil message:@"账号和密码包含非法字符，请您仔细检查"];
                return;
            }
            
            
            if ([QZManager isValidatePassword:_keyText.text] == NO)
            {
                [JKPromptView showWithImageName:nil message:@"密码为6-14位数字和字母组合，请您仔细检查"];
                return;
            }
            [SVProgressHUD showWithStatus:@"登录中..."];

            NSString *loginurl = [NSString stringWithFormat:@"%@%@mobile=%@&pw=%@",kProjectBaseUrl,LoginUrlString,_nameText.text,[_keyText.text md5]];
            [ZhouDao_NetWorkManger GetJSONWithUrl:loginurl success:^(NSDictionary *jsonDic) {
                [SVProgressHUD dismiss];
                NSUInteger errorcode = [jsonDic[@"state"] integerValue];
                NSString *msg = jsonDic[@"info"];
                if (errorcode !=1) {
                    [JKPromptView showWithImageName:nil message:msg];
                    return ;
                }
                [JKPromptView showWithImageName:nil message:msg];
                
                [USER_D setObject:_nameText.text forKey:StoragePhone];
                [USER_D setObject:[_keyText.text md5] forKey:StoragePassword];
                [USER_D synchronize];
                UserModel *model =[[UserModel alloc] initWithDictionary:jsonDic];
                [PublicFunction ShareInstance].m_user = model;
                [PublicFunction ShareInstance].m_bLogin = YES;
                
                // 给设备打上标签 和别名
                //                [UMessage addAlias:@"22222" type:@"ZDHF" response:^(id responseObject, NSError *error) {
                //                    DLog(@"888-----%@",responseObject);
                //                }];

                [UMessage setAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
                    
                    DLog(@"添加成功-----%@",responseObject);
                }];
                [UMessage addTag:[NSString stringWithFormat:@"type_%@",[PublicFunction ShareInstance].m_user.data.type]
                        response:^(id responseObject, NSInteger remain, NSError *error) {
                            DLog(@"添加标签成功-----%@",responseObject);
                        }];

//                [NetWorkMangerTools getaWekRemindsRequestSuccess:^{
//                    
//                }];

                [self rightBtnAction];
            } fail:^{
                [SVProgressHUD showErrorWithStatus:AlrertMsg];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark -第三方登录

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
