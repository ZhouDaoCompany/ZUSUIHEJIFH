//
//  CasesDirectoryVC.m
//  ZhouDao
//
//  Created by cqz on 16/5/19.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CasesDirectoryVC.h"
#import "CaseDetailTabCell.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "ToolsWedViewVC.h"
#import "SGMAlbumViewController.h"
#import "NewlyCreatedVC.h"
#import "KxMenu.h"
#import "SDPhotoBrowser.h"
#import "ZD_AlertWindow.h"

//下载
#import "TaskModel.h"
#import "DownLoadView.h"

static NSString *const caseCellIdentifier = @"caseCellIdentifier";

@interface CasesDirectoryVC ()<UITableViewDataSource,UITableViewDelegate,CaseDetailTabCellPro,SGMAlbumViewControllerDelegate,DownLoadViewPro,SDPhotoBrowserDelegate,ZD_AlertWindowPro>
{
    UIImage *_photoImage;
}
@property (strong, nonatomic)   UITableView *tableView;
@property (nonatomic, strong)  NSIndexPath* openedIndexPath;
@property (nonatomic, strong)  NSMutableArray* tableData;
@property (nonatomic, copy)    NSString *imgURLStrng;

@end

@implementation CasesDirectoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}
- (void)initUI
{
    _openedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];

    [self setupNaviBarWithTitle:_name];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"mine_addNZ"];
    //数据
    self.tableData = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    //请求
    [self loadListViewData];
}
- (void)loadListViewData
{WEAKSELF;
    [NetWorkMangerTools arrangeFileListWithType:_pid withCid:_caseId RequestSuccess:^(NSArray *arr) {
        
        [weakSelf.tableData removeAllObjects];
        [weakSelf.tableData addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView registerClass:[CaseDetailTabCell class] forCellReuseIdentifier:caseCellIdentifier];
    CaseDetailTabCell *cell = (CaseDetailTabCell *)[tableView dequeueReusableCellWithIdentifier:caseCellIdentifier];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CaseDetailTabCell class]])
    {
        CaseDetailTabCell *casecell = (CaseDetailTabCell *)cell;
        if (_tableData.count >0) {
            casecell.indexRow = indexPath.row +1;
            [casecell setListModel:_tableData[indexPath.row]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaillistModel *model = _tableData[indexPath.row];
    CaseDetailTabCell *cCell = (CaseDetailTabCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self checkTheFile:model withCell:cCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _openedIndexPath.row) {
        return 115.f;
    }
    return 45.f;
}
#pragma mark-CaseDetailTabCellPro
- (void)ExpandOrCloseWithCell:(UITableViewCell *)aCell
{
    CaseDetailTabCell *cell = (CaseDetailTabCell *)aCell;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];//坑比
    
    DLog(@"indexPath.row == %ld",(long)indexPath.row);
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tableView beginUpdates];
    if (_openedIndexPath.row  == indexPath.row) {
        _openedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    }else{
        _openedIndexPath = indexPath;
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}
- (void)otherEvent:(NSUInteger)tag withCell:(UITableViewCell *)aCell
{
    CaseDetailTabCell *cell = (CaseDetailTabCell *)aCell;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];//坑比
    DetaillistModel *model = _tableData[indexPath.row];
    switch (tag) {
        case 1001:
        {
            [self checkTheFile:model withCell:cell];
        }
            break;
        case 1002:
        {//下载
            [self downLoadMethods:model];
        }
            break;
        case 1003:
        {

        }
            break;
        case 1004:
        {
            ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleRename withTitle:model.id withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:indexPath];
            alertWindow.tag = 6009;
            [self.view addSubview:alertWindow];
        }
            break;
        case 1005:
        {
            ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleDEL withTitle:@"确定删除吗?" withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:indexPath];
            alertWindow.tag = 6010;
            [self.view addSubview:alertWindow];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -UIButtonEvent
- (void)rightBtnAction
{
    /**
     *  @"wi-fi传输" case_wifi
     */
    NSArray *titArr = @[@"新建文件夹 ",@"新建文本  ",@"拍照上传  ",@"上传照片  "];
    NSArray *imgArr = @[@"case_xjwjj",@"case_xjwb",@"case_paiZhao",@"case_shangC"];
    [self showMenu:self.rightBtn withTitArr:titArr withImgArr:imgArr withBool:NO];

}
- (void)showMenu:(UIButton *)sender
      withTitArr:(NSArray *)titArr
      withImgArr:(NSArray *)imgArr withBool:(BOOL)isRight
{
    
    NSMutableArray *menuItems =[NSMutableArray array];
    
    [titArr enumerateObjectsUsingBlock:^(NSString *tit, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [menuItems addObject:[KxMenuItem menuItem:titArr[idx]
                                            image:[UIImage imageNamed:imgArr[idx]]
                                           target:self
                                           action:@selector(pushMenuItem:)]];
    }];
    
    [menuItems enumerateObjectsUsingBlock:^(KxMenuItem *first, NSUInteger idx, BOOL * _Nonnull stop) {
        first.foreColor = thirdColor;
    }];
    
    [KxMenu setTitleFont:Font_13];
    
    CGRect frame = sender.frame;

//     frame.origin.y = frame.origin.y - 20;
    frame = CGRectMake(kMainScreenWidth - 44.f, 20, 44, 44);

    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{WEAKSELF;
    KxMenuItem *kx = (KxMenuItem *)sender;
    DLog(@"%@", kx.title);
    
    if ([kx.title isEqualToString:@"新建文件夹 "]) {
        
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleRename withTitle:@"" withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:nil];
        alertWindow.tag = 6012;
        [self.view addSubview:alertWindow];
        
    }else if ([kx.title isEqualToString:@"新建文本  "]){
        NewlyCreatedVC *vc = [NewlyCreatedVC new];
        vc.caseId = _caseId;
        vc.pid = _pid;
        vc.creatSuccess = ^(){
            [weakSelf loadListViewData];
        };
        [self.navigationController  pushViewController:vc animated:YES];
    }else if ([kx.title isEqualToString:@"拍照上传  "]){
        SGMAlbumViewController* viewVC = [SGMAlbumViewController new];
        [viewVC setDelegate:self];
        viewVC.style =  SGMAlbumStyleCamera;
        [self presentViewController:viewVC animated:YES completion:nil];
    }else if ([kx.title isEqualToString:@"上传照片  "]){
        //从相册选择一张
        SGMAlbumViewController* viewVC = [[SGMAlbumViewController alloc] init];
        [viewVC setDelegate:self];
        viewVC.style =  SGMAlbumStyleAlbum;
        viewVC.limitNum = 1;//不设置即不限制
        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [JKPromptView showWithImageName:nil message:@"此功能还在开发中"];
    }
}
#pragma mark -查看文件
- (void)checkTheFile:(DetaillistModel *)model withCell:(CaseDetailTabCell *)cCell
{
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,_caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if ([model.type_file isEqualToString:@"1"]) {
        NSString *format = [NetWorkMangerTools getFileFormat:model.type_format];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",casePath,model.id,format];
        if ([FILE_M fileExistsAtPath:filePath]) {
            NSURL *lastUrl = [[NSURL alloc] initFileURLWithPath:filePath];
            NSString *htmlString = [lastUrl absoluteString];
            [self checkPhotoFile:htmlString withImgView:cCell withModel:model withFormat:format];
        }else{
            [NetWorkMangerTools arrangeFileInfoWithid:model.id withCaseId:_caseId RequestSuccess:^(NSString *htmlString) {
                [self checkPhotoFile:htmlString withImgView:cCell withModel:model withFormat:format];
            }];
        }
    }else{
        CasesDirectoryVC *vc = [CasesDirectoryVC new];
        vc.name = model.name;
        vc.caseId = _caseId;//案件唯一id
        vc.pid = model.id;
        vc.filePath = casePath;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - private methods
- (void)checkPhotoFile:(NSString *)urlString withImgView:(CaseDetailTabCell *)cell withModel:(DetaillistModel *)model withFormat:(NSString *)format
{
    if ([format isEqualToString:@"jpg"]) {
        
        _imgURLStrng = urlString;
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.imageCount = 1; // 图片总数
        browser.currentImageIndex = 0;
        browser.delegate = self;
        browser.sourceImagesContainerView = cell; // 原图的父控件
        [browser show];
        
    }else {
        
        ToolsWedViewVC *vc = [ToolsWedViewVC new];
        vc.url = urlString;
        vc.tType = FromCaseType;
        vc.navTitle = model.name;
        vc.format = format;
        [self.navigationController  pushViewController:vc animated:YES];
    }
}
#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return kGetImage(@"home_Shuff");
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [_imgURLStrng stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

#pragma mark -下载
- (void)downLoadMethods:(DetaillistModel *)model
{
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,_caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    TaskModel *tmodel = [TaskModel model];
    NSString *format = [NetWorkMangerTools getFileFormat:model.type_format];
    tmodel.name=[NSString stringWithFormat:@"%@.%@",model.id,format];
    //    tmodel.url= htmlString;
    tmodel.destinationPath=[_filePath stringByAppendingPathComponent:tmodel.name];
    BOOL exist=[[NSFileManager defaultManager] fileExistsAtPath:tmodel.destinationPath];
    if(exist)
    {
        [JKPromptView showWithImageName:nil message:@"此文件已经存在"];
        return;
    }
    [NetWorkMangerTools arrangeFileInfoWithid:model.id withCaseId:_caseId RequestSuccess:^(NSString *htmlString) {
        
        tmodel.url = htmlString;
        DownLoadView *downView = [[DownLoadView alloc] initWithFrame:kMainScreenFrameRect];
        [self.view addSubview:downView];
        downView.tag = 6207;
        downView.format = model.type_format;
        downView.delegate = self;
        downView.model = tmodel;
    }];
}
#pragma mark -DownLoadViewPro
- (void)getDownloadState:(NSString *)downStr readPath:(NSString *)path
{
    if ([downStr isEqualToString:@"完成"])
    {
        [JKPromptView showWithImageName:nil message:@"下载完成"];
        DownLoadView *downView = (DownLoadView *)[self.view viewWithTag:6207];
        [downView removeFromSuperview];
    }
}
#pragma mark -照片上传
#pragma mark - SGMAlbumViewControllerDelegate
- (BOOL)sendImageWithAssetsArray:(NSArray *)array
{
    if (array.count>0) {
        _photoImage = array[0];
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleRename withTitle:@"确定删除吗?" withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:nil];
        alertWindow.tag = 6011;
        [self.view addSubview:alertWindow];
        return YES;
    }
    return NO;
}
#pragma mark  ZD_AlertWindowPro
- (void)alertView:(ZD_AlertWindow *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withName:(NSString *)name withIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    DetaillistModel *model = nil;
    if (indexPath) {
        model =  _tableData[indexPath.row];
    }
    
    if (alertView.tag == 6009) {//重命名
        
        [NetWorkMangerTools arrangeFileRenameWithid:model.id withCaseId:_caseId withName:name RequestSuccess:^{
            
            model.name = name;
            [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    } else if (alertView.tag == 6010){//删除
        
        [NetWorkMangerTools arrangeFileDelWithid:model.id withCaseId:_caseId RequestSuccess:^{
            NSString *path = DownLoadCachePath;
            if (![FILE_M fileExistsAtPath:path]) {
                [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,_caseId];
            if (![FILE_M fileExistsAtPath:casePath]) {
                [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *format = [NetWorkMangerTools getFileFormat:model.type_format];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",casePath,model.id,format];
            if ([FILE_M fileExistsAtPath:filePath]) {
                [FILE_M removeItemAtPath:filePath error:nil];
            }
            
            [weakSelf.tableView beginUpdates];
            [self.tableData removeObjectAtIndex:indexPath.row];
            _openedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [weakSelf.tableView endUpdates];
        }];

    } else if (alertView.tag == 6011) {//照片
        
        kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
            [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
                __block NSData *data = UIImageJPEGRepresentation(_photoImage, .5f);

                [NetWorkMangerTools uploadarrangeFile:data withFormatType:@"image/jpeg" RequestSuccess:^(NSString *key) {
                    
                    [NetWorkMangerTools arrangeFileAddwithPid:_pid withName:name withFileType:@"1" withtformat:@"4" withqiniuName:key withCid:_caseId RequestSuccess:^(id obj) {
                        
                        kDISPATCH_MAIN_THREAD((^{
                            [weakSelf loadListViewData];
                        }));
                    }];
                } fail:^{
                }];
            }];
        });
    } else if (alertView.tag == 6012) {//文件夹重命名
        [NetWorkMangerTools arrangeFileAddwithPid:_pid withName:name withFileType:@"2" withtformat:@"" withqiniuName:@"" withCid:_caseId RequestSuccess:^(id obj) {
            
            [weakSelf loadListViewData];
        }];
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
