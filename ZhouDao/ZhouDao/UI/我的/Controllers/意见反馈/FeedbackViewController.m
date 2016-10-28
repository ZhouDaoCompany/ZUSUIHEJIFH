//
//  FeedbackViewController.m
//  ZhouDao
//
//  Created by cqz on 16/3/13.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SGMAlbumViewController.h"
#import "LCActionSheet.h"

@interface FeedbackViewController ()<UITextViewDelegate,SGMAlbumViewControllerDelegate>
{

}

@property (nonatomic,strong) UITextView *msgText;
@property (nonatomic,strong) UILabel *placeLab;
@property (nonatomic,strong) UITextField *phoneTextF;
@property (nonatomic,strong) UIScrollView *picScrolView;//图片
@property (nonatomic,strong) NSMutableArray *imgArrays;//图片数组

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    self.imgArrays = [NSMutableArray array];
    [self setupNaviBarWithBackAndTitle:@"意见反馈"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:@"" img:@"backVC"];
    self.view.backgroundColor = LRRGBColor(241, 242, 243);
    UILabel *thankLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 84, kMainScreenWidth - 30.f, 50)];
    thankLab.text = @"欢迎您提出宝贵的建议，您留下来的每个字都将用来改善我们的软件。我们由衷的对您表示感谢！";
    thankLab.numberOfLines = 0;
    thankLab.font = Font_14;
    thankLab.textColor = LRRGBColor(49, 50, 51);
    [self.view addSubview:thankLab];
    
    _msgText = [[UITextView alloc] initWithFrame:CGRectMake(15, Orgin_y(thankLab) +15, kMainScreenWidth - 30, 120)];
    _msgText.delegate =self;
    _msgText.font = Font_14;
    _msgText.backgroundColor = [UIColor whiteColor];
    _msgText.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
    _msgText.layer.borderWidth = 1.f;
    [self.view addSubview:_msgText];
    
    _placeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, Orgin_y(thankLab) +20, 160, 20)];
    _placeLab.backgroundColor = [UIColor clearColor];
    _placeLab.font = Font_14;
    _placeLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_placeLab];
    _placeLab.text = @"  请输入您的意见";

    _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, Orgin_y(_msgText) +15 , kMainScreenWidth - 30.f, 40)];
    _phoneTextF.backgroundColor = [UIColor whiteColor];
    _phoneTextF.borderStyle = UITextBorderStyleNone;
    _phoneTextF.layer.borderColor = LRRGBColor(214, 215, 216).CGColor;
    _phoneTextF.layer.borderWidth = 1.f;
    _phoneTextF.font = Font_14;
    _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextF.placeholder = @"  请输入手机号";
    [self.view addSubview:_phoneTextF];
    
    [self selectPhotoMethod];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [submitBtn setTitle:@"提交" forState:0];
    submitBtn.frame = CGRectMake(15, Orgin_y(_picScrolView) + 15, kMainScreenWidth - 30, 40);
    submitBtn.backgroundColor = KNavigationBarColor;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 5.f;
    [submitBtn addTarget:self action:@selector(submitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

}
- (void)selectPhotoMethod
{
    [_picScrolView removeFromSuperview];
    _picScrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, Orgin_y(_phoneTextF) + 15, kMainScreenWidth - 30, 90.f)];
    _picScrolView.backgroundColor = [UIColor clearColor];

    CGSize sizeWidth = _picScrolView.frame.size;

    for (int i=0; i<_imgArrays.count; i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(80.0f*i + 10*i,5,80.f,80.f)];
        //[iv setImage:_appendArray[i] borderWidth:5.0 shadowDepth:10.0 controlPointXOffset:30.0 controlPointYOffset:70.0];
        iv.backgroundColor = [UIColor clearColor];
        iv.tag = i+3000;
        iv.userInteractionEnabled = YES;
        [iv setImage:_imgArrays[i]];
        UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonClose.frame = CGRectMake(60, -5, 25, 25);
        buttonClose.tag = 3000 + i;
        [buttonClose setBackgroundImage:[UIImage imageNamed:@"close_icon_highlight"] forState:UIControlStateNormal];
        [buttonClose addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [iv addSubview:buttonClose];

        [_picScrolView addSubview:iv];
        iv = nil;
    }
    UIButton  *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSUInteger count = _imgArrays.count;
    if (_imgArrays.count < 1)
    {
        addButton.frame = CGRectMake(_imgArrays.count *80.f+ 10*_imgArrays.count, 5, 80, 80);
        [addButton setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(goToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [_picScrolView addSubview:addButton];
        count += 1;
    }
    
    [_picScrolView setContentSize:CGSizeMake(80.0f * count + 10*count, sizeWidth.height)];

    [self.view addSubview:_picScrolView];

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
        self.placeLab.text = @"  请输入您的意见";
    }else{
        self.placeLab.text = @"";
    }
}
#pragma mark -UIButtonEvent
- (void)submitBtnEvent:(id)sender
{
    DLog(@"提交资料");
    WEAKSELF;
    if (_msgText.text.length == 0) {
        [JKPromptView showWithImageName:nil message:LOCFILLCONTENE];
        return;
    }
    NSString *phoneS = [PublicFunction ShareInstance].m_user.data.mobile;
    
    if (_phoneTextF.text.length > 0) {
        if (_phoneTextF.text.length != 11  || [QZManager isPureInt:_phoneTextF.text] == NO) {
            [JKPromptView showWithImageName:nil message:LOCRIGHTPHONE];
            return;
        }
        phoneS = _phoneTextF.text;
    }
    
    if (_imgArrays.count == 0)
    {
        [NetWorkMangerTools feedBackWithImage:nil withPhone:phoneS withContent:_msgText.text RequestSuccess:^{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [NetWorkMangerTools getQiNiuToken:NO RequestSuccess:^{
                
                [NetWorkMangerTools feedBackWithImage:_imgArrays[0] withPhone:phoneS withContent:_msgText.text RequestSuccess:^{
                    
                    kDISPATCH_MAIN_THREAD((^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }));
                }];
            }];
        });
    }
}
#pragma mark -提交
#pragma mark -选取照片
- (void)goToPhotoAlbum:(id)sender
{
    [self dismissKeyBoard];

    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        
        [self selectCameraOrPhotoList:buttonIndex];
    }];
    
    [sheet show];
}
//删除图片
- (void) deletePhoto:(id)sender
{
    [self dismissKeyBoard];
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    
    for (UIImageView *currentSubView in _picScrolView.subviews)
    {
        if (deletedPhoto == currentSubView.tag)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_imgArrays removeObjectAtIndex:deletedPhoto-3000];
                for (UIImageView *imgView in _picScrolView.subviews)
                {
                    [imgView removeFromSuperview];
                }
                [self selectPhotoMethod];
            });
        }
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
    }else {
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
        [self.imgArrays addObjectsFromArray:@[cameraImage]];
    }else {
        ALAsset *asset = [assetArrays[0] objectForKey:@"asset"];
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        [self.imgArrays addObjectsFromArray:@[image]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self selectPhotoMethod];
    });

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
