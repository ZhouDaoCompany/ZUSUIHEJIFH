//
//  TheCaseDetailVC.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "TheCaseDetailVC.h"
#import "KxMenu.h"
#import "CommonDetailHead.h"
#import "EditCaseVC.h"
#import "CaseDetailTabCell.h"
#import "ZD_DeleteWindow.h"
#import "ShareView.h"
#import "MenuLabel.h"
#import "ToolsWedViewVC.h"
#import "WHC_PhotoListCell.h"
#import "WHC_PictureListVC.h"
#import "WHC_CameraVC.h"
#import "NewlyCreatedVC.h"
#import "CasesDirectoryVC.h"
//下载
#import "TaskModel.h"
#import "DownLoadView.h"

static NSString *const headCellIdentifier = @"headCellIdentifier";
static NSString *const caseCellIdentifier = @"caseCellIdentifier";

@interface TheCaseDetailVC ()<UITableViewDataSource,UITableViewDelegate,CaseDetailTabCellPro,WHC_ChoicePictureVCDelegate,WHC_CameraVCDelegate,DownLoadViewPro>
{
    float _contentOffsetY;
}
@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath* openedIndexPath;
@property (nonatomic, strong) NSMutableArray* tableData;
@property (nonatomic, strong) CommonDetailHead *headView;
@property (nonatomic, assign) BOOL isMove;//是否可以移动
@end

