//
//  NewlyCreatedVC.m
//  ZhouDao
//
//  Created by cqz on 16/5/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "NewlyCreatedVC.h"
#import "DetaillistModel.h"
@interface NewlyCreatedVC ()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (strong, nonatomic) UILabel *placeholdLab;
@property (strong, nonatomic) UITextView *contentTextView;

@end

@implementation NewlyCreatedVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
#pragma mark - methods
- (void)initUI{
    
    if (_pid.length == 0) {
        _pid = @"";
    }
    [self setupNaviBarWithTitle:@"新建文本"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"提交" img:nil];
    self.rightBtn.titleLabel.font = Font_16;
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(10, 84, 60, 20)];
    namelab.font = Font_15;
    namelab.text = @"名字:";
    [self.view addSubview:namelab];
    
    
    [self.view addSubview:self.nameTextField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 124, kMainScreenWidth, 0.6f)];
    lineView.backgroundColor = LINECOLOR;
    [self.view addSubview:lineView];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(10, Orgin_y(lineView) + 10.f, 60, 20)];
    contentLab.font = Font_15;
    contentLab.text = @"内容:";
    [self.view addSubview:contentLab];

    [self.view addSubview:self.contentTextView];

    [_contentTextView addSubview:self.placeholdLab];
}
#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    DLog(@"去搜索");
    [_nameTextField resignFirstResponder];
    return true;
}
- (void)textFieldChanged:(NSNotification*)noti{
    
    UITextField *textField = (UITextField *)noti.object;
    
    BOOL flag=[NSString isContainsTwoEmoji:textField.text];
    if (flag){
        textField.text = [NSString disable_emoji:textField.text];
    }
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0){
        self.placeholdLab.text =  @"请输入内容";
    } else {
        self.placeholdLab.text = @"";
    }
}
- (void)rightBtnAction
{WEAKSELF;
    if (_nameTextField.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您输入文本名称"];
        return;
    }
    if (_contentTextView.text.length == 0) {
        [JKPromptView showWithImageName:nil message:@"请您输入文本内容"];
        return;
    }
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,_caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *namePath = [NSString stringWithFormat:@"%@/%@.txt",casePath,_nameTextField.text];
//    if ([FILE_M fileExistsAtPath:namePath]) {
//        [JKPromptView showWithImageName:nil message:@"该文本名已存在，请修改文本名字"];
//        return;
//    }
    NSString *name = [NSString stringWithFormat:@"%@.txt",_nameTextField.text];
    NSString *textFilePath = [casePath stringByAppendingPathComponent:name];
    DLog(@"路径打印出来－－－－%@",textFilePath);
    [_contentTextView.text writeToFile:textFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [FILE_M contentsAtPath:textFilePath];
    
    kDISPATCH_GLOBAL_QUEUE_DEFAULT((^{
        
        [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
            
            [NetWorkMangerTools uploadarrangeFile:data withFormatType:@"txt" RequestSuccess:^(NSString *key) {
                
                [NetWorkMangerTools arrangeFileAddwithPid:_pid withName:weakSelf.nameTextField.text withFileType:@"1" withtformat:@"3" withqiniuName:key withCid:_caseId RequestSuccess:^(id obj) {
                    
                    kDISPATCH_MAIN_THREAD((^{
                        
                        DetaillistModel *model = (DetaillistModel *)obj;
                        //上传成功后 把文件名字修改为id名字
                        [FILE_M removeItemAtPath:namePath error:nil];
                        NSString *textFilePath = [casePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",model.id]];
                        [weakSelf.contentTextView.text writeToFile:textFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        weakSelf.creatSuccess();
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }));
                }];
            } fail:^{
                
                [FILE_M removeItemAtPath:textFilePath error:nil];
            }];
        }];
    }));
}

#pragma mark - setter and getter

- (UITextField *)nameTextField {
    
    if (!_nameTextField) {
        
        _nameTextField =[[UITextField alloc] initWithFrame:CGRectMake(89.f, 79.f, kMainScreenWidth - 25.f, 30)];
        _nameTextField.placeholder = @"请输入文本名称";
        _nameTextField.delegate = self;
        _nameTextField.font = Font_15;
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.returnKeyType = UIReturnKeyDone; //设置按键类型
        [_nameTextField becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_nameTextField];
    }
    return _nameTextField;
}
- (UITextView *)contentTextView {
    
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 165.f, kMainScreenWidth -20.f, 240)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.font = Font_15;
        _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _contentTextView.keyboardType = UIKeyboardTypeDefault;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}
- (UILabel *)placeholdLab {
    
    if (!_placeholdLab) {
        _placeholdLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30.f)];
        _placeholdLab.text =  @"请输入内容";
        _placeholdLab.font = Font_15;
        _placeholdLab.textColor = SIXCOLOR;
    }
    return _placeholdLab;
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
