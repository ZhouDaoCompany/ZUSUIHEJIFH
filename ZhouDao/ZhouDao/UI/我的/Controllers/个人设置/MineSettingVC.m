//
//  MineSettingVC.m
//  ZhouDao
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "MineSettingVC.h"
#import "SettingTabCell.h"
#import "LCActionSheet.h"
#import "MyPickView.h"
#import "QHCommonUtil.h"
#import "ZHPickView.h"
#import "FindKeyViewController.h"
#import "ReplacePhoneVC.h"
#import "UMessage.h"
#import "ConsultantHeadView.h"

#import "PrivacyViewController.h"

/**
 *  认证
 *  #import "ImmediatelyVC.h"
 */

static NSString *const SettingIdentifer = @"SettingIdentifer";
static NSString *const TwoSettingIdentifer = @"TwoSettingIdentifer";

@interface MineSettingVC ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_titArrays;
    NSMutableArray *_msgArrays;
    UIImage *_headImage;//头像
    UIImageView *_mainBackgroundIV;
    NSArray *_imageArrays;

}
@property (strong,nonatomic) UITableView *tableView;

@end
@implementation MineSettingVC

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
#pragma mark - private methods
- (void)initUI
{
    [self setupNaviBarWithTitle:@"我"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    float folderSize = [self folderSizeAtPath:path];
    NSString *cacheString = @"";
    (folderSize <=0.01f)?(cacheString = @"0M"):(cacheString =[NSString stringWithFormat:@"%.2fM", folderSize]);
    
    self.view.backgroundColor = LRRGBColor(242, 242, 242);
    _imageArrays = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",nil];
    _titArrays = [NSArray arrayWithObjects:@"我的头像",@"我的账号",@"密码",@"通讯地址",@"我的职业",@"隐私设置",@"清理缓存", nil];
    
    NSString *pString = [PublicFunction ShareInstance].m_user.data.type;
    
    NSDictionary *typeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"执业律师",@"1",@"实习律师",@"2",@"公司法务",@"3",@"法律专业学生",@"4",@"公务员",@"5",@"其他",@"9", nil];
    NSString *typeString = typeDict[pString];
    
    NSString *address = @"请您选择地址";
    if (![[PublicFunction ShareInstance].m_user.data.address isEqualToString:@"--"]) {
       
        address = [PublicFunction ShareInstance].m_user.data.address;
    }

    _msgArrays = [NSMutableArray arrayWithObjects:@"",[PublicFunction ShareInstance].m_user.data.mobile,@"修改",address, typeString,@"",cacheString,nil];
    [ self.view addSubview:self.tableView];
   

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 75.f)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(26, 20, kMainScreenWidth - 52, 45);
    exitBtn.layer.masksToBounds = YES;
    exitBtn.layer.cornerRadius = 5.f;
    exitBtn.backgroundColor  = KNavigationBarColor;
    [exitBtn setTitleColor:[UIColor whiteColor] forState:0];
    [exitBtn setTitle:@"退出当前帐号" forState:0];
    exitBtn.titleLabel.font = Font_14;
    [exitBtn addTarget:self action:@selector(exitBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:exitBtn];
    _tableView.tableFooterView = footView;
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)?[_titArrays count]:3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSUInteger row = indexPath.row;
    SettingTabCell *cell = (SettingTabCell *)[tableView dequeueReusableCellWithIdentifier:TwoSettingIdentifer];
    cell.row = row;
    cell.section = indexPath.section;
    
    if (indexPath.section == 0) {
        cell.nameLab.text = _titArrays[row];
        cell.addresslab.text = _msgArrays[row];
        if (_headImage) {
            cell.headImg.image = _headImage;
        } else {
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[PublicFunction ShareInstance].m_user.data.photo] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        }
    }else {
        cell.ParentView = self;
    }
    [cell settingUI];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 80.f;
    }
    return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            [self addActionSheet];
        }else if (indexPath.row == 1){
            
            ReplacePhoneVC *VC = [ReplacePhoneVC new];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if (indexPath.row == 2){
            
            FindKeyViewController *findVC = [FindKeyViewController new];
            findVC.navTitle = @"修改密码";
            findVC.findBlock = ^(NSString *str){
            };
            [self.navigationController pushViewController:findVC animated:YES];
            
        }else if (indexPath.row == 3){
            
            //[self configureViewBlurWith:self.view.frame.size.width scale:0.8];
            UIWindow *windows = [UIApplication sharedApplication].windows[0];
            MyPickView *pickView = [[MyPickView  alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            pickView.pickBlock = ^(NSString *provice,NSString *city,NSString *area){
                DLog(@"地区是－－－%@:%@,%@",provice,city,area);
                NSString *tempStr = [NSString stringWithFormat:@"%@-%@-%@",provice,city,area];
                [NetWorkMangerTools resetUserAddress:tempStr RequestSuccess:^{
                    
                    [_msgArrays replaceObjectAtIndex:3 withObject:tempStr];
                    [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            [windows addSubview:pickView];
            
        }else if (indexPath.row == 4){
            [NetWorkMangerTools getApplyInfoRequestSuccess:^{
                
                [weakSelf requestMyCertification];
            }];
        }else if (indexPath.row == 6){
            
            LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"确定"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
                
                DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
                if (buttonIndex == 0) {
                    [weakSelf clearApplicationCaChe];
                }
            }];
            [sheet show];
        }else if (indexPath.row == 5){
            
            PrivacyViewController *privacyVC = [PrivacyViewController new];
            [self.navigationController pushViewController:privacyVC animated:YES];
        }
  
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.f) withSection:section];
    headView.delBtn.hidden = YES;
    [headView setLabelText:@"账号绑定"];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0)?15.f:45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
#pragma mark -
#pragma mark - 解除 绑定 和绑定

#pragma mark -查询认证审核
- (void)requestMyCertification
{WEAKSELF;
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:@[@"执业律师",@"实习律师",@"公司法务",@"法律专业学生",@"公务员",@"其他"] title:@"选择职业"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr,NSString *type)
    {
        [NetWorkMangerTools resetUserJobInfo:type RequestSuccess:^{
            [_msgArrays replaceObjectAtIndex:4 withObject:selectedStr];
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
            
            [PublicFunction ShareInstance].m_user.data.type = type;
            
            /***************************认证*************************************/
//            weakSelf.profBlock();
//            if ([selectedStr isEqualToString:@"执业律师"])
//            {
//                ImmediatelyVC *vc = [ImmediatelyVC new];
//                vc.cerType = FrommMineSetting;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }
        }];

    };
}
#pragma mark -UIButtonEvent
- (void)exitBtnEvent:(id)sender
{
    WEAKSELF;
    
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"退出帐号" buttonTitles:@[@"退出"] redButtonIndex:0 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
        if (buttonIndex == 0) {
            [USER_D removeObjectForKey:StoragePhone];
            [USER_D removeObjectForKey:StoragePassword];
            [USER_D removeObjectForKey:StorageTYPE];
            [USER_D removeObjectForKey:StorageUSID];
            [USER_D removeObjectForKey:keyIdentifer];
            [USER_D removeObjectForKey:SearchIdentifer];
            [USER_D synchronize];

            //删除别名
            [UMessage removeAlias:[NSString stringWithFormat:@"uid_%@",UID] type:@"ZDHF" response:^(id responseObject, NSError *error) {
                DLog(@"移除成功-----%@",responseObject);
            }];
            //删除所有标签
            [UMessage removeAllTags:^(id  _Nonnull responseObject, NSInteger remain, NSError * _Nonnull error) {
                DLog(@"移除标签成功-----%@",responseObject);
            }];
            //清空闹铃
            //        [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            [PublicFunction ShareInstance].m_bLogin = NO;
            [PublicFunction ShareInstance].m_user = nil;
            if (weakSelf.exitBlock) {
                weakSelf.exitBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    }];
    [sheet show];

    
//    ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"您确定退出登录吗?" withType:DelType];
//    delWindow.DelBlock = ^(){
//    };
//    [self.view addSubview:delWindow];
}
- (void)addActionSheet
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
        DLog(@"> Block way -> Clicked Index: %ld", (long)buttonIndex);
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
                kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                    
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.delegate = self;
                    imagePickerController.showsCameraControls = YES;//是否显示照相机标准的控件库
                    [imagePickerController setAllowsEditing:YES];//是否加入照相后预览时的编辑功能
                    kDISPATCH_MAIN_THREAD(^{
                        
                        [self presentViewController:imagePickerController animated:YES completion:nil];
                    });
                });
            }
        }
            break;
        case 1:
        {//从相册选择一张
            kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;
                kDISPATCH_MAIN_THREAD(^{
                    
                    [self presentViewController:picker animated:YES completion:^{
//                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                    }];
                });
            });
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {//UIImagePickerControllerOriginalImage

        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"]; // 裁剪后的图片
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存相册
        });
        _headImage = image;
    }

    [self uploadHeaderImageItemClick];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
