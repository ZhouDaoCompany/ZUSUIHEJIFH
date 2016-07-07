//
//  TheCaseDetailVC.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//
#import "TheCaseDetailVC.h"
#import "KxMenu.h"
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
#import "CollectEmptyView.h"

//下载
#import "TaskModel.h"
#import "DownLoadView.h"
//财务管理
#import "CaseFIViewController.h"
#import "CasesRemindVC.h"

#import "ParallaxHeaderView.h"

static NSString *const headCellIdentifier = @"headCellIdentifier";
static NSString *const caseCellIdentifier = @"caseCellIdentifier";
#define kHeaderImageHeight     126.f

@interface TheCaseDetailVC ()<UITableViewDataSource,UITableViewDelegate,CaseDetailTabCellPro,WHC_ChoicePictureVCDelegate,WHC_CameraVCDelegate,DownLoadViewPro>
{
    float _contentOffsetY;
}
@property (nonatomic,strong) CollectEmptyView *emptyView;   //无案件时候

@property (strong,nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath* openedIndexPath;
@property (nonatomic, strong) NSMutableArray* tableData;
@property (nonatomic, assign) BOOL isMove;//是否可以移动
@property (nonatomic, strong)ParallaxHeaderView *headView;
@property (nonatomic, strong)  UILabel *namelab;

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
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    _contentOffsetY = 0.f;
    
    //数据
    self.tableData = [NSMutableArray array];
    self.emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0,171.5f, kMainScreenWidth, kMainScreenHeight-171.5f) WithText:@"暂无案件文件"];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];


    [self creatTabHeadView];
    [self loadListViewData];
}
#pragma mark - 表头
-(void)creatTabHeadView
{
    self.headView = [ParallaxHeaderView parallaxHeaderViewWithImage:[UIImage imageNamed:@"case_detailHead.jpg"]
                                                            forSize:CGSizeMake(kMainScreenWidth, kHeaderImageHeight)];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(80, 42, kMainScreenWidth - 160.f, 42.f)];
    namelab.textAlignment = NSTextAlignmentCenter;
    namelab.text = _caseName;
    namelab.textColor=[UIColor whiteColor];
    namelab.font=Font_18;
    namelab.numberOfLines = 0;
    _namelab = namelab;
    [_headView addSubview:_namelab];
    
    _tableView.tableHeaderView = self.headView;

}
#pragma mark - 数据请求
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
    if (scrollView == _tableView)
    {
        [(ParallaxHeaderView*)_tableView.tableHeaderView  layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }

}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    (self.tableData.count == 0)?[self.tableView addSubview:self.emptyView]:[self.emptyView removeFromSuperview];
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
            casecell.indexRow = indexPath.row +1;
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
#pragma mark -Event Respose
- (void)rightBtnAction
{

    NSArray *titArr = @[@"查看案件详情",@"案件提醒管理",@"案件财务管理"];
    NSArray *imgArr = @[@"case_lookicon",@"case_alerticon",@"case_moneyicon"];
    [self showMenu:self.rightBtn withTitArr:titArr withImgArr:imgArr withBool:YES];

}
- (void)getMoreEvent:(UIButton *)sender
{
    DLog(@"加号按钮被点击");
    /**
     *  @"wi-fi传输" case_wifi
     */
    NSArray *titArr = @[@"新建文件夹 ",@"新建文本  ",@"拍照上传  ",@"上传照片  "];
    NSArray *imgArr = @[@"case_xjwjj",@"case_xjwb",@"case_paiZhao",@"case_shangC"];
    [self showMenu:sender withTitArr:titArr withImgArr:imgArr withBool:NO];
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
    if (isRight == NO) {
        frame.origin.y = frame.origin.y - _contentOffsetY +self.tableView.tableHeaderView.frame.size.height +64.f;
    }
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{WEAKSELF;
    KxMenuItem *kx = (KxMenuItem *)sender;
    DLog(@"%@", kx.title);

    if ([kx.title isEqualToString:@"新建文件夹 "]) {
        ZD_DeleteWindow *delWindow = [[ZD_DeleteWindow alloc] initWithFrame:kMainScreenFrameRect withTitle:@"" withType:RenameType];
        delWindow.renameBlock = ^(NSString *name){
            [NetWorkMangerTools arrangeFileAddwithPid:@"" withName:name withFileType:@"2" withtformat:@"" withqiniuName:@"" withCid:_caseId RequestSuccess:^(id obj) {
                [weakSelf loadListViewData];
            }];
        };
        [self.view addSubview:delWindow];
    }else if ([kx.title isEqualToString:@"新建文本  "]){
        NewlyCreatedVC *vc = [NewlyCreatedVC new];
        vc.creatSuccess = ^(){
            [weakSelf loadListViewData];
        };
        vc.caseId = _caseId;
        [self.navigationController  pushViewController:vc animated:YES];
    }else if ([kx.title isEqualToString:@"拍照上传  "]){
        WHC_CameraVC * vc = [WHC_CameraVC new];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }else if ([kx.title isEqualToString:@"上传照片  "]){
        //从相册选择一张
        WHC_PictureListVC  * vc = [WHC_PictureListVC new];
        vc.delegate = self;
        vc.maxChoiceImageNumberumber = 1;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    }else if ([kx.title isEqualToString:@"查看案件详情"]){

        [self loadCaseDetailRequest];
        
    }else if ([kx.title isEqualToString:@"案件提醒管理"]){

        CasesRemindVC *remindVc = [CasesRemindVC new];
        remindVc.caseId = _caseId;
        [self.navigationController pushViewController:remindVc animated:YES];

    }else if ([kx.title isEqualToString:@"案件财务管理"]){
        
        CaseFIViewController *vc = [CaseFIViewController new];
        vc.caseId = _caseId;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)loadCaseDetailRequest
{WEAKSELF;
    [NetWorkMangerTools arrangeInfoWithIdString:_caseId RequestSuccess:^(NSDictionary *dict) {
        
        EditCaseVC *vc = [EditCaseVC new];
        if(_type == 0){//非讼业务
            vc.editType  = EditAccusing;
        }else if(_type == 1){//法律顾问
            vc.editType  = EditConsultant;
        }else{//诉讼业务
            vc.editType  = EditLitigation;
        }
        vc.dataDict = dict;
        vc.editSuccess = ^(NSString *name){
            
            weakSelf.namelab.text = name;
        };
        vc.caseId = _caseId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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
