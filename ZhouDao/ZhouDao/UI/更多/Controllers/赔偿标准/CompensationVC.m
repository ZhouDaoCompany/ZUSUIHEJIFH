//
//  CompensationVC.m
//  ZhouDao
//
//  Created by cqz on 16/4/10.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "CompensationVC.h"
#import "CompensationTabCell.h"
#import "TwoCompensationVC.h"
static NSString *const CompensationIdentifier = @"CompensationIdentifier";

@interface CompensationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArrays;
@property (strong, nonatomic) NSMutableArray *imgArrays;
@property (nonatomic, strong) UIImageView *falseImgView;

@end

@implementation CompensationVC
- (void)dealloc
{
    TTVIEW_RELEASE_SAFELY(_falseImgView);
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}
- (void)initUI{
    
    [self setupNaviBarWithTitle:@"赔偿标准"];
    if (_pType == CompensationFromHome) {
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
    [self.view addSubview:self.tableView];
    
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompensationTabCell *cell = (CompensationTabCell *)[tableView dequeueReusableCellWithIdentifier:CompensationIdentifier];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.f;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CompensationTabCell class]])
    {
        CompensationTabCell *compensationCell = (CompensationTabCell *)cell;
        UIImage *image = [UIImage imageNamed:self.imgArrays[indexPath.row]];
        compensationCell.DetailImgView.image = image;
        compensationCell.titleLab.text =self.dataArrays[indexPath.row];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *comId = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    TwoCompensationVC *vc = [TwoCompensationVC new];
    vc.classId = comId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -UIButtonEvent
- (void)leftBtnAction
{
    if (_pType == CompensationFromHome) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - setter and getter
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
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerNib:[UINib nibWithNibName:@"CompensationTabCell" bundle:nil] forCellReuseIdentifier:CompensationIdentifier];
    }
    return _tableView;
}
- (NSMutableArray *)dataArrays
{
    if (!_dataArrays) {
        _dataArrays = [NSMutableArray arrayWithObjects:@"交通事故赔偿标准",@"工伤事故赔偿标准",@"医疗事故赔偿标准", nil];
    }
    return _dataArrays;
}
- (NSMutableArray *)imgArrays
{
    if (!_imgArrays) {
        _imgArrays = [NSMutableArray arrayWithObjects:@"pc_jiaotong",@"pc_gongshang",@"pc_yiliao", nil];
    }
    return _imgArrays;
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
