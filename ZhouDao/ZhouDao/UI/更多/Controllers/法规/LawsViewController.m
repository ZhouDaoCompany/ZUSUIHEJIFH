//
//  LawsViewController.m
//  ZhouDao
//
//  Created by cqz on 16/3/27.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "LawsViewController.h"
#import "LawSview.h"
#import "LawsTableViewCell.h"
#import "SecrchLawsVC.h"
#import "ContentViewController.h"
#import "LocalLawsVC.h"
#import "MyCollectionVC.h"
#import "NewsLawsVC.h"
#import "LawDetailModel.h"
#import "TaskModel.h"
#import "LoginViewController.h"
//static NSString *const CellIdentifier = @"TabCellIdentifier";
static NSString *const twoCellIdentifier = @"twoTabCellIdentifier";

#define kImageOriginHight 220
//#define kHeaderImageHeight     self.view.bounds.size.width*(150/375.0f)

@interface LawsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArrays;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LawSview* headView;
@property (nonatomic, strong) UIImageView *falseImgView;
@property (nonatomic, strong) UIButton *moreBtn;
  
@end

@implementation LawsViewController
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}
- (void)initView
{
    WEAKSELF;
    [self setupNaviBarWithTitle:@"法律法规"];
    if (_lawType == LawFromHome) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    }else{
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        UIWindow *windows = [QZManager getWindow];
        [windows addSubview:self.falseImgView];
        [windows sendSubviewToBack:self.falseImgView];
        [AnimationTools makeAnimationBottom:self.view];
    }
    self.navigationController.navigationBarHidden = YES;

    _dataArrays = [NSMutableArray array];
    _headView = [[LawSview alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 270)];
    _headView.searchBlock = ^(){
        
        SecrchLawsVC *searchVC = [SecrchLawsVC new];
        [AnimationTools makeAnimationFade:searchVC :weakSelf.navigationController];
    };
    
    _headView.indexBlock = ^(NSInteger index){
        if (index == 3) {
            if ([PublicFunction ShareInstance].m_bLogin == NO) {
                LoginViewController *loginVc = [LoginViewController new];
                loginVc.closeBlock = ^{
                    if ([PublicFunction ShareInstance].m_bLogin == YES)
                    {
                        MyCollectionVC *mcVC = [MyCollectionVC new];
                        [weakSelf.navigationController pushViewController:mcVC animated:YES];
                    }
                };
                [weakSelf presentViewController:[[UINavigationController alloc]initWithRootViewController:loginVc] animated:YES completion:nil];
            }else{
                MyCollectionVC *mcVC = [MyCollectionVC new];
                [weakSelf.navigationController pushViewController:mcVC animated:YES];
            }
        }else if (index == 2){
            LocalLawsVC *localVC = [LocalLawsVC new];
            [weakSelf.navigationController pushViewController:localVC animated:YES];
        }else if (index == 0){
            NewsLawsVC *vc = [NewsLawsVC new];
            vc.lawType = newsSDType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else{
            NewsLawsVC *vc = [NewsLawsVC new];
            vc.lawType = commonlyType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    [self.view addSubview:_headView];
    
    [self.view addSubview:self.tableView];

    //MJRefreshBackNormalFooter MJRefreshAutoNormalFooter
   //    // 马上进入刷新状态
//    [_tableView.mj_header beginRefreshing];
    
    [self loadNewData];

   /* UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = ViewBackColor;
    [moreBtn setTitleColor:sixColor forState:0];
    moreBtn.titleLabel.font = Font_14;
    moreBtn.frame = CGRectMake(0, 0, kMainScreenWidth , 40);
    [moreBtn setTitle:@"点击查看更多" forState:0];
    [moreBtn addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn = moreBtn;
    _tableView.tableFooterView = _moreBtn;*/
}
#pragma mark - 请求
- (void)loadNewData{
    WEAKSELF;
    [NetWorkMangerTools lawsNewsListRequestSuccess:^(NSArray *arr) {
        
        [weakSelf.dataArrays removeAllObjects];
        [weakSelf.dataArrays addObjectsFromArray:arr];
        [weakSelf.tableView reloadData];
    } fail:^{
    }];
}
#pragma mark ------ 下拉刷新
- (void)upRefresh:(id)sender
{
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showMBLoadingWithText:@"正在加载..."];

    [self loadNewData];
}
#pragma mark
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawsTableViewCell*cell = (LawsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:twoCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[LawsTableViewCell class]]) {
        LawsTableViewCell *lawCell = (LawsTableViewCell *)cell;
        if (_dataArrays.count >0) {
            [lawCell setDataModel:_dataArrays[indexPath.row]];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LawsDataModel *model = _dataArrays[indexPath.row];
    TaskModel *tmodel = [TaskModel new];
    [NetWorkMangerTools lawsDetailData:model.id RequestSuccess:^(id obj) {
        
        LawDetailModel *tempModel = (LawDetailModel *)obj;
        tmodel.idString =tempModel.id;
        tmodel.name = model.name;
        tmodel.content = tempModel.content;
        tmodel.is_collection = [NSString stringWithFormat:@"%@",tempModel.is_collection];
        ContentViewController *vc = [ContentViewController new];
        vc.dType = lawsType;
        vc.model = tmodel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark -UIButtonEvent
- (void)leftBtnAction
{
    if (_lawType == LawFromHome) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)loadMoreData
{
    
}
#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator= NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _tableView.tableHeaderView = _headView;
        [_tableView registerNib:[UINib nibWithNibName:@"LawsTableViewCell" bundle:nil] forCellReuseIdentifier:twoCellIdentifier];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRefresh:)];
    }
    return _tableView;
}
- (UIImageView *)falseImgView
{
    if (!_falseImgView) {
        [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"wpp_readall_top_down_normal"];
        //假的截屏
        _falseImgView = [[UIImageView alloc] initWithFrame:kMainScreenFrameRect];
        _falseImgView.image = [QZManager capture];
    }
    return _falseImgView;
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
