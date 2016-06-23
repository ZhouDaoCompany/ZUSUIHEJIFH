//
//  CertificationVC.m
//  ZhouDao
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CertificationVC.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "WHC_CameraVC.h"
#import "LCActionSheet.h"

@interface CertificationVC ()<WHC_ChoicePictureVCDelegate,WHC_CameraVCDelegate>
{
    BOOL _isSelect;//是否选择了图片

}
@property (nonatomic,strong) UIImageView *bgImgView;//执业证

@end

@implementation CertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    [self setupNaviBarWithTitle:@"立即认证"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    [self setupNaviBarWithBtn:NaviRightBtn title:@"完成" img:nil];
    self.rightBtn.titleLabel.font = Font_15;
//    self.fd_interactivePopDisabled = YES;

    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 84, kMainScreenWidth-50.f, 280)];
    _bgImgView.image = [UIImage imageNamed:@"login_lice.jpg"];
    [self.view addSubview:_bgImgView];
    _bgImgView.userInteractionEnabled = YES;
    
    UILabel *alertLab = [[UILabel alloc] initWithFrame:CGRectMake(25, Orgin_y(_bgImgView) +10, kMainScreenWidth-50.f, 20)];
    alertLab.text = @"请按照此图上传图片";
    alertLab.font = Font_14;
    alertLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:alertLab];
    
     [self addActionSheet];
    [_bgImgView whenTapped:^{
        [self addActionSheet];
    }];
}
- (void)addActionSheet
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        NSLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        
        [self selectCameraOrPhotoList:buttonIndex];
    }];
    
    [sheet show];

}
#pragma mark -选择相机
- (void)selectCameraOrPhotoList:(NSUInteger)index
{
    switch (index)
    {
        case 0:
        {//从相机选择
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                SHOW_ALERT(@"亲，您的设备没有摄像头-_-!!");
            }else{
                
                WHC_CameraVC * vc = [WHC_CameraVC new];
                vc.delegate = self;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
            break;
        case 1:
        {//从相册选择一张
            WHC_PictureListVC  * vc = [WHC_PictureListVC new];
            vc.delegate = self;
            vc.maxChoiceImageNumberumber = 1;
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}
#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{
    if (photoArr.count >0) {
        _isSelect = YES;
        _bgImgView.image = photoArr[0];
    }
    //    for (NSInteger i = 0; i < photoArr.count; i++) {
    //        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * CGRectGetWidth(_imageSV.frame), 0, CGRectGetWidth(_imageSV.frame), CGRectGetHeight(_imageSV.frame))];
    //        imageView.image = photoArr[i];
    //        [_imageSV addSubview:imageView];
    //    }
    //    _imageSV.contentSize = CGSizeMake(photoArr.count * CGRectGetWidth(_imageSV.frame), 0);
}

#pragma mark - WHC_CameraVCDelegate
- (void)WHCCameraVC:(WHC_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    
    _isSelect = YES;
      _bgImgView.image = photo;
    //[self WHCChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    if (_isSelect == YES) {
        UIImage *image = _bgImgView.image;
        self.imgBlock(image);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [JKPromptView showWithImageName:nil message:@"请您选择图片"];
    }
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
