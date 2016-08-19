//
//  SGMAlbumViewController.m
//  WeiXinPhoto
//
//  Created by 苏贵明 on 15/9/4.
//  Copyright (c) 2015年 苏贵明. All rights reserved.
//

#import "SGMAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define imageViewTag        20
#define textLabelTag        30
#define detailTextLabelTag  40

@interface SGMAlbumViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)ALAssetsLibrary *assetsLibrary;   //图片库

@end

@implementation SGMAlbumViewController{

    UITableView* mainTable;
    NSMutableArray* groupArray;
    NSMutableArray* groupImageArray;
    UIImagePickerController   *  _cameraVC;

//    SelectedBlock block;

}
@synthesize assetsLibrary,limitNum;

//-(void)doSelectedBlock:(SelectedBlock)bl{
//    block = bl;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_style ==  SGMAlbumStyleAlbum) {//相册
        
        [self initAlbumStyle];
    } else {
        [self initCameraStyle];
    }


}
#pragma mark - 相册
- (void)initAlbumStyle
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片";

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.backgroundColor = hexColor(353535);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//
//    self.navigationController.navigationBar.translucent = NO;//关键代码

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(cancelBtTap)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:nil];
    
    
    groupArray = [[NSMutableArray alloc]init];
    groupImageArray = [[NSMutableArray alloc] init];
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 5, self.view.bounds.size.width, self.view.bounds.size.height-5) style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTable];
    
    [self readPhotoGroup];

}
#pragma mark - 相机
- (void)initCameraStyle
{
    self.view.backgroundColor = [UIColor clearColor];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        _cameraVC = [[UIImagePickerController alloc]init];
        _cameraVC.delegate = self;
        _cameraVC.allowsEditing = NO;
        _cameraVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _cameraVC.view.frame = self.view.bounds;
        [self.view addSubview:_cameraVC.view];
    }else
    {
        SHOW_ALERT(@"模拟其中无法打开照相机,请在真机中使用");
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
-(void)readPhotoGroup{
   assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
       //相册
        if (group != nil) {
            [groupArray addObject:group];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            __weak typeof(tempArray)weaktempArray = tempArray;
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (index == 0) {
                    __strong typeof(weaktempArray) strongWeaktempArray = weaktempArray;
                    if (result!= nil) {
                        [strongWeaktempArray addObject: [UIImage imageWithCGImage:result.aspectRatioThumbnail]];
                    }
                }
            }];
            if ([tempArray firstObject]!=nil) {
                [groupImageArray addObject:[tempArray firstObject]];
            }
            else
            {
                [groupImageArray addObject:[UIImage imageWithCGImage:group.posterImage]];
            }
            
        }else{
            [mainTable reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"相册获取失败");
    }];
}

-(void)cancelBtTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return groupArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
        imageView.tag = imageViewTag;
        [cell.contentView addSubview:imageView];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
        textLabel.tag = textLabelTag;
        [cell.contentView addSubview:textLabel];
        UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 30)];
        detailTextLabel.tag = detailTextLabelTag;
        [detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:detailTextLabel];
        
        UIImageView *jiantouimg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 24, 32.5f, 9, 15)];
        jiantouimg.userInteractionEnabled = YES;
        jiantouimg.image = [UIImage imageNamed:@"mine_jiantou"];
        [cell.contentView addSubview:jiantouimg];

    }
    ALAssetsGroup *group = [groupArray objectAtIndex:(groupArray.count-1) - indexPath.row];
    UIImage *groupImage = [groupImageArray objectAtIndex:(groupArray.count-1) - indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];//过滤视频
    
    NSString* name =[group valueForProperty:ALAssetsGroupPropertyName];
    if ([name  isEqual: @"Camera Roll"]) {
        name = @"相机胶卷";
    }
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:imageViewTag];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:groupImage];
    
    UILabel *textLabel = (UILabel*)[cell.contentView viewWithTag:textLabelTag];
    textLabel.text = name;
    
    UILabel *detailTextLabel = (UILabel*)[cell.contentView viewWithTag:detailTextLabelTag];
    detailTextLabel.text = [NSString stringWithFormat:@"%d",(int)[group numberOfAssets]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SGMPhotosViewController* viewVC = [[SGMPhotosViewController alloc]init];
    viewVC.group =[groupArray objectAtIndex:(groupArray.count-1) - indexPath.row];
    viewVC.limitNum = limitNum;
    viewVC.delegate = self;
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - cameraPhotoDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{WEAKSELF;
    
    [self dismissViewControllerAnimated:YES completion:^{
        //打印出字典中的内容
        //DMLog( info );
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"])
        {//UIImagePickerControllerOriginalImage UIImagePickerControllerEditedImage
            UIImage* GetImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; // 裁剪后的图片
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                UIImageWriteToSavedPhotosAlbum(GetImage, nil, nil, nil);//保存相册
            });
            
            if ([weakSelf.delegate respondsToSelector:@selector(sendImageWithcameraArray:withStyle:withAccessArrays:)])
            {
                [weakSelf.delegate sendImageWithcameraArray:@[GetImage] withStyle:SGMAlbumStyleCamera withAccessArrays:nil];

                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }];
}
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [navigationController.viewControllers count] <=2) {
//        navigationController.navigationBar.translucent = NO;
//        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        navigationController.navigationBarHidden = NO;
//        navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    }else {
//        navigationController.navigationBarHidden = YES;
//    }
//}

#pragma mark - SGMPhotosViewControllerDelegate

- (BOOL)sendImageWithALassetArray:(NSArray *)array
{
    __block NSMutableArray *arr = [NSMutableArray array];
    __block NSMutableArray *thumbnailArr = [NSMutableArray array];
    if (array) {
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ALAsset *asset = objDict[@"asset"];
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            UIImage *thumbImage = [UIImage imageWithCGImage:asset.thumbnail];
            [arr addObject:image];
            [thumbnailArr addObject:thumbImage];
        }];

    }
    if ([self.delegate respondsToSelector:@selector(sendImageWithcameraArray:withStyle:withAccessArrays:)])
    {
        [self.delegate sendImageWithAssetsArray:arr withStyle:SGMAlbumStyleAlbum withThumbnailArrays:thumbnailArr withFileNameArrays:<#(NSArray *)#>];
        return YES;
    }
    return NO;
}
- (void)dealloc
{
    _cameraVC = nil;
    TTVIEW_RELEASE_SAFELY(mainTable);
}
@end
