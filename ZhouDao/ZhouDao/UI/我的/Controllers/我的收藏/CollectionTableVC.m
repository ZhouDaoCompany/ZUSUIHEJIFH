//
//  CollectionTableVC.m
//  ZhouDao
//
//  Created by cqz on 16/3/12.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CollectionTableVC.h"
#import "CollectEmptyView.h"
#import "MoveTopTabViewCell.h"
#import "ContentViewController.h"
#import "TemplateDetailVC.h"
#import "LawDetailModel.h"
#import "TaskModel.h"
#import "ExampleDetailData.h"
#import "IndemnityData.h"
#import "GovListmodel.h"
#import "GovernmentDetailVC.h"

static NSString *const COLLECTIDENTIFER = @"collectionCellIdentifer";
@interface CollectionTableVC ()<SWTableViewCellDelegate>
{
    NSUInteger _page;
}
@property (nonatomic,strong) CollectEmptyView *emptyView;   //收藏为空时候
@property (nonatomic, strong) NSMutableArray *normalArr;    //普通数组
@property (nonatomic, strong) NSMutableArray *zdArr;        //置顶数组
@property (nonatomic, copy)   NSString *recordStr;
@end

@implementation CollectionTableVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_typeString isEqualToString:_recordStr]) {
        [self loadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initUI];
}
- (void)initUI
{
    _normalArr = [NSMutableArray array];
    _zdArr = [NSMutableArray array];
    _page = 0;
    float height = self.view.frame.size.height;
    self.emptyView = [[CollectEmptyView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, height) WithText:@"暂无收藏"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   self.tableView.backgroundColor = ViewBackColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"MoveTopTabViewCell" bundle:nil] forCellReuseIdentifier:COLLECTIDENTIFER];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downRefresh:)];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self loadData];
}
- (void)loadData{
    WEAKSELF;
    [SVProgressHUD show];
    _page =0;
    [NetWorkMangerTools collectionListMine:_typeString withPage:_page RequestSuccess:^(NSArray *zdArr, NSArray *comArr) {
        
        [weakSelf.zdArr removeAllObjects];
        [weakSelf.normalArr removeAllObjects];

        [weakSelf.zdArr addObjectsFromArray:zdArr];
        [weakSelf.normalArr addObjectsFromArray:comArr];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        _page++;
    } fail:^{
        
        [weakSelf.zdArr removeAllObjects];
        [weakSelf.normalArr removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
#pragma mark ------ 上拉加载
- (void)downRefresh:(id)sender
{WEAKSELF;
    [SVProgressHUD show];
    [NetWorkMangerTools collectionListMine:_typeString withPage:_page RequestSuccess:^(NSArray *zdArr, NSArray *comArr) {
        [_zdArr addObjectsFromArray:zdArr];
        [_normalArr addObjectsFromArray:comArr];
        [weakSelf.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        _page++;
    } fail:^{
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.normalArr.count ==0 && self.zdArr.count == 0) {
        [self.view addSubview:self.emptyView];
        [self.view bringSubviewToFront:self.tableView];
    }else{
        if (self.emptyView) {
            [self.emptyView removeFromSuperview];
        }
    }
    if (section == 0) {
        return [self.zdArr count];
    }
    return [self.normalArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoveTopTabViewCell  *cell = (MoveTopTabViewCell *)[tableView dequeueReusableCellWithIdentifier:COLLECTIDENTIFER];
    if (indexPath.section == 0)
    {//置顶
        if (_zdArr.count >0) {
            [cell setDataModel:_zdArr[indexPath.row]];
            cell.rightUtilityButtons = [self zdRightButtons];
        }
    }else{//普通
        if (_normalArr.count>0) {
            [cell setDataModel:_normalArr[indexPath.row]];
            cell.rightUtilityButtons = [self normalRightButtons];
        }
    }
    [cell setMoveSection:indexPath.section];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{WEAKSELF;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    CollectionData *model;
    if (section == 0) {
        model = _zdArr[row];
    }else{
        model = _normalArr[row];
    }
    
    _recordStr = _typeString;
    if ([_typeString isEqualToString:@"1"]) {
        TaskModel *tmodel = [TaskModel new];
        [NetWorkMangerTools lawsDetailData:model.article_id RequestSuccess:^(id obj) {
            
            LawDetailModel *tempModel = (LawDetailModel *)obj;
            tmodel.idString =tempModel.id;
            tmodel.name = tempModel.name;
            tmodel.content = tempModel.content;
            tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
            ContentViewController *vc = [ContentViewController new];
            vc.dType = lawsType;
            vc.model = tmodel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }else if ([_typeString isEqualToString:@"2"]){
        [NetWorkMangerTools goverDetailWithId:model.article_id RequestSuccess:^(id obj) {
            
            GovListmodel *tempModel = (GovListmodel *)obj;
            GovernmentDetailVC *vc = [GovernmentDetailVC new];
            vc.model = tempModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }else if ([_typeString isEqualToString:@"3"]){
        TaskModel *tmodel = [TaskModel new];
        [NetWorkMangerTools loadExampleDetailData:model.article_id RequestSuccess:^(id obj) {
            
            ExampleDetailData *tempModel = (ExampleDetailData *)obj;
            tmodel.idString =tempModel.id;
            tmodel.name = tempModel.title;
            tmodel.content = tempModel.content;
            tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
            ContentViewController *vc = [ContentViewController new];
            vc.dType = CaseType;
            vc.model = tmodel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];

    }else if ([_typeString isEqualToString:@"4"]){
        TemplateDetailVC *detailVC = [TemplateDetailVC new];
        detailVC.idString = model.article_id;
        [weakSelf.navigationController  pushViewController:detailVC animated:YES];
    }else{
        TaskModel *tModel = [TaskModel new];
        [NetWorkMangerTools getcompensationDetailswith:model.article_id RequestSuccess:^(id obj) {
            
            IndemnityData *dataModel = (IndemnityData *)obj;
            tModel.idString = dataModel.id;
            tModel.content = dataModel.content;
            tModel.name = dataModel.title;
            tModel.is_collection = [NSString stringWithFormat:@"%@",dataModel.is_collection];
            ContentViewController *contentVC = [ContentViewController new];
            contentVC.dType = IndemnityType;
            contentVC.model = tModel;
            [weakSelf.navigationController pushViewController:contentVC animated:YES];
        }];
    }
    
}
- (NSArray *)zdRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     KNavigationBarColor
                                                title:@"取消置顶"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#dfdcdc"]
                                                title:@"删除收藏"];
    return rightUtilityButtons;
}

- (NSArray *)normalRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     KNavigationBarColor
                                                title:@"置顶"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithHexString:@"#dfdcdc"]
                                                title:@"删除收藏"];
    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            DLog(@"utility buttons closed");
            break;
        case 1:
            DLog(@"left utility buttons open");
            break;
        case 2:
            DLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{WEAKSELF;
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSUInteger section = cellIndexPath.section;
    NSUInteger row = cellIndexPath.row;
    
    switch (index) {
        case 0:
        {DLog(@"置顶按钮被点击");
            if (section == 0)
            {//取消置顶
                CollectionData *model1 = _zdArr[row];
                [NetWorkMangerTools collectionTopDelMine:model1.id RequestSuccess:^{
                    
                    [_zdArr removeObject:model1];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath]withRowAnimation:UITableViewRowAnimationNone];
                    [_normalArr insertObject:model1 atIndex:0];
                    [weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
//                [self.tableView reloadData];
            }else{//置顶
                CollectionData *model = _normalArr[row];
                [NetWorkMangerTools collectionTopMine:model.id RequestSuccess:^{
                    [_normalArr removeObject:model];
                    [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath]withRowAnimation:UITableViewRowAnimationNone];
                    [_zdArr insertObject:model atIndex:0];
                    [weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            //[cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {// 删除收藏
            CollectionData *delModel;
            if (section == 0) {
                delModel = _zdArr[row];
            }else{
                delModel = _normalArr[row];
            }
            [NetWorkMangerTools collectionDelMine:delModel.article_id withType:_typeString RequestSuccess:^{
                [weakSelf.tableView beginUpdates];
                if (section ==0) {
                    [_zdArr removeObjectAtIndex:cellIndexPath.row];
                }else{
                    [_normalArr removeObjectAtIndex:cellIndexPath.row];
                }
                [weakSelf.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [weakSelf.tableView endUpdates];
            }];
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
