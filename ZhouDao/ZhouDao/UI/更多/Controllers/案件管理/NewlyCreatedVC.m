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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
}
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
    
    _nameTextField =[[UITextField alloc] initWithFrame:CGRectMake(Orgin_x(namelab) +5.f, 79.f, kMainScreenWidth - Orgin_x(namelab) -15.f, 30)];
    _nameTextField.placeholder = @"请输入文本名称";
    _nameTextField.delegate = self;
    _nameTextField.font = Font_15;
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.returnKeyType = UIReturnKeyDone; //设置按键类型
    [self.view addSubview:_nameTextField];
    [_nameTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_nameTextField];
    /**
     内容
     */
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 124, kMainScreenWidth, 0.6f)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    UILabel *contentLab = [[UILabel alloc] initWithFrame:CGRectMake(10, Orgin_y(lineView) + 10.f, 60, 20)];
    contentLab.font = Font_15;
    contentLab.text = @"内容:";
    [self.view addSubview:contentLab];

    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, Orgin_y(contentLab) + 10.f, kMainScreenWidth -20.f, kMainScreenHeight - Orgin_y(contentLab) -60.f)];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.font = Font_14;
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.keyboardType = UIKeyboardTypeDefault;
    _contentTextView.delegate = self;
    [self.view addSubview:_contentTextView];

    _placeholdLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20.f)];
    _placeholdLab.text =  @"请输入内容";
    _placeholdLab.font = Font_14;
    _placeholdLab.textColor = sixColor;
    [_contentTextView addSubview:_placeholdLab];
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

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        self.placeholdLab.text =  @"请输入内容";
    }else
    {
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
    [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
        [NetWorkMangerTools uploadarrangeFile:data withFormatType:@"txt" RequestSuccess:^(NSString *key) {
            [NetWorkMangerTools arrangeFileAddwithPid:_pid withName:weakSelf.nameTextField.text withFileType:@"1" withtformat:@"3" withqiniuName:key withCid:_caseId RequestSuccess:^(id obj) {
                DetaillistModel *model = (DetaillistModel *)obj;
                //上传成功后 把文件名字修改为id名字
                [FILE_M removeItemAtPath:namePath error:nil];
                NSString *textFilePath = [casePath stringByAppendingPathComponent:model.id];
                [_contentTextView.text writeToFile:textFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                weakSelf.creatSuccess();
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } fail:^{
            [FILE_M removeItemAtPath:textFilePath error:nil];
        }];
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
