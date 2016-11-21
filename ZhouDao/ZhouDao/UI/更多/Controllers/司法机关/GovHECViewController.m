//
//  GovHECViewController.m
//  ZhouDao
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "GovHECViewController.h"
#import "GcNoticeUtil.h"
#import "SGMAlbumViewController.h"
#import "LCActionSheet.h"

@interface GovHECViewController ()<UITextFieldDelegate,UITextViewDelegate,SGMAlbumViewControllerDelegate>
{
    UIImage *_photoImage;//图片
}
/** 下面的内容栏 */
@property (strong, nonatomic)  UIScrollView *bottomScrollView;
@property (strong, nonatomic)  UILabel *nameLab;
@property (strong, nonatomic)  UILabel *nameLab1;
@property (strong, nonatomic)  UILabel *addressLab;
@property (strong, nonatomic)  UITextField *addressText;
@property (strong, nonatomic)  UILabel *phoneLab;
@property (strong, nonatomic)  UITextField *phoneText;
@property (strong, nonatomic)  UILabel *photoLab;
@property (strong, nonatomic)  UIButton *photoImgBtn;
@property (strong, nonatomic)  UIButton *buttonClose;
@property (strong, nonatomic)  UILabel *introLab;//备注
@property (strong, nonatomic)  UILabel *introPlaceLab;
@property (strong, nonatomic)  UITextView *introText;
@property (strong, nonatomic)  UIButton *commitBtn;

@end

@implementation GovHECViewController
- (void)dealloc
{
    [GcNoticeUtil removeAllNotification:self];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"资料纠错"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self.view addSubview:self.bottomScrollView];

    [self.bottomScrollView addSubview:self.nameLab];
    [self.bottomScrollView addSubview:self.nameLab1];
    [self.bottomScrollView addSubview:self.addressLab];
    [self.bottomScrollView addSubview:self.addressText];
    [self.bottomScrollView addSubview:self.phoneLab];
    [self.bottomScrollView addSubview:self.phoneText];
    [self.bottomScrollView addSubview:self.photoLab];
    [self.bottomScrollView addSubview:self.photoImgBtn];
    [self.bottomScrollView addSubview:self.buttonClose];
    self.buttonClose.hidden = YES;
    
    [self.bottomScrollView addSubview:self.introLab];
    [self.bottomScrollView addSubview:self.introText];
    [self.introText addSubview:self.introPlaceLab];
    [self.bottomScrollView addSubview:self.commitBtn];
    
    self.bottomScrollView.contentSize = CGSizeMake(kMainScreenWidth, Orgin_y(_commitBtn) + 50.f);
}