//    [picker dismissViewControllerAnimated:YES completion:^{
//    }];
//    _headImage = image;
//    [self uploadHeaderImageItemClick];
//}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [navigationController.viewControllers count] <=2) {
//        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBarHidden = NO;
        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
        navigationController.navigationBar.backgroundColor = hexColor(353535);
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }else {
        navigationController.navigationBarHidden = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}
- (void)uploadHeaderImageItemClick
{   WEAKSELF;
    if (_headImage >0) {
//        CGSize imgSize = CGSizeMake(80, 80);
//        _headImage = [QZManager compressOriginalImage:photoArr[0] toSize:imgSize];
     
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            
            [NetWorkMangerTools getQiNiuToken:NO RequestSuccess:^{
                
                [NetWorkMangerTools uploadUserHeadImg:_headImage RequestSuccess:^{
                    
                    kDISPATCH_MAIN_THREAD((^{
                        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                    }));

                } fail:^{
                    _headImage = nil;
                }];
            }];
            
        });
        
    }
}
#pragma mark - 查询文件
-(float )folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)clearApplicationCaChe{WEAKSELF;
    [MBProgressHUD showMBLoadingWithText:@"清理中..."];
    [[SDImageCache sharedImageCache] cleanDisk];
//    [ZhouDao_NetWorkManger clearCaches]; //很少不用清除
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        DLog(@"files :%lu",(unsigned long)[files count]);
        [files enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:obj];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf clearCacheSuccess];
        });
    });

}
- (void)clearCacheSuccess
{
    [MBProgressHUD hideHUD];
    [JKPromptView showWithImageName:nil message:LOCCLEARCACHE];
    [_msgArrays replaceObjectAtIndex:5 withObject:@"0M"];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark - setters and getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight - 64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView  registerClass:[SettingTabCell class] forCellReuseIdentifier:TwoSettingIdentifer];
    }
    return _tableView;
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