@implementation TheCaseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI
{
    _openedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    [self setupNaviBarWithTitle:@"案件详情"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"case_edit"];
    _contentOffsetY = 0.f;
    
    //数据
    self.tableData = [NSMutableArray array];

    [self creatTabHeadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headView;
//    //添加长按手势
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
//    [self.tableView addGestureRecognizer:longPress];
    
    [self loadListViewData];
}
#pragma  mark -表头
- (void)creatTabHeadView
{
    HeadType type;
    if(_type == 0){
        type  = AccusingHead;
    }else if(_type == 1){
        type  = ConsultantHead;
    }else{
        type  = LitigationHead;
    }
    _headView = [[CommonDetailHead alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 125) withArr:_msgArrays withType:type];
    WEAKSELF;
    _headView.comBlock = ^(CGFloat afloat){
        weakSelf.headView.frame = CGRectMake(0, 0, kMainScreenWidth, afloat);
        [weakSelf.tableView beginUpdates];
        weakSelf.tableView.tableHeaderView = weakSelf.headView;
        [weakSelf.tableView endUpdates];
    };
}
- (void)loadListViewData
{WEAKSELF;
    [self.tableData removeAllObjects];
    [NetWorkMangerTools arrangeFileListWithType:@"" withCid:_caseId RequestSuccess:^(NSArray *arr) {
        [weakSelf.tableData addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _contentOffsetY = _tableView.contentOffset.y;
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
            [casecell setListModel:_tableData[indexPath.row]];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaillistModel *model = _tableData[indexPath.row];
    [self checkTheFile:model];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _openedIndexPath.row) {
        return 115.f;
    }
    return 45.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getSectionHead];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 45.5f;
    }
    return 0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark-CaseDetailTabCellPro
- (void)ExpandOrCloseWithCell:(UITableViewCell *)aCell
{
    CaseDetailTabCell *cell = (CaseDetailTabCell *)aCell;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];//坑比

    DLog(@"indexPath.row == %ld",(long)indexPath.row);
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_tableView beginUpdates];
    if (_openedIndexPath  == indexPath) {
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
    WEAKSELF;
    switch (tag) {
        case 1001:
        {
            [self checkTheFile:model];
        }
            break;
        case 1002:
        {//下载
            [self downLoadMethods:model];
        }
            break;
        case 1003:
        {
            NSString *title = @"周道慧法";
            NSString *contentString = @"案件详情";
            NSString *url = @"http://www.iswifting.com";
            NSArray *arrays = [NSArray arrayWithObjects:title,contentString,url, nil];
            [ShareView CreatingPopMenuObjectItmes:ShareObjs contentArrays:arrays withPresentedController:self SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
                
            }];
        }
            break;
        case 1004:
        {
            ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"" withType:RenameType];
            delWindow.renameBlock = ^(NSString *name){
                [NetWorkMangerTools arrangeFileRenameWithid:model.id withCaseId:_caseId withName:name RequestSuccess:^{
                    model.name = name;
                    [weakSelf.tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            [self.view addSubview:delWindow];
        }
            break;
        case 1005:
        {
            ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"确定删除吗?" withType:DelType];
            delWindow.DelBlock = ^(){
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
            };
            [self.view addSubview:delWindow];
        }
            break;

        default:
            break;
    }
}
- (UIView *)getSectionHead
{
    //案件目录
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 45.5f)];
    views.backgroundColor = [UIColor whiteColor];
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake((kMainScreenWidth -100)/2.f, 0, 100, 45.f)];
    titLab.text = @"案件目录";
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.textColor = thirdColor;
    titLab.font = Font_17;
    [views addSubview:titLab];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(kMainScreenWidth -40 , 7.5f, 30, 30);
    moreBtn.backgroundColor = [UIColor whiteColor];
    [moreBtn setImage:[UIImage imageNamed:@"case_add"] forState:0];
    [moreBtn addTarget:self action:@selector(getMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:moreBtn];
    
    UIView *laselineView = [[UIView alloc] initWithFrame:CGRectMake(0, Orgin_y(titLab), kMainScreenWidth , .5f)];
    laselineView.backgroundColor = lineColor;
    [views addSubview:laselineView];

    return views;
}
#pragma mark -UIButtonEvent
- (void)rightBtnAction
{WEAKSELF;
    EditCaseVC *vc = [EditCaseVC new];
    if(_type == 0){//非讼业务
        vc.editType  = EditAccusing;
    }else if(_type == 1){//法律顾问
        vc.editType  = EditConsultant;
    }else{//诉讼业务
        vc.editType  = EditLitigation;
    }
    vc.editSuccess = ^(NSMutableArray *arr){
        _msgArrays = arr;
        [weakSelf creatTabHeadView];
        weakSelf.tableView.tableHeaderView = _headView;
    };
    vc.caseId = _caseId;
    vc.msgArrays = _msgArrays;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getMoreEvent:(UIButton *)sender
{
    DLog(@"加号按钮被点击");
    [self showMenu:sender];
}
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"新建文件夹"
                     image:[UIImage imageNamed:@"case_xjwjj"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"新建文本"
                     image:[UIImage imageNamed:@"case_xjwb"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"拍照上传"
                     image:[UIImage imageNamed:@"case_paiZhao"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"上传照片"
                     image:[UIImage imageNamed:@"case_shangC"]
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"wi-fi传输"
                     image:[UIImage imageNamed:@"case_wifi"]
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    for (KxMenuItem *first in menuItems) {
        first.foreColor = thirdColor;
    }
        [KxMenu setTitleFont:Font_13];
    
    CGRect frame = sender.frame;
    frame.origin.y = frame.origin.y - _contentOffsetY +self.tableView.tableHeaderView.frame.size.height +64.f;
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{WEAKSELF;
    KxMenuItem *kx = (KxMenuItem *)sender;
    DLog(@"%@", kx.title);

    if ([kx.title isEqualToString:@"新建文件夹"]) {
        ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"" withType:RenameType];
        delWindow.renameBlock = ^(NSString *name){
            [NetWorkMangerTools arrangeFileAddwithPid:@"" withName:name withFileType:@"2" withtformat:@"" withqiniuName:@"" withCid:_caseId RequestSuccess:^(id obj) {
                [weakSelf loadListViewData];
            }];
        };
        [self.view addSubview:delWindow];
    }else if ([kx.title isEqualToString:@"新建文本"]){
        NewlyCreatedVC *vc = [NewlyCreatedVC new];
        vc.creatSuccess = ^(){
            [weakSelf loadListViewData];
        };
        vc.caseId = _caseId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else if ([kx.title isEqualToString:@"拍照上传"]){
        WHC_CameraVC * vc = [WHC_CameraVC new];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([kx.title isEqualToString:@"上传照片"]){
        //从相册选择一张
        WHC_PictureListVC  * vc = [WHC_PictureListVC new];
        vc.delegate = self;
        vc.maxChoiceImageNumberumber = 1;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }else{
        [JKPromptView showWithImageName:nil message:@"此功能还在开发中"];
    }
}
#pragma mark -照片上传
#pragma mark - WHC_ChoicePictureVCDelegate
- (void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr{         UIImage *image = photoArr[0];
    WEAKSELF;
   __block NSData *data = UIImageJPEGRepresentation(image, .5f);
    
    ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"" withType:RenameType];
    delWindow.renameBlock = ^(NSString *name){
        //[QZManager stringFromDate:[NSDate date]]
        [NetWorkMangerTools getQiNiuToken:YES RequestSuccess:^{
            [NetWorkMangerTools uploadarrangeFile:data withFormatType:@"image/jpeg" RequestSuccess:^(NSString *key) {
                [NetWorkMangerTools arrangeFileAddwithPid:@"" withName:name withFileType:@"1" withtformat:@"4" withqiniuName:key withCid:_caseId RequestSuccess:^(id obj) {
                    [weakSelf loadListViewData];
                }];
            } fail:^{
            }];
        }];
    };
    [self.view addSubview:delWindow];

}
#pragma mark - WHC_CameraVCDelegate
- (void)WHCCameraVC:(WHC_CameraVC *)cameraVC didSelectedPhoto:(UIImage *)photo{
    [self WHCChoicePictureVC:nil didSelectedPhotoArr:@[photo]];
}
#pragma mark -移动cell
#pragma mark - 方法实现
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (_openedIndexPath.row>-1) {
        NSUInteger row = _openedIndexPath.row;
        _openedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    UILongPressGestureRecognizer *longPress = gestureRecognizer;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0;
                    // Black out.
                    //                    cell.backgroundColor = [UIColor whiteColor];
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // ... update data source.
                [self.tableData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1;
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
                sourceIndexPath = nil;
            }];
            break;
        }
    }
}


- (UIView *)customSnapshotFromView:(UIView *)inputView {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
#pragma mark -查看文件
- (void)checkTheFile:(DetaillistModel *)model
{WEAKSELF;
    NSString *path = DownLoadCachePath;
    if (![FILE_M fileExistsAtPath:path]) {
        [FILE_M createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *casePath = [NSString stringWithFormat:@"%@/%@",path,_caseId];
    if (![FILE_M fileExistsAtPath:casePath]) {
        [FILE_M createDirectoryAtPath:casePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *format = [NetWorkMangerTools getFileFormat:model.type_format];

    if ([model.type_file isEqualToString:@"1"]) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@",casePath,model.id,format];
        if ([FILE_M fileExistsAtPath:filePath]) {
            NSURL *lastUrl = [[NSURL alloc] initFileURLWithPath:filePath];
            NSString *htmlString = [lastUrl absoluteString];
            ToolsWedViewVC *vc = [ToolsWedViewVC new];
            vc.url = htmlString;
            vc.tType = FromCaseType;
            vc.navTitle = model.name;
            vc.format = format;
            [self.navigationController  pushViewController:vc animated:YES];
        }else{
            [NetWorkMangerTools arrangeFileInfoWithid:model.id withCaseId:_caseId RequestSuccess:^(NSString *htmlString) {
                ToolsWedViewVC *vc = [ToolsWedViewVC new];
                vc.url = htmlString;
                vc.tType = FromCaseType;
                vc.navTitle = model.name;
                vc.format = format;
                [weakSelf.navigationController  pushViewController:vc animated:YES];
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
    tmodel.destinationPath=[casePath stringByAppendingPathComponent:tmodel.name];
    
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
        downView.tag = 3873;
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
        DownLoadView *downView = (DownLoadView *)[self.view viewWithTag:3873];
        [downView removeFromSuperview];
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
