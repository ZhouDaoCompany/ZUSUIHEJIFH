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

static NSString *const UPLOADPHOTOIDENTIFER = @"UploadMorephontosid";
@interface UploadMorephontosVC ()<UITableViewDelegate,UITableViewDataSource,UploadTableViewPro>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *completeThumbArrays;//上传完成数组
@property (strong, nonatomic) NSMutableArray *completeFullArrays;//上传完成数组

@property (strong, nonatomic) NSMutableArray *uploadThumbArrays;
@property (strong, nonatomic) NSMutableArray *uploadFullArrays;

@end

@implementation UploadMorephontosVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initUI];
}
#pragma mark - private methods
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"传输列表"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];

    _uploadFullArrays    = [NSMutableArray array];
    _uploadThumbArrays   = [NSMutableArray array];
    _completeFullArrays  = [NSMutableArray array];
    _completeThumbArrays = [NSMutableArray array];
    [_uploadFullArrays addObjectsFromArray:_fullScreenArrays];
    [_uploadThumbArrays addObjectsFromArray:_thumbnailArrays];

    [self.view addSubview:self.tableView];
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)?[_completeFullArrays count]:[_completeThumbArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UploadTableViewCell *cell = (UploadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:UPLOADPHOTOIDENTIFER];
    cell.delegate = self;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (_uploadThumbArrays.count >0) {
            
            cell.iconImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
            [cell settingUIwithDictionary:_uploadArrays[row] withSection:section];
            if (row == 0) {
                [cell setUploadImage];//上传图片
            }
        }
        
    }else {
        if (self.completeArrays.count >0) {
            [cell settingUIwithDictionary:_completeArrays[row] withSection:section];
        }
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

#pragma mark - UploadTableViewPro
- (void)uploadCompletedRefreshesTheList
{
    if (_uploadArrays.count >0) {
        [_completeArrays addObject:self.uploadArrays[0]];
//        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_uploadArrays removeObjectAtIndex:0];
//        [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
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
