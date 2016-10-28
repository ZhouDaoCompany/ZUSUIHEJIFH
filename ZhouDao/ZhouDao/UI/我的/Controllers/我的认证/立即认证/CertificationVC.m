//
//  CertificationVC.m
//  ZhouDao
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CertificationVC.h"
#import "SGMAlbumViewController.h"
#import "LCActionSheet.h"

@interface CertificationVC ()<SGMAlbumViewControllerDelegate>
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
        _isSelect = YES;
        _bgImgView.image =cameraImage;
    }else {
        _isSelect = YES;
        ALAsset *asset = [assetArrays[0] objectForKey:@"asset"];
        UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        _bgImgView.image =image;
    }
}

#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    if (_isSelect == YES) {
        UIImage *image = _bgImgView.image;
        self.imgBlock(image);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [JKPromptView showWithImageName:nil message:LOCSELECTPICTURE];
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
