//
//  SocialResultViewController.m
//  ZhouDao
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 CQZ. All rights reserved.
//

#import "SocialResultViewController.h"
#import "SocialHeadView.h"
#import "SocialResultCell.h"
#import "ParallaxHeaderView.h"
#import "PlistFileModel.h"

static NSString *const RESULTCELLIDENTIFER = @"SocialCellIdentifer";

@interface SocialResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ParallaxHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataSourceArrays;
@property (nonatomic, strong) NSMutableDictionary *showDictionary;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation SocialResultViewController

- (instancetype)initWithDetailDictionary:(NSMutableDictionary *)showDictionary
{
    self = [super init];
    if (self) {
        
        _showDictionary = showDictionary;
    }
    return self;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

#pragma mark - methods
- (void)initUI { WEAKSELF;
    
    [self setupNaviBarWithTitle:@"社保计算器结果"];
    [self setupNaviBarWithBtn:NaviLeftBtn title:nil img:@"backVC"];
    [self setupNaviBarWithBtn:NaviRightBtn title:nil img:@"Case_WhiteSD"];
    
    NSDictionary *fileDictionary = _showDictionary[@"fileDictionary"];
    NSArray *keyArrays = @[@"yanglaoxian",@"yiliaoxian",@"shiyexian",@"gongshangxian",@"shengyuxian",@"gongjijin"];
    
    [keyArrays enumerateObjectsUsingBlock:^(NSString *objString, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *objDictionary = fileDictionary[objString];
        PlistFileModel *model = [[PlistFileModel alloc] initWithDictionary:objDictionary];
        [weakSelf.dataSourceArrays addObject:model];
    }];
    [self.view addSubview:self.tableView];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        [(ParallaxHeaderView*)_tableView.tableHeaderView  layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArrays count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    SocialResultCell *cell = (SocialResultCell *)[tableView dequeueReusableCellWithIdentifier:RESULTCELLIDENTIFER   ];
    NSInteger row = indexPath.row;
    if (_dataSourceArrays.count >0) {
        PlistFileModel *fileModel = _dataSourceArrays[row];
        [cell setShowUIWithDictionary:fileModel withIndexRow:row];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return (section == 0)?[SocialHeadView instanceSocialHeadViewWithDictionary:_showDictionary]:nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 145.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

#pragma mark - setter and getter
#pragma mark -手势
- (void)dismissKeyBoard {
    
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissKeyBoard];
}
#pragma mark - setter and getter
-(UITableView *)tableView{ WEAKSELF;
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kMainScreenWidth, kMainScreenHeight-64.f) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[SocialResultCell class] forCellReuseIdentifier:RESULTCELLIDENTIFER];
        _headerView = [ParallaxHeaderView parallaxHeaderViewWithImage:[QZManager createImageWithColor:hexColor(00c8aa) size:CGSizeMake(kMainScreenWidth, 145)] forSize:CGSizeMake(kMainScreenWidth, 1)];
        _tableView.tableHeaderView = _headerView;
        _tableView.tableFooterView = self.bottomLabel;
        [_tableView whenCancelTapped:^{
            
            [weakSelf dismissKeyBoard];
        }];

    }
    return _tableView;
}
- (NSMutableArray *)dataSourceArrays {
    
    if (!_dataSourceArrays) {
        
        _dataSourceArrays = [NSMutableArray array];
    }
    return _dataSourceArrays;
}
- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 30)];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = hexColor(999999);
        _bottomLabel.font = Font_12;
        _bottomLabel.text = [NSString stringWithFormat:@"个人所得税:%@, 国内个税起征点3500元",_showDictionary[@"geshui"]];
    }
    return _bottomLabel;
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
