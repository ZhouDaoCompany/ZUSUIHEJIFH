//
//  UploadMorephontosVC.m
//  ProgressView
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 QZ. All rights reserved.
//

#import "UploadMorephontosVC.h"
#import "UploadTableViewCell.h"
#import "ConsultantHeadView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZD_AlertWindow.h"

static NSString *const UPLOADPHOTOIDENTIFER = @"UploadMorephontosid";
@interface UploadMorephontosVC ()<UITableViewDelegate,UITableViewDataSource,UploadTableViewPro,ZD_AlertWindowPro,SWTableViewCellDelegate>
{
    BOOL _isStart;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *completeArrays;//上传完成数组
@property (strong, nonatomic) NSMutableArray *uploadArrays;

@end

@implementation UploadMorephontosVC
- (void)dealloc
{
    TT_RELEASE_SAFELY(_tableView);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    [self setupNaviBarWithTitle:@"传输列表"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:@"上传" img:nil];

    _completeArrays    = [NSMutableArray array];
    WEAKSELF;
    [_assetArrays enumerateObjectsUsingBlock:^(NSDictionary *objDict, NSUInteger idx, BOOL * _Nonnull stop) {
        ALAsset *asset = objDict[@"asset"];
        NSMutableDictionary *assetDictionary = [[NSMutableDictionary alloc] init];
        [assetDictionary setObjectWithNullValidate:[UIImage imageWithCGImage:asset.thumbnail] forKey:@"thumbnail"];
        [assetDictionary setObjectWithNullValidate:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"fullScreenImage"];
        [assetDictionary setObjectWithNullValidate:asset.defaultRepresentation.filename forKey:@"filename"];
        [weakSelf.uploadArrays addObject:assetDictionary];
    }];
    [self.view addSubview:self.tableView];
}
- (void)leftBtnAction
{
    if (_isStart == NO) {
        if (_reloadBlock) {
            _reloadBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleDEL withTitle:@"关闭页面后任务终止,是否关闭?" withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:nil];
        alertWindow.tag = 7003;
        [self.view addSubview:alertWindow];
    }
}
- (void)rightBtnAction
{
    [PublicFunction ShareInstance].picToken = @"";//每次暂停清空token
    _isStart = !_isStart;
    if (_isStart == YES) {
        [self.rightBtn setTitle:@"取消" forState:0];
    }else {
        [ZhouDao_NetWorkManger cancelAllRequest];
        [self.rightBtn setTitle:@"上传" forState:0];
    }
    [_tableView reloadData];
}
#pragma mark  ZD_AlertWindowPro
- (void)alertView:(ZD_AlertWindow *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withName:(NSString *)name withIndexPath:(NSIndexPath *)indexPath {
    if (alertView.tag == 7003) {
        
        if (_isStart == YES) {
            _isStart = NO;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        [ZhouDao_NetWorkManger cancelAllRequest];

        if (_reloadBlock) {
            _reloadBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 7004){
        // 重命名
        NSMutableDictionary *dict = _uploadArrays[indexPath.row];
        [dict setObject:name forKey:@"filename"];
        
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)?[_uploadArrays count]:[_completeArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UploadTableViewCell *cell = (UploadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:UPLOADPHOTOIDENTIFER];
    cell.uploadDelegate = self;
    cell.isStart = _isStart;
    cell.caseId = _caseId;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        cell.delegate = self;

        if (_uploadArrays.count >0) {
            [cell settingUIWithDictionary:_uploadArrays[row] withSection:section withRow:row];
            if (_isStart == NO) {
                cell.rightUtilityButtons = [self normalRightButtons];
            }
            if (row == 0 && _isStart == YES) {
                [cell setUploadImage];//上传图片
            }
        }
    }else {
        if (self.completeArrays.count >0) {
            [cell settingUIWithDictionary:_completeArrays[row] withSection:section withRow:row];
        }
        
    }
    return cell;
}
- (NSArray *)normalRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     KNavigationBarColor
                                                title:@"删除"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#dfdcdc"]
                                                title:@"重命名"];
    return rightUtilityButtons;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ConsultantHeadView *headView = [[ConsultantHeadView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40.f) withSection:section];
    headView.delBtn.hidden = YES;

    if (section == 0) {
        NSString *titString = [NSString stringWithFormat:@"上传(%ld)",[_uploadArrays count]];
        [headView setLabelText:titString];
    }else {
        NSString *titString = [NSString stringWithFormat:@"上传完成(%ld)",[_completeArrays count]];
        [headView setLabelText:titString];
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger row = cellIndexPath.row;
    if (index == 0) {//删除
        [_uploadArrays removeObjectAtIndex:row];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }else {
            ZD_AlertWindow *alertWindow = [[ZD_AlertWindow alloc] initWithStyle:ZD_AlertViewStyleRename withTitle:@"" withTextAlignment:NSTextAlignmentCenter delegate:self withIndexPath:cellIndexPath];
            alertWindow.tag = 7004;
            [self.view addSubview:alertWindow];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSUInteger section = indexPath.section;

    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            if (section == 0 && _isStart == NO) {
                return YES;
            }
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            if (section == 0 && _isStart == NO) {
                return YES;
            }
            return NO;
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - UploadTableViewPro
- (void)uploadCompletedRefreshesTheListwithRow:(NSInteger)row
{
    if (_uploadArrays.count >0) {
        [_completeArrays addObject:self.uploadArrays[0]];
//        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_uploadArrays removeObjectAtIndex:0];
//        [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        if (_uploadArrays.count == 0) {
            _isStart = NO;
            [self.rightBtn setTitle:@"" forState:0];
            self.rightBtn.enabled = NO;
        }
        [_tableView reloadData];
    }
}
#pragma mark - setters and getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[UploadTableViewCell class] forCellReuseIdentifier:UPLOADPHOTOIDENTIFER];
    }
    return _tableView;
}
- (NSMutableArray *)uploadArrays
{
    if (!_uploadArrays) {
        _uploadArrays = [NSMutableArray array];
    }
    return _uploadArrays;
}
- (NSMutableArray *)completeArrays
{
    if (!_completeArrays) {
        _completeArrays = [NSMutableArray array];
    }
    return _completeArrays;
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