#pragma mark - event response
- (void)deletePhoto:(UIButton *)btn
{
    DLog(@"删除照片");
    _buttonClose.hidden = YES;
    _photoImage = nil;
    [_photoImgBtn setImage:kGetImage(@"compose_pic_add") forState:0];
}
- (void)selectPhotoEvent:(UIButton *)btn
{
    DLog(@"选择图片");
    [self dismissKeyBoard];
    
    if (_photoImage) {
        return;
    }
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        
        [self selectCameraOrPhotoList:buttonIndex];
    }];
    
    [sheet show];
}
- (void)commitBtnEvent:(UIButton *)btn
{WEAKSELF;
    if (_introText.text.length == 0 && _addressText.text.length == 0 && _photoImage == nil && _phoneText.text.length == 0) {
        [JKPromptView showWithImageName:nil message:LOCSETDATE];
        return;
    }
    
    if (_photoImage) {


        kDISPATCH_GLOBAL_QUEUE_DEFAULT((^{
            
            __block NSData *data = UIImageJPEGRepresentation(_photoImage, .5f);
            
            [NetWorkMangerTools getQiNiuToken:NO RequestSuccess:^{
                
                [NetWorkMangerTools uploadarrangeFile:data withFormatType:@"image/jpeg" RequestSuccess:^(NSString *key) {
                    
                    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&address=%@&tel=%@&pic=%@remark=%@",kProjectBaseUrl,ErrorCorrectionURL,_model.id,GET(_addressText.text),GET(_phoneText.text),GET(key),GET(_introText.text)];
                    
                    [NetWorkMangerTools arrangeFinanceDelWithUrl:urlString RequestSuccess:^{
                        
                        kDISPATCH_MAIN_THREAD((^{
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }));
                    }];
                    
                } fail:^{
                }];
            }];
            
        }));

    } else {
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@&address=%@&tel=%@&pic=%@remark=%@",kProjectBaseUrl,ErrorCorrectionURL,_model.id,GET(_addressText.text),GET(_phoneText.text),@"",GET(_introText.text)];

        [NetWorkMangerTools arrangeFinanceDelWithUrl:urlString RequestSuccess:^{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark -选择相机
- (void)selectCameraOrPhotoList:(NSUInteger)index
{
    SGMAlbumViewController* viewVC = [SGMAlbumViewController new];
    [viewVC setDelegate:self];
    if (index == 0) {
        viewVC.style =  SGMAlbumStyleCamera;
        [self presentViewController:viewVC animated:YES completion:nil];
    }else if(index == 1){
        viewVC.style =  SGMAlbumStyleAlbum;
        viewVC.limitNum = 1;//不设置即不限制
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - SGMAlbumViewControllerDelegate
- (void)sendImageWithcameraImage:(UIImage *)cameraImage withStyle:(SGMAlbumStyle)style withAssetArrays:(NSArray *)assetArrays
{
    if (style == SGMAlbumStyleCamera) {
        _photoImage =cameraImage;
    }else {
        ALAsset *asset = [assetArrays[0] objectForKey:@"asset"];
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        _photoImage =image;
    }
    [_photoImgBtn setImage:_photoImage forState:0];
    _buttonClose.hidden = NO;
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
}
#pragma mark - UITextViewDelegate
//通过委托来放弃第一响应者
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
    if (textView.text.length == 0){
        self.introPlaceLab.text = @"  请输入您的意见";
    }else{
        self.introPlaceLab.text = @"";
    }
}
#pragma mark - setters and getters
- (UIScrollView *)bottomScrollView
{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64.f, kMainScreenWidth, kMainScreenHeight-64.f)];
        _bottomScrollView.delegate = self;
    }
    return _bottomScrollView;
}
- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 75.f, 20)];
        _nameLab.font = Font_15;
        _nameLab.text = @"名称";
        _nameLab.textColor = hexColor(333333);
    }
    return _nameLab;
}
- (UILabel *)nameLab1
{
    if (!_nameLab1) {
        _nameLab1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, kMainScreenWidth - 105.f, 20)];
        _nameLab1.font = Font_15;
        _nameLab1.text = _model.name;
        _nameLab1.textColor = hexColor(999999);
    }
    return _nameLab1;
}
- (UILabel *)addressLab
{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(_nameLab) + 25.f, 75.f, 32)];
        _addressLab.font = Font_15;
        _addressLab.text = @"地址";
        _addressLab.textColor = hexColor(333333);
    }
    return _addressLab;
}
- (UITextField *)addressText
{
    if (!_addressText) {
        _addressText = [[UITextField alloc] initWithFrame:CGRectMake(90, Orgin_y(_nameLab) +25.f , kMainScreenWidth - 105.f, 32)];
        _addressText.backgroundColor = [UIColor whiteColor];
        _addressText.borderStyle = UITextBorderStyleNone;
        _addressText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _addressText.layer.borderWidth = 1.f;
        _addressText.font = Font_14;
        _addressText.placeholder = @" 输入新的地址";
        [_addressText setValue:hexColor(999999) forKeyPath:@"_placeholderLabel.textColor"];
        [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:self.addressText];
    }
    return _addressText;
}
- (UILabel *)phoneLab
{
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(_addressLab) + 18.f, 75.f, 32)];
        _phoneLab.font = Font_15;
        _phoneLab.text = @"电话";
        _phoneLab.textColor = hexColor(333333);
    }
    return _phoneLab;
}
- (UITextField *)phoneText
{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc] initWithFrame:CGRectMake(90, Orgin_y(_addressLab) +18.f , kMainScreenWidth - 105.f, 32)];
        _phoneText.backgroundColor = [UIColor whiteColor];
        _phoneText.borderStyle = UITextBorderStyleNone;
        _phoneText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _phoneText.layer.borderWidth = 1.f;
        _phoneText.font = Font_14;
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.placeholder = @" 输入新的电话";
        [_phoneText setValue:hexColor(999999) forKeyPath:@"_placeholderLabel.textColor"];
        [GcNoticeUtil handleNotification:UITextFieldTextDidChangeNotification Selector:@selector(textFieldChanged:) Observer:self Object:self.phoneText];
    }
    return _phoneText;
}
- (UILabel *)photoLab
{
    if (!_photoLab) {
        _photoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(_phoneLab) + 40.f, 75.f, 20)];
        _photoLab.font = Font_15;
        _photoLab.text = @"上传照片";
        _photoLab.textColor = hexColor(333333);
    }
    return _photoLab;
}
- (UIButton *)photoImgBtn
{
    if (!_photoImgBtn) {
        _photoImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoImgBtn.frame = CGRectMake(90, Orgin_y(_phoneLab) + 18.f, 72, 64);
        [_photoImgBtn setImage:kGetImage(@"compose_pic_add") forState:0];
        [_photoImgBtn addTarget:self action:@selector(selectPhotoEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoImgBtn;
}
- (UIButton *)buttonClose
{
    if (!_buttonClose) {
        _buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonClose.frame = CGRectMake(142.f, Orgin_y(_phoneLab) + 13.f, 25, 25);
        [_buttonClose setImage:kGetImage(@"close_icon_highlight") forState:UIControlStateNormal];
        [_buttonClose addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonClose;
}
- (UILabel *)introLab
{
    if (!_introLab) {
        _introLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(_photoImgBtn) + 80.f, 75.f, 32)];
        _introLab.font = Font_15;
        _introLab.text = @"备注";
        _introLab.textColor = hexColor(333333);
    }
    return _introLab;
}
- (UITextView *)introText
{
    if (!_introText) {
        _introText = [[UITextView alloc] initWithFrame:CGRectMake(90, Orgin_y(_photoImgBtn) +18, kMainScreenWidth - 105, 145.f)];
        _introText.delegate =self;
        _introText.font = Font_14;
        _introText.backgroundColor = [UIColor whiteColor];
        _introText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
        _introText.layer.borderWidth = 1.f;
    }
    return _introText;
}
- (UILabel *)introPlaceLab
{
    if (!_introPlaceLab) {
        _introPlaceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 3.f, kMainScreenWidth - 105, 20)];
        _introPlaceLab.backgroundColor = [UIColor clearColor];
        _introPlaceLab.font = Font_14;
        _introPlaceLab.text = @" 请输入您的意见";
        _introPlaceLab.textColor = hexColor(999999);
    }
    return _introPlaceLab;
}
- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_commitBtn setTitle:@"提交" forState:0];
        _commitBtn.frame = CGRectMake(15, Orgin_y(_introText) + 40, kMainScreenWidth - 30, 45);
        _commitBtn.backgroundColor = KNavigationBarColor;
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.layer.cornerRadius = 5.f;
        [_commitBtn addTarget:self action:@selector(commitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
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
