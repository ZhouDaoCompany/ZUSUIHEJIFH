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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
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
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 10, self.view.bounds.size.width, self.view.bounds.size.height-10) style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:mainTable];
    
    [self readPhotoGroup];

}
#pragma mark - 相机
- (void)initCameraStyle
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        SHOW_ALERT(@"模拟其中无法打开照相机,请在真机中使用");
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
    
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        imageView.tag = imageViewTag;
        [cell.contentView addSubview:imageView];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
        textLabel.tag = textLabelTag;
        [cell.contentView addSubview:textLabel];
        UILabel *detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 30)];
        detailTextLabel.tag = detailTextLabelTag;
        [detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:detailTextLabel];
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{WEAKSELF;
    [picker dismissViewControllerAnimated:NO completion:nil];
    //打印出字典中的内容
    //DMLog( info );
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {//UIImagePickerControllerOriginalImage
        UIImage* GetImage = [info objectForKey:@"UIImagePickerControllerEditedImage"]; // 裁剪后的图片
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            UIImageWriteToSavedPhotosAlbum(GetImage, nil, nil, nil);//保存相册
        });
        
        if ([weakSelf.delegate respondsToSelector:@selector(sendImageWithAssetsArray:)])
        {
            [weakSelf.delegate sendImageWithAssetsArray:[[NSArray alloc] initWithObjects:GetImage, nil]];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }

    }
}
#pragma mark - SGMPhotosViewControllerDelegate

- (BOOL)sendImageWithALassetArray:(NSArray *)array
{
   __block NSMutableArray *arr = [NSMutableArray array];
    if (array) {
        
        [array enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ALAsset *asset = objDict[@"asset"];
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            [arr addObject:image];
        }];

    }
    if ([self.delegate respondsToSelector:@selector(sendImageWithAssetsArray:)]) {
        [self.delegate sendImageWithAssetsArray:arr];
        return YES;
    }
    return NO;
}

@end
